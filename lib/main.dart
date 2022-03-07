import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/login/sign_in.dart';
import 'package:get/route_manager.dart';

void main()=>runApp(MainApp());

class MainApp extends StatelessWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn()
    );
  }
}