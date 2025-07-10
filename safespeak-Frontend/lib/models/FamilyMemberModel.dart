class FamilyMember {
  FamilyMember({
    required this.emergencyContact,
  });

  final List<EmergencyContact> emergencyContact;

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      emergencyContact: json["emergencyContact"] == null
          ? []
          : List<EmergencyContact>.from(json["emergencyContact"]!
              .map((x) => EmergencyContact.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "emergencyContact": emergencyContact.map((x) => x.toJson()).toList(),
      };
}

class EmergencyContact {
  EmergencyContact({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.v,
  });

  final String id;
  final String userId;
  final String name;
  final String relationship;
  final String phone;
  final String email;
  final DateTime? createdAt;
  final int v;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      name: json["name"] ?? "",
      relationship: json["relationship"] ?? "",
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "relationship": relationship,
        "phone": phone,
        "email": email,
        "createdAt": createdAt?.toIso8601String(),
        "__v": v,
      };
}
