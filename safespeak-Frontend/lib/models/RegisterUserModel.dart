class RegisterUserModel {
  RegisterUserModel({
    required this.token,
    required this.user,
  });

  final String token;
  final UserDetails? user;

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserModel(
      token: json["token"] ?? "",
      user: json["userDetails"] == null
          ? null
          : UserDetails.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "userDetails": user?.toJson(),
      };
}

class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  final String id;
  final String name;
  final String email;
  final String phone;

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "email": email, "phone": phone};
}
