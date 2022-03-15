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
      primarySwatch: CustomColor.MaterialPrimary,
    );
  }
}
