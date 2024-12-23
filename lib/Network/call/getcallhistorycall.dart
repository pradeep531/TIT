// To parse this JSON data, do
//
//     final getcallhistorycall = getcallhistorycallFromJson(jsonString);

import 'dart:convert';

Getcallhistorycall getcallhistorycallFromJson(String str) =>
    Getcallhistorycall.fromJson(json.decode(str));

String getcallhistorycallToJson(Getcallhistorycall data) =>
    json.encode(data.toJson());

class Getcallhistorycall {
  String userId;
  String callType;

  Getcallhistorycall({
    required this.userId,
    required this.callType,
  });

  factory Getcallhistorycall.fromJson(Map<String, dynamic> json) =>
      Getcallhistorycall(
        userId: json["userId"],
        callType: json["call_type"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "call_type": callType,
      };
}
