import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../theme/custom_color.dart';

class SlidingBody extends StatefulWidget {
  final PanelController panelController;
  final double appbarHeight;
  SlidingBody(
      {Key? key, required this.panelController, this.appbarHeight = 0.0})
      : super(key: key);

  @override
  State<SlidingBody> createState() => _SlidingBodyState(
      panelController: panelController, appbarHeight: appbarHeight);
}

class _SlidingBodyState extends State<SlidingBody> {
  final PanelController panelController;
  final double appbarHeight;
  _SlidingBodyState({required this.panelController, this.appbarHeight = 0.0});

  //구글지도에 필요한 것들
  GoogleMapController? _mapController;
  final Set<Polyline> polyline = {};
  LatLng _center = const LatLng(0, 0);
  List<LatLng> route = [];
  Location _location = Location();
  double _dist = 0;
  String _displayTime = "";
  int _time = 0;
  int _lastTime = 0;
  double _speed = 0;
  double _avgSpeed = 0;
  int _speedCounter = 0;

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
    return Stack(
      children: [
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
            heightFactor: 10,
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
                  panelController.open();
                },
                child: Container(
                  // 이것을 하는 이유는
                  // stack안에 stack이 들어가서 Appbar의 높이를 계산못
                  //하고 있다.
                  margin: EdgeInsets.only(bottom: appbarHeight),
                  width: 176,
                  height: 86,
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
            )),
      ],
    );
  }
}
