import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../../model/map_model.dart';
import '../../model/painters/object_detector_painter.dart';
import '../../theme/custom_color.dart';
import 'camera_view.dart';

List<CameraDescription> cameras = [];

enum ScreenMode { liveFeed, gallery }

class CameraDialog extends StatefulWidget {
  CameraDialog({Key? key}) : super(key: key);

  @override
  State<CameraDialog> createState() => _CameraDialogState();
}

class _CameraDialogState extends State<CameraDialog> {
  late ObjectDetector _objectDetector;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  List<DetectedObject>? _objects;

  late double _cameraHeight;
  late double _cameraWidth;

  @override
  void initState() {
    super.initState();

    _initializeDetector(DetectionMode.stream);
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenHeight = MediaQuery.of(context).size.height;
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _dialogHeight = _screenHeight * 0.8;
    final double _dialogWidth = _screenWidth * 0.8;
    final double _cameraHeight = _dialogHeight * 0.8;
    final double _cameraWidth = _dialogWidth;

    this._cameraHeight = _cameraHeight;
    this._cameraWidth = _cameraWidth;

    return Dialog(
      child: Container(
        color: CustomColor.primaryAccent,
        height: _dialogHeight,
        child: Column(
          children: [
            SizedBox(
              height: _dialogHeight * 0.03,
            ),
            Container(
              height: _cameraHeight,
              width: _cameraWidth,
              child: CameraView(
                title: 'Object Detector',
                customPaint: _customPaint,
                text: _text,
                onImage: (inputImage) {
                  processImage(inputImage);
                },
                //onScreenModeChanged: _onScreenModeChanged,
                initialDirection: CameraLensDirection.back,
              ),
            ),
            Expanded(
              child: Container(
                  child: Center(
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  color: CustomColor.primaryBold,
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: InkWell(
                    onTap: () async {
                      pickup();
                    },
                    child: Container(
                      width: _dialogHeight * 0.2,
                      height: _dialogHeight * 0.1,
                      child: Center(
                          child: Text('Pick Up',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700))),
                    ),
                  ),
                ),
              )),
            )
          ],
        ),
      ),
    );
  }

  void _onScreenModeChanged(ScreenMode mode) {
    switch (mode) {
      case ScreenMode.gallery:
        _initializeDetector(DetectionMode.singleImage);
        return;

      case ScreenMode.liveFeed:
        _initializeDetector(DetectionMode.stream);
        return;
    }
  }

  void _initializeDetector(DetectionMode mode) async {
    print('Set detector in mode: $mode');

    // uncomment next lines if you want to use the default model
    // final options = ObjectDetectorOptions(
    //     mode: mode,
    //     classifyObjects: true,
    //     multipleObjects: true);
    // _objectDetector = ObjectDetector(options: options);

    // uncomment next lines if you want to use a local model
    // make sure to add tflite model to assets/ml
    final path = 'assets/ml/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: mode,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    // uncomment next lines if you want to use a remote model
    // make sure to add model to firebase
    // final modelName = 'bird-classifier';
    // final response =
    //     await FirebaseObjectDetectorModelManager().downloadModel(modelName);
    // print('Downloaded: $response');
    // final options = FirebaseObjectDetectorOptions(
    //   mode: mode,
    //   modelName: modelName,
    //   classifyObjects: true,
    //   multipleObjects: true,
    // );
    // _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    _objects = await _objectDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      // 오브젝트 인식이 되면 실행하는 곳

      final painter = ObjectDetectorPainter(
          _objects!,
          inputImage.inputImageData!.imageRotation,
          inputImage.inputImageData!.size,
          _cameraHeight,
          _cameraWidth);
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Objects found: ${_objects?.length}\n\n';
      for (final object in _objects!) {
        text +=
            'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
      }
      _text = text;
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  void pickup() {
    if (_objects!.isNotEmpty) {
      bool checkDetected = false;
      for (final DetectedObject detectedObject in _objects!) {
        if (detectedObject.labels.isNotEmpty) {
          checkDetected = true;
        }
      }

      if (!checkDetected) {
        failed();
      } else {
        // 모든 예외 조건 제외한 정상적인 실행
        int i = 0;
        DetectedObject selectedObject = _objects![MapModel.to.selectedItem!];
        String tmpStr = '[ ';
        String labels = '';
        for (final Label label in selectedObject.labels) {
          if (label.confidence >= 0.85) {
            labels += label.text;

            if (i != (selectedObject.labels.length - 1)) {
              labels += ', ';
            }
          }

          i++;
        }
        tmpStr += labels + ' ]';
        if (labels.isNotEmpty) {
          success(tmpStr);
        } else {
          failed();
        }
      }
    } else {
      failed();
    }
  }

  void failed() {
    Get.snackbar('Failed to Plogging!', 'Please make it detected again',
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

  void success(String labels) {
    MapModel.to.plogging.value++;
    MapModel.to.makeMarker(20.0, Colors.purple);

    Get.snackbar('${labels} \nSuccess to Plogging!',
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
  }
}
