// To parse this JSON data, do
//
//     final monthwisescheculeresponse = monthwisescheculeresponseFromJson(jsonString);

import 'dart:convert';

List<Monthwisescheculeresponse> monthwisescheculeresponseFromJson(String str) =>
    List<Monthwisescheculeresponse>.from(
        json.decode(str).map((x) => Monthwisescheculeresponse.fromJson(x)));

String monthwisescheculeresponseToJson(List<Monthwisescheculeresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Monthwisescheculeresponse {
  String? status;
  String? message;
  List<MonthwisescheculeDatum>? data;

  Monthwisescheculeresponse({
    this.status,
    this.message,
    this.data,
  });

  factory Monthwisescheculeresponse.fromJson(Map<String, dynamic> json) =>
      Monthwisescheculeresponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MonthwisescheculeDatum>.from(
                json["data"]!.map((x) => MonthwisescheculeDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MonthwisescheculeDatum {
  DateTime? scheduleCallDate;

  MonthwisescheculeDatum({
    this.scheduleCallDate,
  });

  factory MonthwisescheculeDatum.fromJson(Map<String, dynamic> json) =>
      MonthwisescheculeDatum(
        scheduleCallDate: json["schedule_call_date"] == null
            ? null
            : DateTime.parse(json["schedule_call_date"]),
      );

  Map<String, dynamic> toJson() => {
        "schedule_call_date":
            "${scheduleCallDate!.year.toString().padLeft(4, '0')}-${scheduleCallDate!.month.toString().padLeft(2, '0')}-${scheduleCallDate!.day.toString().padLeft(2, '0')}",
      };
}
