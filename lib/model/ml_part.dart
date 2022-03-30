import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../theme/custom_color.dart';
import 'map_model.dart';

class MlPart extends GetxController {
  static MlPart get to => Get.find<MlPart>();
  File? _image;
  final _picker = ImagePicker();
  final outputs = [].obs;

  final captured = false.obs;
  //여기 수정해야함
  @override
  void onInit() {
    Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    ).then((value) => print('load'));
    super.onInit();
  }

  Future getImage(ImageSource imageSource) async {
    final image = await _picker.pickImage(source: imageSource);
    _image = File(image!.path); // 가져온 이미지를 _image에 저장
    captured.toggle();

    classifyImage(File(image.path)); // 가져온 이미지를 분류 하기 위해 await을 사용
  }

  // 이미지 분류
  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 1.0, // defaults to 1.0
        numResults: 4, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    print(output);
    Map tmp = output![0];
    if (tmp['confidence'] >= 0.95) {
      MapModel.to.plogging.value++;
      MapModel.to.makeMarker(20.0, Colors.purple);

      Get.snackbar('Success to Plogging!',
          '${MapModel.to.plogging} time(s) plogging now...',
          margin: EdgeInsets.only(top: 20),
          maxWidth: Get.width * 0.8,
          backgroundColor: CustomColor.primary,
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
          icon: Icon(
            Icons.recycling_rounded,
            color: Colors.white,
            size: 30,
          ),
          snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Failed to Plogging!', 'Please make it recognized agina',
          margin: EdgeInsets.only(top: 20),
          maxWidth: Get.width * 0.8,
          backgroundColor: CustomColor.primary,
          duration: const Duration(seconds: 2),
          colorText: Colors.white,
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
            size: 30,
          ),
          snackPosition: SnackPosition.TOP);
    }

    //Future.delayed(Duration(seconds: 3), () {
    //  Get.back();
    //});
  }
}
