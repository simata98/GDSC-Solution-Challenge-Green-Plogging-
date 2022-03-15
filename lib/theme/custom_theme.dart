import 'package:flutter/material.dart';

import 'custom_color.dart';
// !! 테마를 만지고 싶다?
// https://www.raywenderlich.com/16628777-theming-a-flutter-app-getting-started
// 여기 링크를 통해 공부하고 오도록

class CustomTheme {
  //static getter로 읽기만 가능함을 의미
  static ThemeData get lightTheme {
    //primarySwatch 란?
    //전체 적인 theme의 색상 값
    //미리 제공되는 견본색상을 뜻 한다.
    //이것은 Material에 대한 color
    //https://stackoverflow.com/questions/50212484/what-is-the-difference-between-primarycolor-and-primaryswatch-in-flutter
    return ThemeData(
      primarySwatch: _createMaterialColor(CustomColor.primary),
    );
  }

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
