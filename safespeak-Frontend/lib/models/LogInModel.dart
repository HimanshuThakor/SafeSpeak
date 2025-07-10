class LogInModel {
  LogInModel({
    required this.token,
    required this.user,
  });

  final String token;
  final UserDetails? user;

  factory LogInModel.fromJson(Map<String, dynamic> json) {
    return LogInModel(
      token: json["token"] ?? "",
      user: json["user"] == null ? null : UserDetails.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
