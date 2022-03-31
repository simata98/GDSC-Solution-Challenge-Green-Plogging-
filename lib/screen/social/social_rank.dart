import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_solution/theme/custom_color.dart';

//랭킹 페이지
class SocialRank extends StatefulWidget {
  const SocialRank({Key? key}) : super(key: key);

  @override
  State<SocialRank> createState() => _SocialRankState();
}

class _SocialRankState extends State<SocialRank> {
  final rankNumSize = 40.0;
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  //donDec이 true일때는 friends 랭킹을
  //false일때는 region 랭킹을 보여주도록 함
  bool donDec = true;
  int runCount = 0;
  int plogCount = 0;

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
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 44,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //친구 or 지역 선택 버튼
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            if (!donDec) {
                              setState(() {
                                donDec = !donDec;
                              });
                            }
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
                            if (donDec) {
                              setState(() {
                                donDec = !donDec;
                              });
                            }
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
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();

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
          Container(
            margin: EdgeInsets.only(top: 10),
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
                      offset: Offset(2.0, 2.0))
                ]),
            child: Center(
              child: Text(
                'Running Ranking',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          donDec
              ? showFriendsRank('totalRun')
              : showRegRank(_selectedCity, 'totalRun'),
          Container(
            margin: EdgeInsets.only(top: 10),
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
                      offset: Offset(2.0, 2.0))
                ]),
            child: Center(
              child: Text(
                'Plogging Ranking',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          donDec
              ? showFriendsRank('totalPlog')
              : showRegRank(_selectedCity, 'totalPlog')
        ]),
      ),
    );
  }

  //지역 선택에 따라 달라지게 되는 스트림 양식
  regRank(String city, String desc) {
    var rank;
    if (city == 'Total') {
      rank = FirebaseFirestore.instance
          .collection('users')
          .orderBy(desc, descending: true);
    } else {
      rank = FirebaseFirestore.instance
          .collection('users')
          .where('city', isEqualTo: city)
          .orderBy(desc, descending: true);
    }
    return rank;
  }

  //지역랭킹
  showRegRank(String city, String desc) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: regRank(city, desc).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                //1,2,3등일때와 아닐 때 디자인의 차이를 두었으며
                //현재 사용자가 순위권 밖이라면 ...후에 자신의 등수가 나오도록 함
                return Container(
                    child: index == 0
                        ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Row(
                              children: [
                                Image.asset('assets/rank1.png',
                                    width: rankNumSize),
                                rankAvatar('${data['image']}'),
                                desc == 'totalPlog'
                                    ? rankTile('${data['nickname']}', desc,
                                        data['totalPlog'])
                                    : rankTile('${data['nickname']}', desc,
                                        data['totalRun'])
                              ],
                            ),
                        )
                        : index == 1
                            ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                  children: [
                                    Image.asset('assets/rank2.png',
                                        width: rankNumSize),
                                    rankAvatar('${data['image']}'),
                                    desc == 'totalPlog'
                                        ? rankTile('${data['nickname']}', desc,
                                            data['totalPlog'])
                                        : rankTile('${data['nickname']}', desc,
                                            data['totalRun'])
                                  ],
                                ),
                            )
                            : index == 2
                                ? Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Row(
                                      children: [
                                        Image.asset('assets/rank3.png',
                                            width: rankNumSize),
                                        rankAvatar('${data['image']}'),
                                        desc == 'totalPlog'
                                            ? rankTile('${data['nickname']}',
                                                desc, data['totalPlog'])
                                            : rankTile('${data['nickname']}',
                                                desc, data['totalRun'])
                                      ],
                                    ),
                                )
                                : data['uid'] ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Column(
                                        children: [
                                          rankDot(),
                                          rankDot(),
                                          rankDot(),
                                          Row(
                                            children: [
                                              Container(
                                                width: rankNumSize,
                                                height: rankNumSize,
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              rankAvatar('${data['image']}'),
                                              desc == 'totalPlog'
                                                  ? rankTile(
                                                      '${data['nickname']}',
                                                      desc,
                                                      data['totalPlog'])
                                                  : rankTile(
                                                      '${data['nickname']}',
                                                      desc,
                                                      data['totalRun'])
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container());
              });
        },
      ),
    );
  }

  //친구랭킹
  showFriendsRank(String desc) {
    int count = 0;
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: StreamBuilder<QuerySnapshot>(
        stream: regRank('Total', desc).snapshots(),
        builder: (context1, snapshot1) {
          if (snapshot1.connectionState != ConnectionState.active)
            return Container();
          if (!snapshot1.hasData) return Container();
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot1.data!.docs.length,
              itemBuilder: (context2, index2) {
                final data = snapshot1.data!.docs[index2];
                //1,2,3등일때와 아닐 때 디자인의 차이를 두었으며
                //현재 사용자가 순위권 밖이라면 ...후에 자신의 등수가 나오도록 함
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('friends')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('following')
                        .snapshots(),
                    builder: (context3, snapshot3) {
                      if (snapshot3.connectionState != ConnectionState.active)
                        return Container();
                      if (!snapshot3.hasData) return Container();
                      var friendData = snapshot3.data;
                      print('friendLength = ${friendData!.docs.length}');
                      for (int i = 0; i < friendData.docs.length; i++) {
                        if (friendData.docs[i]['fuid'] == data['uid']) {
                          ++count;
                          print('uid = ${data['uid']}, count = $count');
                          return Container(
                              child: count == 1
                                  ? Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Row(
                                        children: [
                                          Image.asset('assets/rank1.png',
                                              width: rankNumSize),
                                          rankAvatar('${data['image']}'),
                                          desc == 'totalPlog'
                                              ? rankTile('${data['nickname']}',
                                                  desc, data['totalPlog'])
                                              : rankTile('${data['nickname']}',
                                                  desc, data['totalRun'])
                                        ],
                                      ),
                                  )
                                  : count == 2
                                      ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Row(
                                            children: [
                                              Image.asset('assets/rank2.png',
                                                  width: rankNumSize),
                                              rankAvatar('${data['image']}'),
                                              desc == 'totalPlog'
                                                  ? rankTile(
                                                      '${data['nickname']}',
                                                      desc,
                                                      data['totalPlog'])
                                                  : rankTile(
                                                      '${data['nickname']}',
                                                      desc,
                                                      data['totalRun'])
                                            ],
                                          ),
                                      )
                                      : count == 3
                                          ? Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Row(
                                                children: [
                                                  Image.asset('assets/rank3.png',
                                                      width: rankNumSize),
                                                  rankAvatar('${data['image']}'),
                                                  desc == 'totalPlog'
                                                      ? rankTile(
                                                          '${data['nickname']}',
                                                          desc,
                                                          data['totalPlog'])
                                                      : rankTile(
                                                          '${data['nickname']}',
                                                          desc,
                                                          data['totalRun'])
                                                ],
                                              ),
                                          )
                                          : data['uid'] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? Column(
                                                  children: [
                                                    rankDot(),
                                                    rankDot(),
                                                    rankDot(),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: rankNumSize,
                                                          height: rankNumSize,
                                                          child: Center(
                                                            child: Text(
                                                              '${count}',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        rankAvatar(
                                                            '${data['image']}'),
                                                        desc == 'totalPlog'
                                                            ? rankTile(
                                                                '${data['nickname']}',
                                                                desc,
                                                                data[
                                                                    'totalPlog'])
                                                            : rankTile(
                                                                '${data['nickname']}',
                                                                desc,
                                                                data[
                                                                    'totalRun'])
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container());
                        }
                      }
                      return Container();
                    });
              });
        },
      ),
    );
  }

  getFriendsList() {}

  //랭킹 표시 시 나오는 사용자 프로필 사진
  rankAvatar(String image) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 10),
      child: CircleAvatar(
        radius: 15,
        backgroundImage: NetworkImage(image),
      ),
    );
  }

  //랭킹 표시 시 나오는 사용자 닉네임과 운동 데이터
  rankTile(String nickname, String desc, var data) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nickname,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          desc == 'totalPlog'
              ? Text(
                  '$data times',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              : Text(
                  '${data / 1000} KM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
        ],
      ),
    );
  }

  //점 디자인
  rankDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      height: 5,
      width: 5,
      decoration: BoxDecoration(
          color: CustomColor.primaryPastel,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
