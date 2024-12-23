// To parse this JSON data, do
//
//     final monthwisescheculecall = monthwisescheculecallFromJson(jsonString);

import 'dart:convert';

Monthwisescheculecall monthwisescheculecallFromJson(String str) =>
    Monthwisescheculecall.fromJson(json.decode(str));

String monthwisescheculecallToJson(Monthwisescheculecall data) =>
    json.encode(data.toJson());

class Monthwisescheculecall {
  String? userId;
  String? month;
  String? year;

  Monthwisescheculecall({
    this.userId,
    this.month,
    this.year,
  });

  factory Monthwisescheculecall.fromJson(Map<String, dynamic> json) =>
      Monthwisescheculecall(
        userId: json["user_id"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "month": month,
        "year": year,
      };
}
