import 'package:flutter/material.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({Key? key}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColor.primaryPastel,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              height: 60,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              //상단 개인정보
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(Get.arguments['image']),
                          radius: 15)),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Get.arguments['nickname'],
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Text(
                                  DateFormat('yy.MM.dd').format(Get.arguments['time']),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(Get.arguments['city'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ])
                ],
              )),
              //사진들
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(Get.arguments['map'])
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network(Get.arguments['view'])),
              //거리, 시간, 플로깅 점수, 속도
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.map, Get.arguments['distance'], 'km', 'Distance'),
                        runningInfo(Icons.watch, Get.arguments['runTime'], 'min', 'Measure Time')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.recycling, Get.arguments['plogPoint'], 'times', 'Plogging'),
                        runningInfo(Icons.man, Get.arguments['speed'], '', 'Average Speed')
                      ],
                    )
                  ],
                ),
              ),
              //닫기 버튼
              Container(
                width: 130,
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: ElevatedButton(onPressed: (){Get.back();},
                child: Text('close', style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: CustomColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                  )
                ),),
              )
        ])));
  }

  runningInfo(IconData ic, dynamic data , String type, String info){
    return Container(
      width: (MediaQuery.of(context).size.width - 80) / 2,
      height: (MediaQuery.of(context).size.width - 80) / 5,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: CustomColor.primary,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(ic, color: CustomColor.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: info != 'Distance' ? '$data' : '${data/1000}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  TextSpan(
                      text: ' $type',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ]),
              ),
              Text(info, style: TextStyle(fontSize: 12))
            ],
          )
        ],
      ),
    );
  }
}
