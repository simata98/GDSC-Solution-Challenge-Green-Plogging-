import 'package:flutter/material.dart';
import 'package:gdsc_solution/components/mainMapDrawer.dart';
import 'my_profile.dart';
import 'my_record.dart';
import 'shop.dart';

class MyPage extends StatefulWidget {
  const MyPage({ Key? key }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            child: TextButton(onPressed: (){setState(() {
              selected = 0;
            });}, child: Text('My profile', style: TextStyle(color: selected == 0 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 1;
              });
            }, child: Text('My record', style: TextStyle(color: selected == 1 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 2;
              });
            }, child: Text('Shop', style: TextStyle(color: selected == 2 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
        ],
      ),
      drawer: Drawer(child: mainMapDrawer()),
      body: showPage(selected),
    );
  }
  showPage(int n){
    if(n == 0) return MyProfile();
    else if(n == 1) return MyRecord();
    else if(n == 2) return Shop();
  }
}