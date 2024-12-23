// To parse this JSON data, do
//
//     final verifymobilenumberresponse = verifymobilenumberresponseFromJson(jsonString);

import 'dart:convert';

List<Verifymobilenumberresponse> verifymobilenumberresponseFromJson(
        String str) =>
    List<Verifymobilenumberresponse>.from(
        json.decode(str).map((x) => Verifymobilenumberresponse.fromJson(x)));

String verifymobilenumberresponseToJson(
        List<Verifymobilenumberresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Verifymobilenumberresponse {
  String status;
  String message;
  Data data;

  Verifymobilenumberresponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Verifymobilenumberresponse.fromJson(Map<String, dynamic> json) =>
      Verifymobilenumberresponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String id;
  String companyId;
  String fullName;
  dynamic simslot1;
  dynamic simname1;
  String phonenumber1;
  dynamic simslot2;
  String simname2;
  dynamic phonenumber2;
  dynamic pushToken;
  String password;
  String userType;
  String status;
  String isDeleted;
  dynamic createdOn;
  DateTime updatedOn;

  Data({
    required this.id,
    required this.companyId,
    required this.fullName,
    required this.simslot1,
    required this.simname1,
    required this.phonenumber1,
    required this.simslot2,
    required this.simname2,
    required this.phonenumber2,
    required this.pushToken,
    required this.password,
    required this.userType,
    required this.status,
    required this.isDeleted,
    required this.createdOn,
    required this.updatedOn,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        companyId: json["company_id"],
        fullName: json["full_name"],
        simslot1: json["simslot1"],
        simname1: json["simname1"],
        phonenumber1: json["phonenumber1"],
        simslot2: json["simslot2"],
        simname2: json["simname2"],
        phonenumber2: json["phonenumber2"],
        pushToken: json["push_token"],
        password: json["password"],
        userType: json["user_type"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"],
        updatedOn: DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "full_name": fullName,
        "simslot1": simslot1,
        "simname1": simname1,
        "phonenumber1": phonenumber1,
        "simslot2": simslot2,
        "simname2": simname2,
        "phonenumber2": phonenumber2,
        "push_token": pushToken,
        "password": password,
        "user_type": userType,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn,
        "updated_on": updatedOn.toIso8601String(),
      };
}
