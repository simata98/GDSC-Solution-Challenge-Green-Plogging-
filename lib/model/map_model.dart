import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MapModel extends GetxController {
  static MapModel get to => Get.find<MapModel>();
  GoogleMapController? _mapController;
  Location _location = Location();
  final Set<Polyline> polyline = {};
  List<LatLng> route = [];
  final _dist = 0.0.obs;
  String _displayTime = "";
  final _time = 0.obs;
  final _lastTime = 0.obs;
  final _speed = 0.0.obs;
  final _avgSpeed = 0.0.obs;
  final _speedCounter = 0.obs;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  //여기 수정해야함
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    //여기에다가 코드 작성해야됨
    super.onClose();
  }

  void startRun() {
    final appendDist = 0.0.obs;

    _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: 15)));

      //여기에다가는 플로깅 상태일때를 수정해야함
      if (route.length > 0) {
        appendDist.value = Geolocator.distanceBetween(route.last.latitude,
            route.last.longitude, loc.latitude, loc.longitude);
        _dist.value = _dist.value + appendDist.value;
        int timeDuration = (_time.value - _lastTime.value);

        if (_lastTime != null && timeDuration != 0) {
          _speed.value = (appendDist / (timeDuration / 100)) * 3.6;
          if (_speed != 0) {
            _avgSpeed.value = _avgSpeed.value + _speed.value;
            _speedCounter.value++;
          }
        }
      }
      _lastTime.value = _time.value;
      route.add(loc);

      polyline.add(Polyline(
          polylineId: PolylineId(event.toString()),
          visible: true,
          points: route,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.deepOrange));
    });

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void stopRun() async {
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}
