import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/login/sign_in.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_core/firebase_core.dart';

<<<<<<< HEAD
Future<void> main() async{
=======
Future<void> main() async {
>>>>>>> d9b6574ccd4560445186b8d74a5d475af215248e
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
<<<<<<< HEAD
  const MainApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn()
    );
  }
}
=======
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: SignIn());
  }
}
>>>>>>> d9b6574ccd4560445186b8d74a5d475af215248e
