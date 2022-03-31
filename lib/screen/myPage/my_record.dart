import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/myPage/record_detail.dart';
import 'package:intl/intl.dart';
import '../../theme/custom_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

//내 기록 출력 페이지
class MyRecord extends StatefulWidget {
  const MyRecord({ Key? key }) : super(key: key);

  @override
  State<MyRecord> createState() => _MyRecordState();
}

class _MyRecordState extends State<MyRecord> {
  //record 컬렉션 => 자신의 uid 도큐먼트 => saved 컬렉션의 모든 값을 시간 내림차순으로 정렬
  final recordData = FirebaseFirestore.instance
      .collection('records')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('saved')
      .orderBy('time', descending: true);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: recordData.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  return InkWell(
                    onTap: (){
                      Get.to(RecordDetail(),
                      arguments: {
                        'city' : data['city'],
                        'map' : data['map'],
                        'view' : data['view'],
                        'time' : data['time'].toDate(),
                        'distance' : data['distance'] as int,
                        'plogPoint' : data['plogPoint'],
                        'runTime' : data['runTime'],
                        'speed' : data['speed'],
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            color: CustomColor.primary,
                            height: 33,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      DateFormat('yy.MM.dd')
                                          .format(data['time'].toDate()),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text(data['city'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ]),
                          ),
                          Container(
                              height: 250,
                              width: MediaQuery.of(context).size.width,
                              child:
                                  Image.network(data['map'], fit: BoxFit.fitWidth)),
                        ],
                      ),
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        }),
    );
  }
}