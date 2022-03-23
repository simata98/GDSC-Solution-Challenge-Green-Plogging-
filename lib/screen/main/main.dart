import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdsc_solution/components/mainMapDrawer.dart';
import 'package:gdsc_solution/components/semiCircleWidget.dart';
import 'package:gdsc_solution/screen/main/main_dialog.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:gdsc_solution/model/geo_entry.dart';

class mapMain extends StatefulWidget {
  mapMain({Key? key}) : super(key: key);

  @override
  State<mapMain> createState() => _mapMainState();
}

class _mapMainState extends State<mapMain> {
  _mapMainState();

  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  PolylineId? selectedPolyline;

  final Set<Polyline> polyline = {};
  Location _location = Location();
  GoogleMapController? _mapController;
  LatLng _center = const LatLng(0, 0);
  List<LatLng> route = [];

  double _dist = 0;
  String _displayTime = "";
  int _time = 0;
  int _lastTime = 0;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _remove(PolylineId polylineId) {
    setState(() {
      if (polylines.containsKey(polylineId)) {
        polylines.remove(polylineId);
      }
      selectedPolyline = null;
    });
  }

  void _add() {
    final PolylineId polylineId = PolylineId('polyline');

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];

    points.add(_createLatLng(51.4816, -3.1791));
    points.add(_createLatLng(53.0430, -2.9925));
    points.add(_createLatLng(53.1396, -4.2739));
    points.add(_createLatLng(52.4153, -4.0829));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    double appendDist;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 15)));

      if (route.length > 0) {
        appendDist = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        _dist = _dist + appendDist;
        int timeDuration = (_time - _lastTime);

        if (_lastTime != null && timeDuration != 0) {
          _speed = (appendDist / (timeDuration / 100)) * 3.6;
          if (_speed != 0) {
            _avgSpeed = _avgSpeed + _speed;
            _speedCounter++;
          }
        }
      }
      _lastTime = _time;
      route.add(loc);

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.deepOrange));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Check IOS Platform
    final bool isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _scrrenHeight = MediaQuery.of(context).size.height;

    //앱바 높이
    final double _appBarHeight = _scrrenHeight * 0.065;

    return Scaffold(
        drawer: Container(
            width: _screenWidth * 0.7,
            child: Drawer(child: new mainMapDrawer())),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(_appBarHeight),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Image.asset('assets/logo.png', width: _appBarHeight),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => {Get.dialog(new mainDialog())},
                icon: const Icon(Icons.help),
                color: CustomColor.primary,
              )
            ],
          ),
        ),
        body: Stack(children: [
          Container(
              child: GoogleMap(
            polylines: polyline,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11),
          )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                //이것을 안하면 클릭할때 효과(ripple)이 네모로 나옴!! 필수!!
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
                color: CustomColor.primary,
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        height: _scrrenHeight * 0.4,
                        color: Colors.white,
                        child: Center(
                          child: Text('BottomSheet'),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 176,
                    height: 86,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                        child: Text(
                      "START",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ))
        ]));
  }
}
