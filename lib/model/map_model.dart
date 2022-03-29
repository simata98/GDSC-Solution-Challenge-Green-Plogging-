import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'dart:ui' as ui;

import '../theme/custom_color.dart';

class MapModel extends GetxController {
  static MapModel get to => Get.find<MapModel>();

  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  Location _location = Location();
  StreamSubscription<LocationData>? locationSubscription;

  final polyline = Set<Polyline>().obs;

  List<LatLng> runRoute = [];

  final markers = Set<Marker>().obs;
  final markerSize = 100.0;
  final dist = 0.0.obs;
  String displayTime = "";
  final time = 0.obs;
  final lastTime = 0.obs;
  final speed = 0.0.obs;
  final avgSpeed = 0.0.obs;
  final speedCounter = 0.obs;
  final plogging = 0.obs;

  LatLng center = const LatLng(0, 0);

  final StopWatchTimer stopWatchTimer = StopWatchTimer();

  //러닝이 시작되었나 체크
  final start = false.obs;

  final startPlogging = false.obs;

  //구글지도 줌 수치
  final cameraZoom = 15.0.obs;

  //패널의 크기
  final panelHeight = 0.0.obs;
  final panelWidth = 0.0.obs;

  //가운데 컨테이너 크기
  //이것은 가운데 박스크기를 반응형으로 만들기 위함
  final centerConHeight = 0.0.obs;
  final centerConWidth = 0.0.obs;

  PanelController? panelController;

  //
  final slidingPanelType = 0.obs;
  final slidingPanelMinH = 0.0.obs;
  final slidingDraggable = true.obs;

  File? image;

  //여기 수정해야함
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() async {
    //여기에다가 코드 작성해야됨
    await stopWatchTimer.dispose(); // Need to call dispose function.
    super.onClose();
  }

  void startRun() {
    if (start.value) {
      locationSubscription?.resume();
      stopWatchTimer.rawTime.listen((value) => {time.value = value});
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  void resetRun() {
    init();
  }

  void pauseRun() {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    if (MapModel.to.slidingPanelType == 3) {
      locationSubscription?.cancel();
    }
  }

  void reRun() {
    stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  void startPlo() {
    startPlogging.toggle();
  }

  void stopPlo() {
    startPlogging.toggle();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    final appendDist = 0.0.obs;
    locationSubscription = _location.onLocationChanged.listen((event) {
      LatLng loc = LatLng(event.latitude!, event.longitude!);

      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: loc, zoom: cameraZoom.value)));

      if (start.value) {
        //여기에다가는 플로깅 상태일때를 수정해야함
        if (runRoute.length > 0) {
          appendDist.value = Geolocator.distanceBetween(runRoute.last.latitude,
              runRoute.last.longitude, loc.latitude, loc.longitude);
          dist.value = dist.value + appendDist.value;
          int timeDuration = (time.value - lastTime.value);

          if (lastTime != null && timeDuration != 0) {
            speed.value = (appendDist / (timeDuration / 100)) * 3.6;
            if (speed != 0) {
              avgSpeed.value = avgSpeed.value + speed.value;
              speedCounter.value++;
            }
          }
        }
        lastTime.value = time.value;

        runRoute.add(loc);

        List<LatLng> tmp = [];
        if (runRoute.length >= 2) {
          tmp.add(runRoute[runRoute.length - 2]);
          tmp.add(runRoute.last);
        }

        if (startPlogging.value) {
          polyline.add(Polyline(
              polylineId: PolylineId(event.toString()),
              visible: true,
              points: tmp,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              color: Colors.green));
        } else {
          polyline.add(Polyline(
              polylineId: PolylineId(event.toString()),
              visible: true,
              points: tmp,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              color: Colors.deepOrange));
        }

        update();
      }
    });
  }

  void init() {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    polyline.clear();
    runRoute.clear();
    markers.clear();
    dist.value = 0.0;
    displayTime = "";
    time.value = 0;
    lastTime.value = 0;
    speed.value = 0.0;
    avgSpeed.value = 0.0;
    speedCounter.value = 0;
    plogging.value = 0;
    panelController?.close();
    start.toggle();
  }

  //canvas로 그려서 가져오기
  Future<Uint8List> getBytesFromCanvas(double radius, Color color) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    ;

    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final img = await pictureRecorder
        .endRecording()
        .toImage((radius * 2).toInt(), (radius * 2).toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return data!.buffer.asUint8List();
  }

  void makeMarker(double radius, Color color) async {
    LocationData loc = await _location.getLocation();
    markers.add(new Marker(
        markerId: MarkerId(markers.length.toString()),
        icon:
            BitmapDescriptor.fromBytes(await getBytesFromCanvas(radius, color)),
        onTap: () {},
        position: LatLng(loc.latitude!, loc.longitude!)));
    update();
  }

  void toggleScrollable() {
    this.slidingDraggable.toggle();
  }
}
