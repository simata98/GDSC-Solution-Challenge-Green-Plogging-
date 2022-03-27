import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';

class mainMapDrawer extends StatefulWidget {
  const mainMapDrawer({Key? key}) : super(key: key);

  @override
  State<mainMapDrawer> createState() => _mainMapDrawerState();
}

class _mainMapDrawerState extends State<mainMapDrawer> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final double _statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final double _drawerWidth = MediaQuery.of(context).size.width;

    final Size _infoSize = new Size(100, 150);

    Widget makeColMenu(String menuContext, String namedPage) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(namedPage);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          height: 40,
          width: _drawerWidth,
          color: CustomColor.primary,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              '${menuContext}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  shadows: [
                    Shadow(
                        blurRadius: 20.0,
                        color: Colors.black,
                        offset: Offset(1.5, 1.5))
                  ]),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: _statusBarHeight,
        ),
        Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
            child: Container(width: 50, child: Image.asset('assets/logo.png'))),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return CircularProgressIndicator();

            var data = snapshot.data;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(data!['image']),
                      radius: _drawerWidth * 0.13,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Text(data['nickname'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        Text('${data['country']}, ${data['city']}', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.black,
        ),
        SizedBox(
          height: 10,
        ),
        makeColMenu('Running and Plogging', '/main/social'),
        SizedBox(
          height: 20,
        ),
        makeColMenu('Social', '/main/social'),
        SizedBox(
          height: 20,
        ),
        makeColMenu('Challenge', '/main/challenge'),
        SizedBox(
          height: 20,
        ),
        makeColMenu('My page', '/main/my_page'),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
