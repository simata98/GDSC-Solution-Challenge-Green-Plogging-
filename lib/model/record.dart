//내 기록에 대한 틀
class Record {
  String? city;
  String? map;
  String? view;
  DateTime? time;
  int? distance;
  int? runTime;
  int? plogPoint;
  double? speed;

  Record({
    this.city,
    this.map,
    this.view,
    this.time,
    this.distance,
    this.runTime,
    this.plogPoint,
    this.speed
  });

  Map<String, dynamic> toMap(){
    return{
      'city' : city,
      'map' : map,
      'view' : view,
      'time' : time,
      'distance' : distance,
      'runTime' : runTime,
      'plogPoint' : plogPoint,
      'speed' : speed
    };
  }
}