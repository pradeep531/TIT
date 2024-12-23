// To parse this JSON data, do
//
//     final calllogdetailsresponse = calllogdetailsresponseFromJson(jsonString);

import 'dart:convert';

List<Calllogdetailsresponse> calllogdetailsresponseFromJson(String str) =>
    List<Calllogdetailsresponse>.from(
        json.decode(str).map((x) => Calllogdetailsresponse.fromJson(x)));

String calllogdetailsresponseToJson(List<Calllogdetailsresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Calllogdetailsresponse {
  String? status;
  String? message;

  Calllogdetailsresponse({
    this.status,
    this.message,
  });

  factory Calllogdetailsresponse.fromJson(Map<String, dynamic> json) =>
      Calllogdetailsresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
