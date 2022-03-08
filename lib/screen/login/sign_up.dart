import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//회원가입 페이지
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  var format = NumberFormat('###,###,###,###');
  int user_count = 2131415;
  Animation? animation, transformationAnim;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = IntTween(begin: 0, end: user_count).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Scaffold(
              body: Center(
            //키보드가 올라오면 하단에 오버플로우가 발생하므로
            //SingleChildScrollView로 감싸준다.
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: Column(
                    children: [
                      Text('You are...', style: TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            format.format(animation!.value + 1),
                            style: TextStyle(fontSize: 30),
                          ),
                          showSequence(animation!.value + 1)
                        ],
                      ),
                      Text('member', style: TextStyle(fontSize: 20))
                    ],
                  )
                      //Text('${format.format(user_count)}'),
                      ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 75, 25, 0),
                          child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                  return ("잘못된 이메일 형식입니다.");
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          child: TextFormField(
                            controller: pwController,
                            obscureText: true,
                            validator: (value) {
                              RegExp regex = new RegExp(r'^.{6,}$');
                              if (!regex.hasMatch(value!)) {
                                return ("최소 6자리 이상의 비밀번호가 필요합니다.");
                              }
                            },
                            onSaved: (value) {
                              pwController.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "PassWord",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("사용할 수 없는 이름입니다.");
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Name",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.length != 11 ||
                                    !RegExp(r'[0-9]').hasMatch(value)) {
                                  return ("잘못된 번호 형식입니다.");
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              textInputAction:
                                  TextInputAction.next, //엔터 치면 다음으로 넘어감
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "PhoneNumber",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.grey),
                          onPressed: () {
                            signUp(emailController.text, pwController.text);
                          },
                          child: Text('Sign Up')))
                ],
              ),
            ),
          ));
        });
  }

  Widget showSequence(int num) {
    while (num >= 10) {
      num %= 10;
    }
    if (num == 1)
      return Text('st', style: TextStyle(fontSize: 20));
    else if (num == 2) return Text('nd', style: TextStyle(fontSize: 20));
    return Text('th', style: TextStyle(fontSize: 20));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        /* await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        registerDetails();
        Fluttertoast.showToast(msg: '계정 생성이 완료되었습니다.');
        Navigator.pop(context); */
      } catch (e) {
        //Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  void registerDetails() async {
    /* UserData userData = UserData();
    userData.email = emailController.text;
    userData.name = nameController.text;
    userData.phone = phoneController.text;

    final firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("Users")
        .doc(_auth.currentUser!.uid)
        .set(userData
            .toMap());
  } */
  }
}
