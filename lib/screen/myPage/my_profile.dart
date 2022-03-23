import 'package:flutter/material.dart';
import 'package:gdsc_solution/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../../theme/custom_color.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final postData = FirebaseFirestore.instance
      .collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .orderBy('time', descending: true);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Container(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _info.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/no_profile_image.jpg'),
                  radius: 60,
                ),
                Container(
                    width: 100,
                    margin: EdgeInsets.fromLTRB(30, 0, 40, 0),
                    child: Text('         ',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold))),
                    IconButton(onPressed: () {}, icon: Icon(Icons.settings))
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Point', style: TextStyle(fontSize: 15)),
                      Text('${data['point']} P',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Running', style: TextStyle(fontSize: 15)),
                      changeM2Km('${data['totalRun']}')
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Plogging', style: TextStyle(fontSize: 15)),
                      Text('${data['totalPlog']} times',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Text('Post list',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      showPostData()
    ]));
  }

  //미터 값을 키로미터 값으로 변경
  changeM2Km(data) {
    var distance = double.parse(data);
    distance /= 100;
    return Text('$distance Km', style: TextStyle(fontSize: 20));
  }

  //내가 올린 포스트들
  showPostData() {
    return StreamBuilder<QuerySnapshot>(
        stream: postData.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  return Container(
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
                                Image.network(data['map'], fit: BoxFit.fill)),
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }
}
