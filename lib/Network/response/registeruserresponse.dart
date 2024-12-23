// To parse this JSON data, do
//
//     final registeruserresponse = registeruserresponseFromJson(jsonString);

import 'dart:convert';

List<Registeruserresponse> registeruserresponseFromJson(String str) =>
    List<Registeruserresponse>.from(
        json.decode(str).map((x) => Registeruserresponse.fromJson(x)));

String registeruserresponseToJson(List<Registeruserresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Registeruserresponse {
  String? status;
  String? message;
  int? userId;

  Registeruserresponse({
    this.status,
    this.message,
    this.userId,
  });

  factory Registeruserresponse.fromJson(Map<String, dynamic> json) =>
      Registeruserresponse(
        status: json["status"],
        message: json["message"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_id": userId,
      };
}
