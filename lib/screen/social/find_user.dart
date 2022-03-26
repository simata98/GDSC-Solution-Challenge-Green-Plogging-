import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsc_solution/theme/custom_color.dart';

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
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15
                      ),
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,size: 25),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: (){
                            setState(() {
                              _controller.clear();
                              _searchText = "";
                            });
                          },
                        ),
                        hintText: '검색',
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
            _buidBody(context)
          ],
        ),
      ),
    );
  }

  _buidBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return CircularProgressIndicator();
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
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, index)=> const Divider(),
      itemCount: searchResults.length,
      itemBuilder: (context, index){
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
                  .collection('friends')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('following')
                  .snapshots(),
          builder: (context, snpshot){
            if(!snpshot.hasData)
              return CircularProgressIndicator();
            return Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${searchResults[index]['image']}'),
                          radius: 15,
                        )
                      ),
                      Text('${searchResults[index]['nickname']}')
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
    return RawMaterialButton(onPressed: (){},
    elevation: 2,
    fillColor: CustomColor.primary,
    child: Icon(Icons.add, color: Colors.white),
    shape: CircleBorder(),
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