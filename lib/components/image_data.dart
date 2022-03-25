import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageData extends StatelessWidget {
  String icon;
  final double? width;
  ImageData(
    this.icon, {
    Key? key,
    this.width = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      icon,
      width: width! / Get.mediaQuery.devicePixelRatio,
    );
  }
}

class IconsPath {
  static String get addFriend => '/assets/images/add_friend_icon.jpeg';
  static String get camera => '/assets/images/camera_icon.jpeg';
  static String get menu => '/assets/images/menu_icon.jpeg';
  static String get close => '/assets/images/close_icon.jpeg';
}
