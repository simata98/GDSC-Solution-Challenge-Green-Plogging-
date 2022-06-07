import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/main/camera_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../../model/map_model.dart';
import '../../theme/custom_color.dart';
import '../../model/ml_part.dart';

class SlidingPanelBottomThird extends StatefulWidget {
  SlidingPanelBottomThird({Key? key}) : super(key: key);

  @override
  State<SlidingPanelBottomThird> createState() =>
      _SlidingPanelBottomThirdState();
}

class _SlidingPanelBottomThirdState extends State<SlidingPanelBottomThird> {
  @override
  Widget build(BuildContext context) {
    Get.put(MlPart());
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
            flex: 1,
            child: Container(
              child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () async {
                      Get.dialog(new CameraDialog());
                      //MlPart.to.getImage(ImageSource.camera);
                    },
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.35,
                      height: MapModel.to.panelHeight.value * 0.35,
                      child: Icon(
                        Icons.camera_alt,
                        size: MapModel.to.panelHeight.value * 0.20,
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
            child: Container(
              child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primary54,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () {
                      if (!Get.isSnackbarOpen) {
                        Get.snackbar(
                            'Stop Plogging', 'Long press button to exit',
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
                    onLongPress: () {
                      MapModel.to.stopPlo();
                      MapModel.to.slidingPanelType.value = 1;
                    },
                    child: Container(
                      width: MapModel.to.panelHeight.value * 0.20,
                      height: MapModel.to.panelHeight.value * 0.20,
                      child: Icon(
                        Icons.stop,
                        size: MapModel.to.panelHeight.value * 0.15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
