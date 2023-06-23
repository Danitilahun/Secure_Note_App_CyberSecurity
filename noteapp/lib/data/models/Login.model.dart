class UserLoginModel {
  final String email;
  final String password;

  UserLoginModel({
    required this.email,
    required this.password,
  });

  factory UserLoginModel.fromMap(Map<String, dynamic> map) {
    return UserLoginModel(
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
