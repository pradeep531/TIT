// To parse this JSON data, do
//
//     final getcallsummaryresponse = getcallsummaryresponseFromJson(jsonString);

import 'dart:convert';

List<Getcallsummaryresponse> getcallsummaryresponseFromJson(String str) =>
    List<Getcallsummaryresponse>.from(
        json.decode(str).map((x) => Getcallsummaryresponse.fromJson(x)));

String getcallsummaryresponseToJson(List<Getcallsummaryresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Getcallsummaryresponse {
  String status;
  String message;
  List<SummaryDatum> data;

  Getcallsummaryresponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Getcallsummaryresponse.fromJson(Map<String, dynamic> json) =>
      Getcallsummaryresponse(
        status: json["status"],
        message: json["message"],
        data: List<SummaryDatum>.from(
            json["data"].map((x) => SummaryDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SummaryDatum {
  String id;
  String userId;
  String simSlot;
  String simName;
  String callerName;
  String callType;
  String callerNumber;
  DateTime callFrom;
  DateTime callTo;
  String callDuration;
  String receiverNumber;
  String callSummary;
  String isDeleted;
  String status;
  DateTime createdOn;
  DateTime updatedOn;

  SummaryDatum({
    required this.id,
    required this.userId,
    required this.simSlot,
    required this.simName,
    required this.callerName,
    required this.callType,
    required this.callerNumber,
    required this.callFrom,
    required this.callTo,
    required this.callDuration,
    required this.receiverNumber,
    required this.callSummary,
    required this.isDeleted,
    required this.status,
    required this.createdOn,
    required this.updatedOn,
  });

  factory SummaryDatum.fromJson(Map<String, dynamic> json) => SummaryDatum(
        id: json["id"],
        userId: json["user_id"],
        simSlot: json["sim_slot"],
        simName: json["sim_name"],
        callerName: json["caller_name"],
        callType: json["call_type"],
        callerNumber: json["caller_number"],
        callFrom: DateTime.parse(json["call_from"]),
        callTo: DateTime.parse(json["call_to"]),
        callDuration: json["call_duration"],
        receiverNumber: json["receiver_number"],
        callSummary: json["call_summary"],
        isDeleted: json["is_deleted"],
        status: json["status"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "sim_slot": simSlot,
        "sim_name": simName,
        "caller_name": callerName,
        "call_type": callType,
        "caller_number": callerNumber,
        "call_from": callFrom.toIso8601String(),
        "call_to": callTo.toIso8601String(),
        "call_duration": callDuration,
        "receiver_number": receiverNumber,
        "call_summary": callSummary,
        "is_deleted": isDeleted,
        "status": status,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
      };
}
