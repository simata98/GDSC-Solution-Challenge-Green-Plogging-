import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsc_solution/theme/custom_color.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  bool donDec = true;
  final _user = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 44,
          child:
              Row( children: [
            //러닝 or 플로깅 선택 버튼
            TextButton(
                onPressed: () {
                  setState(() {
                    if (!donDec) donDec = !donDec;
                  });
                },
                child: Text(
                  'Running',
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
                  'Plogging',
                  style: TextStyle(
                      color: donDec ? Colors.grey : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
          ])),
      donDec ? showRunBody() : showPlogBody()
    ])));
  }

  showRunBody(){
    //totalRun 받아오기
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user).snapshots(),
      builder: (context, sn) {
        if(sn.connectionState != ConnectionState.active)  return Container();
        if(!sn.hasData) return Container();
        //oldData들 불러오기
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('challenge')
                  .doc(_user).collection('weekly')
                  .doc('running').snapshots(),
          builder: (context, snap) {
            if(snap.connectionState != ConnectionState.active)  return Container();
            if(!snap.hasData) return Container();
            //챌린지 리스트 뽑기
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                      .collection('challenge')
                      .doc(_user)
                      .collection('weekly')
                      .doc('running')
                      .collection('week')
                      .snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState != ConnectionState.active)  return Container();
                if(!snapshot.hasData) return Container();
                return showRunList(context, snapshot.data!.docs, sn.data!['totalRun'],snap.data!['last_run'], snap.data!['oldTotalRun']);
              },
            );
          }
        );
      }
    );
  }

  showRunList(BuildContext context, List<DocumentSnapshot> data, int newRun, int weekRun, int oldRun){
    int gap = newRun - oldRun;
    int newWeek = weekRun + gap;
    FirebaseFirestore.instance.collection('challenge').doc(_user).collection('weekly').doc('running').update({'last_run' : FieldValue.increment(gap), 'oldTotalRun' : newRun});
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
        return Container(
          child: Column(
            children: [
              Image.network('${data[index]['image']}'),
              Container(
                height: 40,
                color: data[index]['success'] ? CustomColor.primary : Colors.grey,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data[index]['comment']}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    newWeek >= data[index]['goal'] && data[index]['success'] ? Container(
                      height: 20,
                      child: ElevatedButton(onPressed: (){
                            FirebaseFirestore.instance.collection('challenge').doc(_user).collection('weekly').doc('running').collection('week').doc(data[index].id).update({'success' : false});
                            FirebaseFirestore.instance.collection('users').doc(_user).update({'point': FieldValue.increment(data[index]['point'])});
                      },
                      child: Text('Receive', style: TextStyle(fontSize: 12, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        primary: Colors.white,
                        elevation: 2
                      ),
                      ),
                    )
                    : Text('${data[index]['point']} P', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
              )

            ],
          ),
        );
      },
    );
  }

  showPlogBody(){
    //totalPlog 받아오기
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
              .collection('users')
              .doc(_user).snapshots(),
      builder: (context, sn) {
        if(sn.connectionState != ConnectionState.active)  return Container();
        if(!sn.hasData) return Container();
        //oldData들 불러오기
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('challenge')
                  .doc(_user).collection('weekly')
                  .doc('plogging').snapshots(),
          builder: (context, snap) {
            if(snap.connectionState != ConnectionState.active)  return Container();
            if(!snap.hasData) return Container();
            //챌린지 리스트 뽑기
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                      .collection('challenge')
                      .doc(_user)
                      .collection('weekly')
                      .doc('plogging')
                      .collection('week')
                      .snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState != ConnectionState.active)  return Container();
                if(!snapshot.hasData) return Container();
                return showPlogList(context, snapshot.data!.docs, sn.data!['totalPlog'],snap.data!['last_plog'], snap.data!['oldTotalPlog']);
              },
            );
          }
        );
      }
    );
  }

  showPlogList(BuildContext context, List<DocumentSnapshot> data, int newPlog, int weekPlog, int oldPlog){
    int gap = newPlog - oldPlog;
    int newWeek = weekPlog + gap;
    FirebaseFirestore.instance.collection('challenge').doc(_user).collection('weekly').doc('plogging').update({'last_plog' : FieldValue.increment(gap), 'oldTotalPlog' : newPlog});
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
        return Container(
          child: Column(
            children: [
              Image.network('${data[index]['image']}'),
              Container(
                height: 40,
                color: data[index]['success'] ? CustomColor.primary : Colors.grey,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${data[index]['comment']}', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    newWeek >= data[index]['goal'] && data[index]['success'] ? Container(
                      height: 20,
                      child: ElevatedButton(onPressed: (){
                            FirebaseFirestore.instance.collection('challenge').doc(_user).collection('weekly').doc('plogging').collection('week').doc(data[index].id).update({'success' : false});
                            FirebaseFirestore.instance.collection('users').doc(_user).update({'point': FieldValue.increment(data[index]['point'])});
                      },
                      child: Text('Receive', style: TextStyle(fontSize: 12, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        primary: Colors.white,
                        elevation: 2
                      ),
                      ),
                    )
                    : Text('${data[index]['point']} P', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, )),
                  ],
                ),
              )

            ],
          ),
        );
      },
    );
  }

}
