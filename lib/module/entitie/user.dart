import 'dart:convert';

class User {
  String name;
  String age;
  String gender;

  User({
    this.name,
    this.age,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(User user) => {
        'name': user.name,
        'age': user.age,
        'gender': user.gender,
      };

  static String encode(List<User> users) => json.encode(
        users.map<Map<String, dynamic>>((user) => User.toMap(user)).toList(),
      );

  static List<User> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<User>((item) => User.fromJson(item))
          .toList();
}
