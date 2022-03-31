import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_color.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final _info = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  bool donDec = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 44,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (!donDec) donDec = !donDec;
                      });
                    },
                    child: Text(
                      'Donation',
                      style: TextStyle(
                          color: donDec ? Colors.black : Colors.grey,
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
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 192, 211, 201),
            child: SizedBox(height: 10)),
        //donate 버튼이 눌렸을 때와 decorate 버튼을 눌렀을 때 다른 리스트가 나오도록 함
        donDec
            ? ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  showDonationTile('assets/save_children.png',
                      'https://www.sc.or.kr/', 5000),
                  showDonationTile('assets/world_vision.png',
                      'https://www.worldvision.or.kr/', 5000),
                  showDonationTile(
                      'assets/unicef.png', 'https://www.unicef.or.kr/', 5000),
                  showDonationTile(
                      'assets/amnesty.png', 'https://www.amnesty.org/en/', 5000)
                ],
              )
            : ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  showDonationTile('assets/save_children.png',
                      'https://www.sc.or.kr/', 1000),
                  showDonationTile('assets/world_vision.png',
                      'https://www.worldvision.or.kr/', 1000),
                  showDonationTile(
                      'assets/unicef.png', 'https://www.unicef.or.kr/', 1000),
                  showDonationTile(
                      'assets/amnesty.png', 'https://www.amnesty.org/en/', 1000)
                ],
              )
      ]),
    );
  }

  //donation 페이지 tile 한 칸
  showDonationTile(String img, String link, int nessPoint) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/donate_back.jpeg'), fit: BoxFit.fill)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(img),
                  Text(
                    '$nessPoint P',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        launch(link);
                      },
                      child: Text(link, style: TextStyle(fontSize: 10)),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(50, 25),
                          maximumSize: Size(200, 25),
                          primary: CustomColor.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          donatePoint(nessPoint);
                        },
                        child: Text('Donate',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                            elevation: 5,
                            minimumSize: Size(64, 20),
                            maximumSize: Size(64, 20),
                            primary: CustomColor.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)))),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //기부 버튼을 누르면 동작하는 함수
  //해당 포인트보다 많이 갖고 있으면 포인트만큼 차감. 아니면 메세지 출력
  donatePoint(int point) {
    _info.get().then((DocumentSnapshot value) {
      if (value['point'] < point) {
        Get.dialog(AlertDialog(
          title: Text('Notification'),
          content: Text('need more points'),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('close'))
          ],
        ));
      } else {
        _info.update({'point': FieldValue.increment(0 - point)});
        Get.dialog(AlertDialog(
          title: Text('Notification'),
          content: Text('donated successfully'),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text('close'))
          ],
        ));
      }
    });
  }
}
