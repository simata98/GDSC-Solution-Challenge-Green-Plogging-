//회원가입 시 입력한 정보들에 대한 틀
class UserData {
  String? uid;
  String? email;
  String? name;
  String? nickname;
  String? country;
  String? city;
  String image = 'https://firebasestorage.googleapis.com/v0/b/flutterfirebaseouthlogin.appspot.com/o/profile_images%2Fno_profile.jpg?alt=media&token=71a9811a-f277-4835-85c5-01a9749bf45d';
  int point = 0;
  int totalRun = 0;
  int totalPlog = 0;

  UserData({this.uid, this.email, this.name, this.nickname, this.country, this.city});

  Map<String, dynamic> toMap(){
    return{
      'uid' : uid,
      'email' : email,
      'name' : name,
      'nickname' : nickname,
      'image' : image,
      'point' : point,
      'totalRun' : totalRun,
      'totalPlog' : totalPlog,
      'country' : country,
      'city' : city
    };
  }
}