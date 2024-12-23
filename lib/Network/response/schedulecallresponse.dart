// To parse this JSON data, do
//
//     final schedulecallresponse = schedulecallresponseFromJson(jsonString);

import 'dart:convert';

List<Schedulecallresponse> schedulecallresponseFromJson(String str) =>
    List<Schedulecallresponse>.from(
        json.decode(str).map((x) => Schedulecallresponse.fromJson(x)));

String schedulecallresponseToJson(List<Schedulecallresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Schedulecallresponse {
  String? status;
  String? message;

  Schedulecallresponse({
    this.status,
    this.message,
  });

  factory Schedulecallresponse.fromJson(Map<String, dynamic> json) =>
      Schedulecallresponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
