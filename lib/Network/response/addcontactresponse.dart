// To parse this JSON data, do
//
//     final addcontactresponse = addcontactresponseFromJson(jsonString);

import 'dart:convert';

List<Addcontactresponse> addcontactresponseFromJson(String str) =>
    List<Addcontactresponse>.from(
        json.decode(str).map((x) => Addcontactresponse.fromJson(x)));

String addcontactresponseToJson(List<Addcontactresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Addcontactresponse {
  String? status;
  String? message;

  Addcontactresponse({
    this.status,
    this.message,
  });

  factory Addcontactresponse.fromJson(Map<String, dynamic> json) =>
      Addcontactresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
