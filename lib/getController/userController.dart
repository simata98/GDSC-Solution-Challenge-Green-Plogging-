import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  Stream<DocumentSnapshot> doc = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                          .snapshots();

  void StartStream(){
    doc.listen((event) {
      
    });
  }
}