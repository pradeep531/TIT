// To parse this JSON data, do
//
//     final getcallsummarycall = getcallsummarycallFromJson(jsonString);

import 'dart:convert';

Getcallsummarycall getcallsummarycallFromJson(String str) =>
    Getcallsummarycall.fromJson(json.decode(str));

String getcallsummarycallToJson(Getcallsummarycall data) =>
    json.encode(data.toJson());

class Getcallsummarycall {
  String? userId;
  String? callerNumber;
  String? summaryType;

  Getcallsummarycall({
    this.userId,
    this.callerNumber,
    this.summaryType,
  });

  factory Getcallsummarycall.fromJson(Map<String, dynamic> json) =>
      Getcallsummarycall(
        userId: json["userId"],
        callerNumber: json["caller_number"],
        summaryType: json["summary_type"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "caller_number": callerNumber,
        "summary_type": summaryType,
      };
}
