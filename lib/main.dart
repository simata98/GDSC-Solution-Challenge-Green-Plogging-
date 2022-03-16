import 'package:flutter/material.dart';
import 'package:gdsc_solution/splash.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        home: Splash());
  }
}
