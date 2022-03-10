//회원가입 시 입력한 정보들에 대한 틀
class UserData {
  String? email;
  String? name;
  String? nickname;
  int point = 0;
  int totalRun = 0;
  int totalPlog = 0;

  UserData({this.email, this.name, this.nickname});

  Map<String, dynamic> toMap(){
    return{
      'email' : email,
      'name' : name,
      'nickname' : nickname,
      'point' : point,
      'totalRun' : totalRun,
      'totalPlog' : totalPlog
    };
  }
}