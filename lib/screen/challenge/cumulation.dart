import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gdsc_solution/theme/custom_color.dart';

class Cumulation extends StatefulWidget {
  const Cumulation({Key? key}) : super(key: key);

  @override
  State<Cumulation> createState() => _CumulationState();
}

class _CumulationState extends State<Cumulation> {
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            //러닝 or 플로깅 선택 버튼
            Row(
              children: [
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
              ],
            ),
          ])),
      donDec ? showRunBody() : showPlogBody()
    ])));
  }

  showRunBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(_user).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active)
          return Container();
        if (!snapshot.hasData) return Container();
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('challenge')
                .doc(_user)
                .collection('cumul')
                .doc('running')
                .collection('cumu')
                .snapshots(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.active)
                return Container();
              if (!snap.hasData) return Container();
              return showRunList(context, snap.data!.docs, snapshot.data!['totalRun']);
            });
      }
    );
  }

  showRunList(BuildContext context, List<DocumentSnapshot> data, int totalRun) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
        var item = data[index];
        return Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: item['success'] ? Color(0x66ABC5B7) : Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('${item.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  child: item['success'] && totalRun >= item['goal'] ? Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 20,
                    width: 75,
                    child: ElevatedButton(
                      child: Text('Receive', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        elevation: 1,
                        primary: item['success'] ? CustomColor.primary : Colors.grey[600]
                      ),
                      onPressed: (){
                        FirebaseFirestore.instance.collection('challenge').doc(_user).collection('cumul').doc('running').collection('cumu').doc(item.id).update({'success' : false});
                        FirebaseFirestore.instance.collection('users').doc(_user).update({'point': FieldValue.increment(item['point'])});
                      },
                    ),
                  )
                  : Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 20,
                    width: 75,
                    child: Center(child: Text('${item['point']}P',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                    decoration: BoxDecoration(
                      color: item['success'] ? CustomColor.primary : Colors.grey[600],
                      borderRadius: BorderRadius.all(Radius.circular(7))
                    ),)
                )
                ]
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: 60,
                height: 60,
                child: totalRun >= item['goal'] ? Center(child: Text('100%',style: TextStyle(color: Colors.white, fontSize: 18)))
                        : Center(child: Text('${(item['goal']*1.0/totalRun).round()}%',
                        style: TextStyle(color: Colors.white, fontSize: 18),)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item['success'] ? CustomColor.primary : Colors.grey[600]
                ),
              )
            ],
          ),
        );
      });
  }

  showPlogBody() {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(_user).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active)
          return Container();
        if (!snapshot.hasData) return Container();
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('challenge')
                .doc(_user)
                .collection('cumul')
                .doc('plogging')
                .collection('cumu')
                .snapshots(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.active)
                return Container();
              if (!snap.hasData) return Container();
              return showPlogList(context, snap.data!.docs, snapshot.data!['totalPlog']);
            });
      }
    );
  }

  showPlogList(BuildContext context, List<DocumentSnapshot> data, int totalPlog) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
        var item = data[index];
        return Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: item['success'] ? Color(0x66ABC5B7) : Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('${item.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Container(
                  child: item['success'] && totalPlog >= item['goal'] ? Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 20,
                    width: 75,
                    child: ElevatedButton(
                      child: Text('Receive', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        elevation: 1,
                        primary: item['success'] ? CustomColor.primary : Colors.grey[600]
                      ),
                      onPressed: (){
                        FirebaseFirestore.instance.collection('challenge').doc(_user).collection('cumul').doc('plogging').collection('cumu').doc(item.id).update({'success' : false});
                        FirebaseFirestore.instance.collection('users').doc(_user).update({'point': FieldValue.increment(item['point'])});
                      },
                    ),
                  )
                  : Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 20,
                    width: 75,
                    child: Center(child: Text('${item['point']}P',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)),
                    decoration: BoxDecoration(
                      color: item['success'] ? CustomColor.primary : Colors.grey[600],
                      borderRadius: BorderRadius.all(Radius.circular(7))
                    ),)
                )
                ]
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                width: 60,
                height: 60,
                child: totalPlog >= item['goal'] ? Center(child: Text('100%',style: TextStyle(color: Colors.white, fontSize: 18)))
                        : Center(child: Text('${(item['goal']*1.0/totalPlog).round()}%',
                        style: TextStyle(color: Colors.white, fontSize: 18),)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item['success'] ? CustomColor.primary : Colors.grey[600]
                ),
              )
            ],
          ),
        );
      });
  }
}
