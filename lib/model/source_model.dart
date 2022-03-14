class Source {
  String id;
  String name;

  //Let's create the constructor
  Source({this.id = '', this.name = ''});

  //Let's create the factory function to map the json
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name']);
  }
}