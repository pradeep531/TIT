// To parse this JSON data, do
//
//     final calllogdetailscall = calllogdetailscallFromJson(jsonString);

import 'dart:convert';

Calllogdetailscall calllogdetailscallFromJson(String str) =>
    Calllogdetailscall.fromJson(json.decode(str));

String calllogdetailscallToJson(Calllogdetailscall data) =>
    json.encode(data.toJson());

class Calllogdetailscall {
  String? simSlot;
  String? callDuration;
  String? callFrom;
  String? callTo;
  String? caller_number;
  String? simName;
  String? callerName;
  String? callType;
  String? receiver_number;
  String? user_id;
  String? call_summary;
  Calllogdetailscall({
    this.simSlot,
    this.callDuration,
    this.callFrom,
    this.callTo,
    this.caller_number,
    this.simName,
    this.callerName,
    this.callType,
    this.receiver_number,
    this.user_id,
    this.call_summary,
  });

  factory Calllogdetailscall.fromJson(Map<String, dynamic> json) =>
      Calllogdetailscall(
        simSlot: json["sim_slot"],
        callDuration: json["call_duration"],
        callFrom: json["call_from"],
        callTo: json["call_to"],
        caller_number: json["caller_number"],
        simName: json["sim_name"],
        callerName: json["caller_name"],
        callType: json["call_type"],
        receiver_number: json["receiver_number"],
        user_id: json["user_id"],
        call_summary: json["call_summary"],
      );

  Map<String, dynamic> toJson() => {
        "sim_slot": simSlot,
        "call_duration": callDuration,
        "call_from": callFrom,
        "call_to": callTo,
        "caller_number": caller_number,
        "sim_name": simName,
        "caller_name": callerName,
        "call_type": callType,
        "receiver_number": receiver_number,
        "user_id": user_id,
        "call_summary": call_summary
      };
}
