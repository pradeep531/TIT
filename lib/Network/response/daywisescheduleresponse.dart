// To parse this JSON data, do
//
//     final daywisescheculeresponse = daywisescheculeresponseFromJson(jsonString);

import 'dart:convert';

List<Daywisescheculeresponse> daywisescheculeresponseFromJson(String str) =>
    List<Daywisescheculeresponse>.from(
        json.decode(str).map((x) => Daywisescheculeresponse.fromJson(x)));

String daywisescheculeresponseToJson(List<Daywisescheculeresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Daywisescheculeresponse {
  String status;
  String message;
  List<DaywisescheculeDatum> data;

  Daywisescheculeresponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Daywisescheculeresponse.fromJson(Map<String, dynamic> json) =>
      Daywisescheculeresponse(
        status: json["status"],
        message: json["message"],
        data: List<DaywisescheculeDatum>.from(
            json["data"].map((x) => DaywisescheculeDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DaywisescheculeDatum {
  dynamic id;
  dynamic name;
  dynamic number;
  DateTime scheduleCallDate;
  dynamic scheduleCallTime;
  dynamic scheduleCallDescription;
  dynamic userId;
  dynamic status;
  dynamic isDeleted;
  DateTime createdOn;
  DateTime updatedOn;
  dynamic lastCallDuration;
  dynamic lastCallDescription;

  DaywisescheculeDatum({
    required this.id,
    required this.name,
    required this.number,
    required this.scheduleCallDate,
    required this.scheduleCallTime,
    required this.scheduleCallDescription,
    required this.userId,
    required this.status,
    required this.isDeleted,
    required this.createdOn,
    required this.updatedOn,
    required this.lastCallDuration,
    required this.lastCallDescription,
  });

  factory DaywisescheculeDatum.fromJson(Map<String, dynamic> json) =>
      DaywisescheculeDatum(
        id: json["id"],
        name: json["name"],
        number: json["number"],
        scheduleCallDate: DateTime.parse(json["schedule_call_date"]),
        scheduleCallTime: json["schedule_call_time"],
        scheduleCallDescription: json["schedule_call_description"],
        userId: json["user_id"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        lastCallDuration: json["last_call_duration"],
        lastCallDescription: json["last_call_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number": number,
        "schedule_call_date":
            "${scheduleCallDate.year.toString().padLeft(4, '0')}-${scheduleCallDate.month.toString().padLeft(2, '0')}-${scheduleCallDate.day.toString().padLeft(2, '0')}",
        "schedule_call_time": scheduleCallTime,
        "schedule_call_description": scheduleCallDescription,
        "user_id": userId,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "last_call_duration": lastCallDuration,
        "last_call_description": lastCallDescription,
      };
}
