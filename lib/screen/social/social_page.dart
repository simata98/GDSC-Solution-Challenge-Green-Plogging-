import 'package:flutter/material.dart';
import 'package:gdsc_solution/components/mainMapDrawer.dart';
import 'package:gdsc_solution/screen/news/news.dart';
import 'package:gdsc_solution/screen/social/social_post.dart';
import 'package:gdsc_solution/screen/social/social_rank.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({ Key? key }) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
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
            });}, child: Text('Community', style: TextStyle(color: selected == 0 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 1;
              });
            }, child: Text('Rankings', style: TextStyle(color: selected == 1 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 2;
              });
            }, child: Text('News', style: TextStyle(color: selected == 2 ? Colors.black : Colors.grey, fontSize: 18)))),
        ],
      ),
      drawer: Drawer(child: mainMapDrawer()),
      body: showPage(selected),
    );
  }
  showPage(int n){
    if(n == 0) return SocialPost();
    else if(n == 1) return SocialRank();
    else if(n == 2) return News();
  }
}