import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';

class SlidingPanelBottomFirst extends StatefulWidget {
  SlidingPanelBottomFirst({Key? key}) : super(key: key);

  @override
  State<SlidingPanelBottomFirst> createState() =>
      _SlidingPanelBottomFirstState();
}

class _SlidingPanelBottomFirstState extends State<SlidingPanelBottomFirst> {
  File? _image;

  Future pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);

      return image;
    } on PlatformException catch (e) {
      print('Failed to camera!: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primaryBold,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {
                      if (!Get.isSnackbarOpen) {
                        Get.snackbar(
                            'Stop Running', 'Long press button to exit',
                            margin: EdgeInsets.only(top: 20),
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                            backgroundColor: CustomColor.primary,
                            duration: const Duration(seconds: 2),
                            colorText: Colors.white,
                            icon: Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 30,
                            ),
                            snackPosition: SnackPosition.TOP);
                      }
                    },
                    onLongPress: () async {
                      //일단 스탑워치 종료
                      MapModel.to.pauseRun();

                      //카메라 적정한 곳으로 이동
                      MapModel.to.finishState.toggle();
                      LatLng tmploc = MapModel.to.runRoute
                          .elementAt(MapModel.to.runRoute.length ~/ 2);
                      MapModel.to.mapController?.moveCamera(
                          CameraUpdate.newLatLngZoom(tmploc, 14.0));

                      //기록된 것 저장
                      MapModel.to.tmpCity = await MapModel.to.getCity();
                      MapModel.to.mapImage = await MapModel.to.mapCapture();
                      MapModel.to.tmpDistance =
                          (MapModel.to.dist.value * 1000).toInt();
                      MapModel.to.tmpPlogPoint = MapModel.to.plogging.value;
                      MapModel.to.tmpRunTime = MapModel.to.time.value;
                      MapModel.to.tmpSpeed = MapModel.to.pace.toDouble();

                      //지도 이동 및 설정
                      MapModel.to.cameraZoom.value = 18.0;
                      final tmp = await pickImage();
                      MapModel.to.slidingPanelMinH.value = Get.height * 0.1;
                      MapModel.to.viewImage = File(tmp.path);
                      MapModel.to.slidingPanelType.value = 3;
                    },
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.35,
                      height: MapModel.to.panelHeight.value * 0.35,
                      child: Icon(
                        Icons.stop,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
          Flexible(
            flex: 4,
            child: Container(
              child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {
                      MapModel.to.pauseRun();
                      MapModel.to.slidingPanelType.value = 1;
                    },
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.35,
                      height: MapModel.to.panelHeight.value * 0.35,
                      child: Icon(
                        Icons.pause_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
