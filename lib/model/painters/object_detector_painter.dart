import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../map_model.dart';
import 'coordinates_translator.dart';

class ObjectDetectorPainter extends CustomPainter {
  ObjectDetectorPainter(this._objects, this.rotation, this.absoluteSize,
      this.cameraHeight, this.cameraWidth);

  final List<DetectedObject> _objects;
  final Size absoluteSize;
  final InputImageRotation rotation;
  final double cameraHeight;
  final double cameraWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint background = Paint()..color = Color(0x99000000);

    // 제일 가까운 상자 찾기
    double distance = double.infinity;
    int i = 0, tmpi = 0;
    for (final DetectedObject detectedObject in _objects) {
      // 두 점 사이의 거리 구하기
      //가운데 좌표
      double dx1 = cameraWidth / 2;
      double dy1 = cameraHeight / 2;

      //박스 좌표
      double dx2 = detectedObject.boundingBox.center.dx;
      double dy2 = detectedObject.boundingBox.center.dy;

      double tmp = sqrt((dx2 - dx1) * (dx2 - dx1) + (dy2 - dy1) * (dy2 - dy1));

      // 여기 부분 수정
      // 정확도가 낮은 쓸데없는 부분은 무시함
      bool check = false; // 정확도가 85이상인게 하나라도 있는 지 체크
      for (final Label label in detectedObject.labels) {
        if (label.confidence >= 0.85) {
          check = true;
        }
      }

      if (tmp < distance && check) {
        distance = tmp;
        i = tmpi;

        MapModel.to.selectedItem = i;
      }

      tmpi++;
    }

    // tmpi 초기화
    tmpi = 0;

    for (final DetectedObject detectedObject in _objects) {
      Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.lightGreenAccent;

      if (tmpi == i) {
        paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..color = Colors.redAccent;
      } else {
        paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0
          ..color = Colors.lightGreenAccent;
      }

      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 16,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));

      // 여기 부분 수정
      for (final Label label in detectedObject.labels) {
        if (label.confidence >= 0.85) {
          builder.addText('${label.text} ${label.confidence}\n');
        }
      }

      builder.pop();

      final left = translateX(
          detectedObject.boundingBox.left, rotation, size, absoluteSize);
      final top = translateY(
          detectedObject.boundingBox.top, rotation, size, absoluteSize);
      final right = translateX(
          detectedObject.boundingBox.right, rotation, size, absoluteSize);
      final bottom = translateY(
          detectedObject.boundingBox.bottom, rotation, size, absoluteSize);

      // 상자 드리는 곳
      // 여기 부분 수정
      // 정확도가 낮은 쓸데없는 부분은 무시함
      bool check = false; // 정확도가 85이상인게 하나라도 있는 지 체크
      for (final Label label in detectedObject.labels) {
        if (label.confidence >= 0.85) {
          check = true;
        }
      }

      if (check) {
        canvas.drawRect(
          Rect.fromLTRB(left, top, right, bottom),
          paint,
        );

        canvas.drawParagraph(
          builder.build()
            ..layout(ParagraphConstraints(
              width: right - left,
            )),
          Offset(left, top),
        );
      }

      tmpi++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
