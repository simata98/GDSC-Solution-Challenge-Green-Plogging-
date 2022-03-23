import 'package:flutter/material.dart';

class CustomColor {
  //투명도에 따름
  //각각 opacity는 87% , 54% , 45%, 38%, 26%, 12% 임
  static const Color primary = Color(0xff006931);
  static const Color primary87 = Color(0xDD006931);
  static const Color primary54 = Color(0x8A006931);
  static const Color primary45 = Color(0x73006931);
  static const Color primary38 = Color(0x61006931);
  static const Color primary26 = Color(0x42006931);
  static const Color primary12 = Color(0x1F006931);
  static const Color primaryPastel = Color(0xffD3DBD6);

  static MaterialColor MaterialPrimary = _createMaterialColor(primary);

  //Material에 대한 Color을 만드는 작업
  //자세한 링크는 https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3 참고
  static MaterialColor _createMaterialColor(Color color) {
    //첫번째 원소를 0.05로
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};

    //color 매개변수로 받아온 것을 RGB 값을 분리
    final int r = color.red, g = color.green, b = color.blue;

    //첫 번재 원소를 기준으로 0.1 씩 곱하기 --> 점화식
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1);
    }

    return MaterialColor(color.value, swatch);
  }
}
