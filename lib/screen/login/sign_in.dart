import 'package:flutter/material.dart';
import 'package:gdsc_solution/screen/login/sign_up.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin{
  var format = NumberFormat('###,###,###,###');
  int user_count = 2131415;

  final _formKey = GlobalKey<FormState>();
  final emailController = new TextEditingController();
  final pwController = new TextEditingController();
  Animation? animation, transformationAnim;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration:Duration(seconds: 1));
    animation = IntTween(begin: 0, end: user_count).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease)
    );
    animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context,child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Text('Total Users',style: TextStyle(fontSize: 20)),
                      Text(format.format(animation!.value), style: TextStyle(fontSize: 30),)
                    ],
                  )
                  //Text('${format.format(user_count)}'),
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                  Container(
                          margin: EdgeInsets.fromLTRB(25, 75, 25, 0),
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
                                  prefixIcon: Icon(Icons.mail),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)))),
                        ),
                        SizedBox(height: 40),
                        //비밀번호 텍스트필드
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: TextFormField(
                            controller: pwController,
                            obscureText: true,  //비밀번호가 ....으로 표시되도록 한다
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (!regex.hasMatch(value!)) {
                                return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                              }
                            },
                            textInputAction:
                                TextInputAction.next,
                            decoration: InputDecoration( 
                                prefixIcon: Icon(Icons.vpn_key),
                                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "PassWord",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        )
                ]),),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: TextButton(
                    child: Text('Sign Up'),
                    onPressed: () {
                      Get.to(SignUp());
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        signIn(emailController.text, pwController.text);
                      },
                      child: Text('Sign in'),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: googleSignIn,
                      child: Text('SignIn with Google'),
                      style: ElevatedButton.styleFrom(primary: Colors.grey),
                    ))
              ],
            ),
          ),
        );
      }
    );
  }
  signIn(String email, String password){
    if (_formKey.currentState!.validate()) {
      try {
        /* await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home())); */
      } catch (e) {
        //Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void googleSignIn(){

  }
}