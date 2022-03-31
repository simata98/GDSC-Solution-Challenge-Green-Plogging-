import 'package:flutter/material.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
                  Row(
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                        
                              ]
                            )
                            
                          ]),
                          Container(
                          margin: EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(Get.arguments['image']),
                              radius: 15)),
                    ],
                  ),
                ],
              )),
              //사진들
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Image.network(Get.arguments['map'], fit: BoxFit.fitWidth,)
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Image.network(Get.arguments['view'], fit: BoxFit.fitWidth,)),
              //거리, 시간, 플로깅 점수, 속도
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.route_outlined, Get.arguments['distance'], 'km', 'Distance'),
                        runningInfo(Icons.timer_outlined, Get.arguments['runTime'], '', 'Time')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.recycling_rounded, Get.arguments['plogPoint'], 'times', 'Plogging'),
                        runningInfo(Icons.directions_run, Get.arguments['speed'], '', 'Pace')
                      ],
                    )
                  ],
                ),
              )
        ])));
  }


  String getFormattedString(dynamic data, String info) {
    switch (info) {
      case 'Distance':
        double tmp = (data as int).toDouble();
        if (tmp == 0.0) {
          return '0.0';
        } else {
          return (tmp / 1000000).toStringAsFixed(2);
        }

      case 'Pace':
        double tmp = data as double;
        if (tmp.isInfinite) {
          return "--\'--\"";
        } else {
          return "${tmp ~/ 60}\'${(tmp % 60).toInt()}\"";
        }

      case 'Time':
        int tmp = data as int;
        print(tmp);
        if (tmp != 0) {
          if (StopWatchTimer.getRawMinute(tmp) >= 60) {
            return '${StopWatchTimer.getDisplayTimeHours(tmp)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeMinute(tmp)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeSecond(tmp)}';
          } else {
            return '${StopWatchTimer.getRawMinute(tmp)}' +
                ':' +
                '${StopWatchTimer.getDisplayTimeSecond(tmp)}';
          }
        } else {
          return "--:--";
        }
      default:
        return '$data';
    }
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
                      text: getFormattedString(data, info),
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
