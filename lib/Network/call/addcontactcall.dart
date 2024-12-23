// To parse this JSON data, do
//
//     final addcontactcall = addcontactcallFromJson(jsonString);

import 'dart:convert';

Addcontactcall addcontactcallFromJson(String str) =>
    Addcontactcall.fromJson(json.decode(str));

String addcontactcallToJson(Addcontactcall data) => json.encode(data.toJson());

class Addcontactcall {
  String? userId;
  String? firstName;
  String? lastName;
  String? mobileNumber;

  Addcontactcall({
    this.userId,
    this.firstName,
    this.lastName,
    this.mobileNumber,
  });

  factory Addcontactcall.fromJson(Map<String, dynamic> json) => Addcontactcall(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "mobile_number": mobileNumber,
      };
}
