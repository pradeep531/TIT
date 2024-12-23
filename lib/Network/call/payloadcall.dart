// To parse this JSON data, do
//
//     final payloadcall = payloadcallFromJson(jsonString);

import 'dart:convert';

Payloadcall payloadcallFromJson(String str) =>
    Payloadcall.fromJson(json.decode(str));

String payloadcallToJson(Payloadcall data) => json.encode(data.toJson());

class Payloadcall {
  String userId;
  String selectedDate;

  Payloadcall({
    required this.userId,
    required this.selectedDate,
  });

  factory Payloadcall.fromJson(Map<String, dynamic> json) => Payloadcall(
        userId: json["user_id"],
        selectedDate: json["selected_date"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "selected_date": selectedDate,
      };
}
