import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/contact_us.dart';
import 'package:gdsc_solution/screen/login/sign_in.dart';
import 'package:gdsc_solution/screen/main/main.dart';
import 'package:gdsc_solution/screen/myPage/my_page.dart';
import 'package:gdsc_solution/screen/social/social_page.dart';
import 'package:gdsc_solution/splash.dart';
import 'package:get/route_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'screen/challenge/challenge_page.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: Splash(),

      //여기서 페이지 추가
      //지금은 의미가 없지만 나중에 마이페이지 부분에서 꼭 써야함
      //이유 : named 라우트는 앱의 다른 많은 부분들에서 동일한 화면으로
      //이동하고자 한다면 중복된 코드가 생기기 때문!
      getPages: [
        GetPage(name: '/', page: () => SignIn()),
        GetPage(name: '/main', page: () => mapMain()),
        GetPage(name: '/main/social_page', page: () => SocialPage()),
        GetPage(name: '/main/my_page', page: () => MyPage()),
        GetPage(name: '/main/social', page: () => SocialPage()),
        GetPage(name: '/main/challenge', page: () => ChallengePage()),
        GetPage(name: '/main/contact_us', page: () => Contact())
      ],
    );
  }
}
