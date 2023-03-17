class User {

  int? id;
  String? username;
  String? password;
  String? phone;
  String? dateCreate;

  User({
      this.id, 
      this.username, 
      this.password, 
      this.phone, 
      this.dateCreate,});

  User.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    phone = json['phone'];
    dateCreate = json['dateCreate'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['password'] = password;
    map['phone'] = phone;
    map['dateCreate'] = dateCreate;
    return map;
  }

}