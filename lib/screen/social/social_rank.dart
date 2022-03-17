import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_solution/theme/custom_color.dart';

class SocialRank extends StatefulWidget {
  const SocialRank({ Key? key }) : super(key: key);

  @override
  State<SocialRank> createState() => _SocialRankState();
}

class _SocialRankState extends State<SocialRank> {
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  bool donDec = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 44,
            child:
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          donDec = !donDec;
                        });
                      },
                      child: Text(
                        'friends',
                        style: TextStyle(
                            color: donDec ? Colors.black : Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          donDec = !donDec;
                        });
                      },
                      child: Text(
                        'region',
                        style: TextStyle(
                            color: donDec ? Colors.grey : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              //사용자 포인트과 프로필 사진 불러오기
              StreamBuilder<DocumentSnapshot>(
                  stream: _info.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();

                    var data = snapshot.data;
                    return Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text('${data!['point']} P',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black))),
                        CircleAvatar(
                            backgroundImage: NetworkImage('${data['image']}'),
                            radius: 15)
                      ],
                    );
                  })
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: width * 2 / 5,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: CustomColor.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.2,
                  offset: Offset(2.0, 2.0)
                )
              ]
            ),
            child: Center(
              child: Text('Running Ranking', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
          )
        ]),
      ),
      
    );
  }
}