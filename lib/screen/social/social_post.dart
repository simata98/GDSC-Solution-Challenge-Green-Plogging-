import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_solution/screen/social/post_detail.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SocialPost extends StatefulWidget {
  const SocialPost({Key? key}) : super(key: key);

  @override
  State<SocialPost> createState() => _SocialPostState();
}

class _SocialPostState extends State<SocialPost> {
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  bool donDec = true;
  final _cityList = [
    [
      'Total',
      'Seoul',
      'Suwon',
      'Asan',
      'Washington DC',
      'New York',
      'California'
    ]
  ];
  var _selectedCity = 'Total';
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 44,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //친구 or 지역 선택 버튼
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (!donDec) donDec = !donDec;
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
                        if (donDec) donDec = !donDec;
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
                  return CircleAvatar(
                      backgroundImage: NetworkImage('${data!['image']}'),
                      radius: 15);
                })
          ]),
        ),
        //지역 세부 선택
        donDec
            ? Container()
            : Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: _selectedCity,
                      items: _cityList[_selectedIndex].map((value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCity = value!;
                        });
                      },
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ),

        donDec ? Container() : showPostData()
      ]),
    ));
  }

  //내가 올린 포스트들
  showPostData() {
    return StreamBuilder<QuerySnapshot>(
        stream: regPost(_selectedCity).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  final st = FirebaseFirestore.instance
                      .collection('users')
                      .doc('${data['uid']}')
                      .snapshots();
                  return GestureDetector(
                    onDoubleTap: () {},
                    child: Column(
                      children: [
                        Container(
                            height: 10,
                            color: Color.fromARGB(255, 171, 197, 183)),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            height: 50,
                            //포스트의 상단 글쓴이 정보에 대한 출력
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: st,
                              builder: ((ctx, snpshot) {
                                if (!snpshot.hasData)
                                  return CircularProgressIndicator();
                                var man = snpshot.data;
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      '${man!['image']}'),
                                                  radius: 15)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(man['nickname'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 5),
                                                    child: Text(
                                                        DateFormat('yy.MM.dd')
                                                            .format(data['time']
                                                                .toDate()),
                                                        style: TextStyle(
                                                            fontSize: 8,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Text(data['city'],
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      //view버튼
                                      ElevatedButton(
                                        child: Text('View',
                                            style: TextStyle(fontSize: 10)),
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(55, 25),
                                            maximumSize: Size(55, 25),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                        onPressed: () {
                                          Get.to(PostDetail(), arguments: {
                                            'nickname': man['nickname'],
                                            'image': man['image'],
                                            'city': data['city'],
                                            'view': data['view'],
                                            'map' : data['map'],
                                            'time': data['time'].toDate(),
                                            'distance': data['distance'] as int,
                                            'plogPoint': data['plogPoint'],
                                            'runTime': data['runTime'],
                                            'speed': data['speed'],
                                          });
                                        },
                                      )
                                    ]);
                              }),
                            )),
                        //포스트 이미지 사진
                        Container(
                            width: MediaQuery.of(context).size.width,
                            child:
                                Image.network(data['map'], fit: BoxFit.fill)),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  '${data['comment']}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.heart_broken),
                                  Text(
                                    '${data['like_count']} likes',
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
          return CircularProgressIndicator();
        });
  }

  regPost(String city) {
    var rank;
    if (city == 'Total') {
      rank = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('time', descending: true);
    } else {
      rank = FirebaseFirestore.instance
          .collection('posts')
          .where('city', isEqualTo: city)
          .orderBy('time', descending: true);
    }
    return rank;
  }
}
