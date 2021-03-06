import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/map_model.dart';
import '../login/sign_in.dart';
import 'guide_item.dart';

import '../../theme/custom_color.dart';

//앱 처음 실행 시 가이드라인 페이지
//최초 1회만 뜨도록 수정 예정
class GuideLine extends StatefulWidget {
  const GuideLine({Key? key}) : super(key: key);

  @override
  State<GuideLine> createState() => _GuideLineState();
}

class _GuideLineState extends State<GuideLine> {
  var dotList = [true, false, false];
  final _pageController = PageController(initialPage: 0);
  final slideList = [
    GuideItem(
        num: 0,
        image: 'assets/guide1.png',
        textBig: 'Run ',
        text: 'and stay healthy'),
    GuideItem(
        num: 1,
        image: 'assets/guide2.png',
        text: 'Get rest and ',
        textBig: 'Start Plogging'),
    GuideItem(
        num: 2,
        image: 'assets/guide3.png',
        text: 'Finish and ',
        textBig: 'Share')
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset('assets/logo.png', width: 60),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 450,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: slideList.length,
                  itemBuilder: (ctx, i) => slideList[i],
                  onPageChanged: (value) {
                    sliderDot(value);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(children: [
                  showDot(),
                  Container(
                    width: 150,
                    height: 50,
                    margin: EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                      onPressed: () => Get.off(SignIn()),
                      child: Text('START',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40))),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ));
  }

  //슬라이드 순서에 따라 밑에 뜨는 강조 점 위치 달라짐
  sliderDot(int page) {
    setState(() {
      if (page == 0) {
        dotList[0] = true;
        dotList[1] = false;
        dotList[2] = false;
      } else if (page == 1) {
        dotList[0] = false;
        dotList[1] = true;
        dotList[2] = false;
      } else {
        dotList[0] = false;
        dotList[1] = false;
        dotList[2] = true;
      }
    });
  }

  //강조되는 점들에 대한 함수
  showDot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: dotList[0] ? 12 : 8,
          width: dotList[0] ? 12 : 8,
          decoration: BoxDecoration(
              color: dotList[0] ? CustomColor.primary : Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: dotList[1] ? 12 : 8,
          width: dotList[1] ? 12 : 8,
          decoration: BoxDecoration(
              color: dotList[1] ? CustomColor.primary : Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: dotList[2] ? 12 : 8,
          width: dotList[2] ? 12 : 8,
          decoration: BoxDecoration(
              color: dotList[2] ? CustomColor.primary : Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(12))),
        )
      ],
    );
  }
}
