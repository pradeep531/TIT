// To parse this JSON data, do
//
//     final schedulecallcall = schedulecallcallFromJson(jsonString);

import 'dart:convert';

Schedulecallcall schedulecallcallFromJson(String str) =>
    Schedulecallcall.fromJson(json.decode(str));

String schedulecallcallToJson(Schedulecallcall data) =>
    json.encode(data.toJson());

class Schedulecallcall {
  DateTime? scheduleCallDate;
  String? scheduleCallTime;
  String? number;
  String? name;
  String? userId;
  String? schedule_call_description;
  Schedulecallcall({
    this.scheduleCallDate,
    this.scheduleCallTime,
    this.number,
    this.name,
    this.userId,
    this.schedule_call_description,
  });

  factory Schedulecallcall.fromJson(Map<String, dynamic> json) =>
      Schedulecallcall(
        scheduleCallDate: json["schedule_call_date"] == null
            ? null
            : DateTime.parse(json["schedule_call_date"]),
        scheduleCallTime: json["schedule_call_time"],
        number: json["number"],
        name: json["name"],
        userId: json["user_id"],
        schedule_call_description: json["schedule_call_description"],
      );

  Map<String, dynamic> toJson() => {
        "schedule_call_date":
            "${scheduleCallDate!.year.toString().padLeft(4, '0')}-${scheduleCallDate!.month.toString().padLeft(2, '0')}-${scheduleCallDate!.day.toString().padLeft(2, '0')}",
        "schedule_call_time": scheduleCallTime,
        "number": number,
        "name": name,
        "user_id": userId,
        "schedule_call_description": schedule_call_description,
      };
}
