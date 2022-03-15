import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/guide/guide_line.dart';
import 'package:gdsc_solution/screen/login/sign_up.dart';
import 'package:gdsc_solution/screen/myPage/my_page.dart';
import 'package:gdsc_solution/screen/main/main.dart';
import 'package:gdsc_solution/screen/myPage/my_profile.dart';
import 'package:gdsc_solution/screen/news/news.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../main/main.dart';
import '../../theme/custom_color.dart';

//로그인 페이지
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  //사용자 수 출력 형식 지정
  var format = NumberFormat('###,###,###,###');
  int user_count = 0;

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final pwController = new TextEditingController();
  Animation? animation, transformationAnim;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    getUserNum().then((value) => user_count = value);
    //숫자 카운팅 애니메이션을 위한 컨트롤러 값 설정
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Image(
                          width: width * 2 / 3,
                          image: AssetImage(
                            'assets/logo.png',
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Text('There are', style: TextStyle(fontSize: 25)),
                              showUserNum(),
                              Text(
                                'Plogging Challengers',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 25, 131, 69)),
                              )
                            ],
                          )),
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Material(
                              elevation: 5,
                              child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    //이메일 입력 형식
                                    if (value!.isEmpty ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return ("잘못된 이메일 형식입니다.");
                                    }
                                  },
                                  textInputAction:
                                      TextInputAction.next, //엔터 치면 다음 위젯으로 이동
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: CustomColor.primary),
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      hintText: "E-mail",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)))),
                            ),
                          ),
                          SizedBox(height: 30),
                          //비밀번호 텍스트필드
                          Container(
                            color: Colors.white,
                            child: Material(
                              elevation: 5,
                              child: TextFormField(
                                controller: pwController,
                                obscureText: true, //비밀번호가 ....으로 표시되도록 한다
                                validator: (value) {
                                  RegExp regex = new RegExp(r'^.{6,}$');
                                  if (!regex.hasMatch(value!)) {
                                    return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    hintText: "Password",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 25, 131, 69)),
                                        borderRadius: BorderRadius.circular(0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0))),
                              ),
                            ),
                          )
                        ]),
                      ),
                      //로그인 버튼
                      Container(
                          width: width,
                          height: 50,
                          margin: EdgeInsets.only(top: 40),
                          child: ElevatedButton(
                            onPressed: () {
                              signIn(emailController.text, pwController.text);
                            },
                            child: Text('Sign in',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          )),
                      //회원가입 페이지 버튼
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            Get.to(SignUp());
                          },
                        ),
                      ),
                      //구글 로그인 버튼
                      Container(
                          width: width,
                          height: 50,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: googleSignIn,
                            child: Text('Sign in with Google',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //존재하는 계정이면 로그인 후 페이지 이동
  signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.to(mapMain()); //이부분을 홈으로 바꾸면 됨
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void googleSignIn() {}

  //파이어스토어에 저장 되어있는 users 콜렉션의 길이를 구한다.
  Future getUserNum() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    int num = snapshot.size;
    setState(() {});
    return num;
  }

  //존재하는 유저 카운팅을 보여주기 위해 0부터 user_count까지 증가하도록 한다.
  //그 후 텍스트를 출력한다.
  showUserNum() {
    animation = IntTween(begin: 0, end: user_count).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward();
    return Text(format.format(animation!.value),
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  }
}
