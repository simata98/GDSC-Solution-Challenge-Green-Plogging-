import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/community.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gdsc_solution/model/record.dart';

class RecordDetail extends StatefulWidget {
  const RecordDetail({ Key? key }) : super(key: key);

  @override
  State<RecordDetail> createState() => _RecordDetailState();
}

class _RecordDetailState extends State<RecordDetail> {
  Community community = Community(
                      uid: FirebaseAuth.instance.currentUser!.uid.toString(),
                      city: Get.arguments['city'],
    map: Get.arguments['map'],
    view: Get.arguments['view'] ,
    time: Get.arguments['time'],
    distance: Get.arguments['distance'] as int,
    plogPoint: Get.arguments['plogPoint'] as int,
    runTime: Get.arguments['runTime'] as int,
    speed: Get.arguments['speed'] as double,);
  final commentController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryPastel,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('City'),
              Text('${community.city}'),
              Text('Date'),
              Text('${community.time.toString()}'),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network('${community.map}')
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network('${community.view}')
              ),
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.map, community.distance, 'km', 'Distance'),
                        runningInfo(Icons.watch, community.runTime, 'min', 'Measure Time')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        runningInfo(Icons.recycling, community.plogPoint, 'times', 'Plogging'),
                        runningInfo(Icons.man, community.speed, '', 'Average Speed')
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 130,
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: ElevatedButton(onPressed: uploadPost,
                child: Text('Post', style: TextStyle(
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
            ],
          ),
        ),
      ),
    );
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

  uploadPost(){
    community.comment = commentController.text;
    final _auth = FirebaseFirestore.instance
                  .collection('posts')
                  .add(community.toMap());
  }
}