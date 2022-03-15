import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/guide/guide_line.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  splash createState() => splash();
}

class splash extends State<Splash> {
  // 3초 후 로그인 화면으로 전환
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Get.off(GuideLine())
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          Image(
            width: width * 3 / 5,
            image: AssetImage(
              'assets/logo.png',
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.only(left: width/3),
            child: Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 171, 197, 183),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            padding: EdgeInsets.only(left: width /6),
            child: Text(
              'Plogging',
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 105, 49),
                letterSpacing: 2.0,
              ),
            ),
          ),
        ])));
  }
}
