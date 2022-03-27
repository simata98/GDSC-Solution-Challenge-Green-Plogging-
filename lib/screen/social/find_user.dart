import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_solution/theme/custom_color.dart';
import 'package:get/get.dart';

class FindUser extends StatefulWidget {
  const FindUser({ Key? key }) : super(key: key);

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  final _controller = TextEditingController();
  String _searchText = "";

  _FindUserState(){
    _controller.addListener(() {
      setState(() {
        _searchText = _controller.text;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Row(
                  children: [
                    IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          fillColor: Color(0xFFCFDDD5),
                          filled: true,
                          prefixIcon: Icon(Icons.search,size: 25, color: Colors.black,),
                          suffixIcon: IconButton(
                            icon: _controller.text != "" ? Icon(Icons.cancel, color: Colors.grey,) : Container(),
                            onPressed: (){
                              setState(() {
                                _controller.clear();
                                _searchText = "";
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: _buidBody(context)
              )
              
            ],
          ),
        ),
      ),
    );
  }

  _buidBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.active)  return Container();
        if(!snapshot.hasData)
          return Container();
        return _buildList(context, snapshot.data!.docs);
      },
    );
  }

  _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    List<DocumentSnapshot> searchResults = [];

    for(DocumentSnapshot data in snapshot){
      if(data['nickname'].toString().contains(_searchText)){
        searchResults.add(data);
      }
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchResults.length,
      itemBuilder: (context, index){
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('friends')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('following')
                  .snapshots(),
          builder: (context, snpshot){
            if(snpshot.connectionState != ConnectionState.active) return Container();
            if(!snpshot.hasData) return Container();
            return Container(
              padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${searchResults[index]['image']}'),
                          radius: 15,
                        )
                      ),
                      Text('${searchResults[index]['nickname']}',
                            style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 17
                      ))
                    ],
                  ),
                  showAddButton(searchResults[index]['uid'],snpshot.data!.docs)
                ],
              ),
            );
          },
        );
      },
    );
  }
  showAddButton(String uid, List<DocumentSnapshot> snapshot){
    for(DocumentSnapshot data in snapshot){
      if(data['fuid'] == uid){
        return Container();
      }
    }
    return Container(
      width: 30,
      height: 30,
      child: RawMaterialButton(onPressed: (){addFollowList(uid);},
      elevation: 2,
      fillColor: CustomColor.primary,
      child: Icon(Icons.add, color: Colors.white),
      shape: CircleBorder(),
      ),
    );
  }

  addFollowList(String fuid){
    FirebaseFirestore.instance
    .collection('friends')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('following')
    .add({
      'fuid' : fuid
    }
    );
  }
}