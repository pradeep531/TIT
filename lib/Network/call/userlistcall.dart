// To parse this JSON data, do
//
//     final userlistcall = userlistcallFromJson(jsonString);

import 'dart:convert';

Userlistcall userlistcallFromJson(String str) =>
    Userlistcall.fromJson(json.decode(str));

String userlistcallToJson(Userlistcall data) => json.encode(data.toJson());

class Userlistcall {
  String companyId;

  Userlistcall({
    required this.companyId,
  });

  factory Userlistcall.fromJson(Map<String, dynamic> json) => Userlistcall(
        companyId: json["company_id"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
      };
}
