class User {
  String? phone;
  String? password;
  String? name;
  User({this.phone, this.password, this.name});
  User.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    password = json['password'];
    name = json['name'];
  }
  String toJson() {
    return '{'
        '"phone": "$phone",'
        '"password": "$password",'
        '"name": "$name"'
        '}';
  }
}
