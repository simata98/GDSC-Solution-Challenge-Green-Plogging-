import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gdsc_solution/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//회원가입 페이지
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final nickController = TextEditingController();

  var format = NumberFormat('###,###,###,###');
  int user_count = 2131415;
  Animation? animation, transformationAnim;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    getUserNum().then((value) => user_count = value+1);
    //숫자 카운팅 애니메이션을 위한 컨트롤러 값 설정
    animationController = AnimationController(vsync: this, duration:Duration(seconds: 2));
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
                          showUserNum(),
                          showSequence(animation!.value)
                        ],
                      ),
                      Text('member', style: TextStyle(fontSize: 20))
                    ],
                  )
                      ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //사용자 이메일 입력칸
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
                        //사용자 비밀번호 입력칸
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
                        //사용자 이름 입력칸
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          child: TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return ("현재 빈 칸입니다.");
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
                                  hintText: "name",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                        //사용자 닉네임 입력칸
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
                          child: TextFormField(
                              controller: nickController,
                              keyboardType: TextInputType.text,
                              validator: (value){
                                if (value!.isEmpty) {
                                  return ("현재 빈 칸입니다.");
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              textInputAction:
                                  TextInputAction.next, //엔터 치면 다음으로 넘어감
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "nickname",
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

  //유저 숫자 뒤에 붙는 st,nd,rd,th 구분
  Widget showSequence(int num) {
    while (num >= 10) {
      num %= 10;
    }
    if (num == 1)
      return Text('st', style: TextStyle(fontSize: 20));
    else if (num == 2) return Text('nd', style: TextStyle(fontSize: 20));
    else if(num == 3) return Text('rd', style: TextStyle(fontSize: 20));
    return Text('th', style: TextStyle(fontSize: 20));
  }

  //authentication에 정보 저장 시도
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        registerDetails();
        Fluttertoast.showToast(msg: '계정 생성이 완료되었습니다.');
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  //입력한 세부 정보는 firestore uses 콜렉션에 추가
  void registerDetails() async {
    UserData userData = UserData();
    userData.email = emailController.text;
    userData.name = nameController.text;
    userData.nickname = nickController.text;

    final firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(userData.toMap());
  }

  //파이어스토어에 저장 되어있는 users 콜렉션의 길이를 구한다.
  Future getUserNum() async{
    var snapshot =  await FirebaseFirestore.instance.collection('users').get();
    int num = snapshot.size;
    return num;
  }

  //존재하는 유저 카운팅을 보여주기 위해 0부터 user_count까지 증가하도록 한다.
  //그 후 텍스트를 출력한다.
  showUserNum(){
    animation = IntTween(begin: 0, end: user_count).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease)
    );
    animationController.forward();
    return Text(format.format(animation!.value), style: TextStyle(fontSize: 30));
  }
}
