class ApiBodyJson {
  ApiBodyJson(
      {this.name,
      this.password,
      this.email,
      this.contactNo,
      this.gender,
      this.dob,
      this.role,
      this.deviceType,
      this.emailId,
      this.isWithOtp,
      this.mobile,
      this.otp,
      this.firstName,
      this.lastName,
      this.userId,
      this.userFamilyId,
      this.testIds,
      this.pincode,
      this.providerId,
      this.appointmentDate,
      this.appointmentTime,
      this.visiType,
      this.userType,
      this.id,
      this.title,
      this.description,
      this.date,
      this.time,
      this.location,
      this.totalTickets,
      this.ticketPrice,
      this.imageUrl,
      this.slug,
      this.categoryId,
      this.phone,
      this.scannerId,
      this.eventIds,
      this.quantity,
      this.ticketId,
      this.amount,
      this.currency,
      this.receipt,
      this.fcmToken,
      this.message,
      this.relationship});

  ApiBodyJson.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    contactNo = json['contactNo'];
    gender = json['gender'];
    dob = json['dob'];
    role = json['role'];
    deviceType = json['deviceType'];
    emailId = json['emailId'];
    isWithOtp = json['isWithOtp'];
    mobile = json['mobile'];
    otp = json['otp'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userId = json['userId'];
    userFamilyId = json['userFamilyId'];
    testIds = json['testIds']?.cast<String>();
    pincode = json['pincode'];
    providerId = json['providerId'];
    appointmentDate = json['appointmentDate'];
    appointmentTime = json['appointmentTime'];
    visiType = json['visiType'];
    userType = json['userType'];
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    totalTickets = json['totalTickets'];
    ticketPrice = json['ticketPrice'];
    imageUrl = json['imageUrl'];
    slug = json['slug'];
    categoryId = json['categoryId'];
    phone = json['phone'];
    scannerId = json['scannerId'];
    eventIds = json['eventIds'];
    quantity = json['quantity'];
    ticketId = json['ticketId'];
    amount = json['amount'];
    currency = json['currency'];
    receipt = json['receipt'];
    fcmToken = json['fcmToken'];
    message = json['message'];
    relationship = json['relationship'];
  }

  String? name;
  String? id;
  String? password;
  String? email;
  String? contactNo;
  String? gender;
  String? dob; // Add the dob format 08-02-2025
  String? role;
  String? deviceType;
  String? emailId;
  bool? isWithOtp;
  String? mobile;
  String? otp;
  String? firstName;
  String? lastName;
  String? userId;
  String? userFamilyId;
  List<String>? testIds;
  String? pincode;
  String? providerId;
  String? appointmentDate;
  String? appointmentTime;
  String? visiType;
  String? userType;
  String? title;
  String? description;
  String? date;
  String? time;
  String? location;
  int? totalTickets;
  int? ticketPrice;
  String? imageUrl;
  String? slug;
  String? categoryId;
  String? phone;
  String? scannerId;
  String? eventIds;
  int? quantity;
  String? ticketId;
  int? amount;
  String? currency;
  String? receipt;
  String? fcmToken;
  String? message;
  String? relationship;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['password'] = password;
    map['contactNo'] = contactNo;
    map['gender'] = gender;
    map['dob'] = dob;
    map['role'] = role;
    map['deviceType'] = deviceType;
    map['emailId'] = emailId;
    map['isWithOtp'] = isWithOtp;
    map['mobile'] = mobile;
    map['otp'] = otp;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['userId'] = userId;
    map['userFamilyId'] = userFamilyId;
    map['testIds'] = testIds;
    map['pincode'] = pincode;
    map['providerId'] = providerId;
    map['appointmentDate'] = appointmentDate;
    map['appointmentTime'] = appointmentTime;
    map['visiType'] = visiType;
    map['userType'] = userType;
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['date'] = date;
    map['time'] = time;
    map['location'] = location;
    map['totalTickets'] = totalTickets;
    map['ticketPrice'] = ticketPrice;
    map['imageUrl'] = imageUrl;
    map['slug'] = slug;
    map['categoryId'] = categoryId;
    map['phone'] = phone;
    map['scannerId'] = scannerId;
    map['eventIds'] = eventIds;
    map['quantity'] = quantity;
    map['ticketId'] = ticketId;
    map['amount'] = amount;
    map['currency'] = currency;
    map['receipt'] = receipt;
    map['fcmToken'] = fcmToken;
    map['message'] = message;
    map['relationship'] = relationship;
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
