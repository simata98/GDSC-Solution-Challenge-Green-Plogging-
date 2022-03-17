import 'package:flutter/material.dart';
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
            });}, child: Text('Community', style: TextStyle(color: Colors.black, fontSize: 18)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 1;
              });
            }, child: Text('Rankings', style: TextStyle(color: Colors.black, fontSize: 18)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 2;
              });
            }, child: Text('News', style: TextStyle(color: Colors.black, fontSize: 18)))),
        ],
      ),
      drawer: Drawer(),
      body: showPage(selected),
    );
  }
  showPage(int n){
    if(n == 0) return SocialPost();
    else if(n == 1) return SocialRank();
    else if(n == 2) return News();
  }
}