import 'package:flutter/material.dart';
import 'package:gdsc_solution/components/mainMapDrawer.dart';
import 'cumulation.dart';
import 'weekly.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({ Key? key }) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
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
            });}, child: Text('Weekly', style: TextStyle(color: selected == 0 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          Container(
            child: TextButton(onPressed: (){
              setState(() {
                selected = 1;
              });
            }, child: Text('Cumulation', style: TextStyle(color: selected == 1 ? Colors.black : Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)))),
          ],
      ),
      drawer: Drawer(child: mainMapDrawer()),
      body: showPage(selected),
    );
  }
  showPage(int n){
    if(n == 0) return Weekly();
    else if(n == 1) return Cumulation();
  }
}