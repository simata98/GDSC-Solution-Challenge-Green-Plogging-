import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gdsc_solution/model/community.dart';
import 'package:gdsc_solution/model/record.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'dart:ui' as ui;

import '../theme/custom_color.dart';

class MapModel extends GetxController {
  static MapModel get to => Get.find<MapModel>();

  String currentPath = '/main';

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
  final pace = 0.0.obs;

  LatLng center = const LatLng(0, 0);

  final StopWatchTimer stopWatchTimer = StopWatchTimer();

  //러닝이 시작되었나 체크
  final start = false.obs;

  final startPlogging = false.obs;
  bool checkEndPlogging = false;

  //구글지도 줌 수치
  final cameraZoom = 17.0.obs;

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

  final globalKey = GlobalKey().obs;

  File? viewImage;
  File? mapImage;

  int? tmpDistance;
  int? tmpRunTime;
  int? tmpPlogPoint;
  double? tmpSpeed;
  String? tmpCity;

  //for community
  DateTime? postTime;

  final finishState = false.obs;

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
      stopWatchTimer.rawTime.listen((value) => {time.value = value});
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  void resetRun() {
    init();
  }

  void pauseRun() {
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    if (MapModel.to.slidingPanelType == 3) {}
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

      if (!finishState.value) {
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: loc, zoom: cameraZoom.value)));
      }

      if (start.value) {
        //여기에다가는 플로깅 상태일때를 수정해야함
        if (runRoute.length > 0) {
          if (!startPlogging.value) {
            if (checkEndPlogging) {
              appendDist.value = 0.0;
              checkEndPlogging == false;
            } else {
              appendDist.value = Geolocator.distanceBetween(
                  runRoute.last.latitude,
                  runRoute.last.longitude,
                  loc.latitude,
                  loc.longitude);
            }

            dist.value = dist.value + appendDist.value;
            if (dist != 0) {
              pace.value = time / dist.value;
            }
          } else {
            if (checkEndPlogging != true) {
              checkEndPlogging == true;
            }
          }
        }
        lastTime.value = time.value;
        print('test');

        runRoute.add(loc);

        String polylineId = "";
        List<LatLng> tmp = [];
        if (runRoute.length >= 2) {
          LatLng locTmp1 = runRoute[runRoute.length - 2];
          LatLng locTmp2 = runRoute.last;
          tmp.add(locTmp1);
          tmp.add(locTmp2);
          polylineId = "$locTmp1 to $locTmp2";
        }

        if (startPlogging.value) {
          MapModel.to.polyline.add(Polyline(
              polylineId: PolylineId(polylineId),
              visible: true,
              points: tmp,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              color: Colors.green));
        } else {
          MapModel.to.polyline.add(Polyline(
              polylineId: PolylineId(polylineId),
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
    pace.value = 0.0;
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

  Future<File> mapCapture() async {
    Future<File> imageFile;
    var fileName;
    var tempDir;

    //final directory = (await getApplicationDocumentsDirectory()).path;

    Uint8List? pngBytes = await mapController?.takeSnapshot();
    fileName = "${DateTime.now()}.jpg";
    tempDir = (await getTemporaryDirectory()).path;

    imageFile = File('$tempDir/$fileName').writeAsBytes(pngBytes!);
    return imageFile;
  }

  Future<String> uploadView() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('post_images').child(
        FirebaseAuth.instance.currentUser!.uid.toString() +
            '_view_' +
            DateTime.now().toString());
    UploadTask ut1 = ref.putFile(MapModel.to.viewImage!);
    TaskSnapshot snapshot1 = await ut1;

    return await snapshot1.ref.getDownloadURL();
  }

  Future<String> uploadMap() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    File tmp = mapImage!;
    Reference ref1 = storage.ref().child('post_images').child(
        FirebaseAuth.instance.currentUser!.uid.toString() +
            '_map_' +
            DateTime.now().toString());
    UploadTask ut2 = ref1.putFile(tmp);
    TaskSnapshot snapshot2 = await ut2;

    return await snapshot2.ref.getDownloadURL();
  }

  Future<String?> getCity() async {
    LatLng tmp = runRoute.last;
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      tmp.latitude,
      tmp.longitude,
    );

    return await placemarks[0].locality;
  }

  Future<void> uploadRecord() async {
    String viewUrl = await uploadView();
    String mapUrl = await uploadMap();

    Record record = Record();
    record.map = mapUrl;
    record.view = viewUrl;
    record.distance = tmpDistance;
    record.runTime = tmpRunTime;
    record.plogPoint = tmpPlogPoint;
    record.speed = tmpSpeed;
    record.city = tmpCity;
    record.time = DateTime.now();

    FirebaseFirestore.instance
        .collection('records')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('saved')
        .add(record.toMap());
    print("####################end to recording##############");

    //유저 totalRun, totalPlog 최신화
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'totalRun': FieldValue.increment(tmpDistance!)});

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'totalPlog': FieldValue.increment(tmpPlogPoint!)});

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'point': FieldValue.increment(tmpPlogPoint! * 10)});
  }

  Future<void> uploadCommunity(String comment) async {
    String viewUrl = await MapModel.to.uploadView();
    String mapUrl = await MapModel.to.uploadMap();

    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    Community community = Community(
        city: tmpCity,
        distance: tmpDistance,
        map: mapUrl,
        view: viewUrl,
        plogPoint: tmpPlogPoint,
        runTime: tmpRunTime,
        speed: tmpSpeed,
        uid: uid,
        time: postTime,
        comment: comment);

    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection('posts')
        .add(community.toMap());

    print("####################end to posting##############");
  }
}
