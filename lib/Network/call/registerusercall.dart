// To parse this JSON data, do
//
//     final registerusercall = registerusercallFromJson(jsonString);

import 'dart:convert';

Registerusercall registerusercallFromJson(String str) =>
    Registerusercall.fromJson(json.decode(str));

String registerusercallToJson(Registerusercall data) =>
    json.encode(data.toJson());

class Registerusercall {
  String? simslot1;
  String? simname1;
  String? phonenumber1;
  String? simslot2;
  String? simname2;
  String? push_token;
  String? phonenumber2;

  Registerusercall({
    this.simslot1,
    this.simname1,
    this.phonenumber1,
    this.simslot2,
    this.simname2,
    this.phonenumber2,
    this.push_token,
  });

  factory Registerusercall.fromJson(Map<String, dynamic> json) =>
      Registerusercall(
        simslot1: json["simslot1"],
        simname1: json["simname1"],
        phonenumber1: json["phonenumber1"],
        simslot2: json["simslot2"],
        simname2: json["simname2"],
        phonenumber2: json["phonenumber2"],
        push_token: json["push_token"],
      );

  Map<String, dynamic> toJson() => {
        "simslot1": simslot1,
        "simname1": simname1,
        "phonenumber1": phonenumber1,
        "simslot2": simslot2,
        "simname2": simname2,
        "phonenumber2": phonenumber2,
        "push_token": push_token
      };
}
