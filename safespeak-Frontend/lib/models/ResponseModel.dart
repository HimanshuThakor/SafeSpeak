class ResponseModel {
  ResponseModel({
    this.success,
    this.message,
    this.status,
    this.data,
    this.error,
  });

  ResponseModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
    data = json['data'];
    error = json['error'];
  }
  bool? success;
  String? message;
  int? status;
  dynamic data;
  dynamic error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['status'] = status;
    map['data'] = data;
    map['error'] = error;
    return map;
  }
}
