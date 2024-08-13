class User {
  int? id = 0;
  String? email = '';
  String? firstName = '';
  String? lastName = '';
  String? picture;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.picture});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['picture'] = this.picture;
    return data;
  }
}