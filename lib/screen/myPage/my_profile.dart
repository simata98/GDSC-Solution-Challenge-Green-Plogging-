import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: _info.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Row(children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/no_profile_image.jpg'),
                        radius: 60,
                      ),
                      Container(
                          width: 100,
                          margin: EdgeInsets.fromLTRB(30, 0, 40, 0),
                          child: Text('         ',
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                      IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                    ]);
                  }
                  var data = snapshot.data;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/no_profile_image.jpg'),
                            radius: 60,
                          ),
                          Container(
                              width: 100,
                              margin: EdgeInsets.fromLTRB(30, 0, 40, 0),
                              child: Text('${data!['nickname']}',
                                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
                          IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Total Point',style: TextStyle(fontSize: 18)),
                          Text('${data['point']} P',style: TextStyle(fontSize: 18)),
                        ],),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Total Running',style: TextStyle(fontSize: 18)),
                          changeM2Km('${data['totalRun']}')
                        ],),
                      ),Container(
                        margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text('Total Plogging',style: TextStyle(fontSize: 18)),
                          Text('${data['totalPlog']} times',style: TextStyle(fontSize: 18)),
                        ],),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  changeM2Km(data){
    var distance = double.parse(data);
    distance /= 100;
    return Text('$distance Km',style: TextStyle(fontSize: 18));
  }
}
