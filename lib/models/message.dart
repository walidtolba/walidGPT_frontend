class Message {
  int? id;
  String? content;
  String? timestamp;
  int? session;
  String? sender;

  Message({this.id, this.content, this.timestamp, this.session, this.sender});

  Message.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    content = json['content'];
    timestamp = json['timestamp'];
    session = json['session'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    data['session'] = this.session;
    data['sender'] = this.sender;
    return data;
  }
}
