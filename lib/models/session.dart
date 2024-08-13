class Session {
  int? id;
  String? title;
  DateTime? creationDate;
  int? user;

  Session({this.id, this.title, this.creationDate, this.user});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    creationDate = DateTime.parse(json['timestamp']);
    user = json['patient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['creation_date'] = this.creationDate;
    data['user'] = this.user;
    return data;
  }
}