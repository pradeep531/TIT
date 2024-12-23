// To parse this JSON data, do
//
//     final userlistresponse = userlistresponseFromJson(jsonString);

import 'dart:convert';

List<Userlistresponse> userlistresponseFromJson(String str) =>
    List<Userlistresponse>.from(
        json.decode(str).map((x) => Userlistresponse.fromJson(x)));

String userlistresponseToJson(List<Userlistresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Userlistresponse {
  String status;
  String message;
  List<UserlistDatum> data;

  Userlistresponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Userlistresponse.fromJson(Map<String, dynamic> json) =>
      Userlistresponse(
        status: json["status"],
        message: json["message"],
        data: List<UserlistDatum>.from(
            json["data"].map((x) => UserlistDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UserlistDatum {
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
  dynamic deviceOs;
  dynamic deviceOsVersion;
  dynamic deviceId;
  dynamic deviceManufacture;
  dynamic deviceModal;
  dynamic tagetSdk;
  dynamic appCurrentVersion;
  String callLogPermission;
  String notificationPermission;
  String contactsPermission;
  String systemAlertPermission;
  String scheduleExactAlarm;
  String status;
  String isDeleted;
  dynamic createdOn;
  DateTime updatedOn;

  UserlistDatum({
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
    required this.deviceOs,
    required this.deviceOsVersion,
    required this.deviceId,
    required this.deviceManufacture,
    required this.deviceModal,
    required this.tagetSdk,
    required this.appCurrentVersion,
    required this.callLogPermission,
    required this.notificationPermission,
    required this.contactsPermission,
    required this.systemAlertPermission,
    required this.scheduleExactAlarm,
    required this.status,
    required this.isDeleted,
    required this.createdOn,
    required this.updatedOn,
  });

  factory UserlistDatum.fromJson(Map<String, dynamic> json) => UserlistDatum(
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
        deviceOs: json["device_os"],
        deviceOsVersion: json["device_os_version"],
        deviceId: json["device_id"],
        deviceManufacture: json["device_manufacture"],
        deviceModal: json["device_modal"],
        tagetSdk: json["taget_sdk"],
        appCurrentVersion: json["app_current_version"],
        callLogPermission: json["call_log_permission"],
        notificationPermission: json["notification_permission"],
        contactsPermission: json["contacts_permission"],
        systemAlertPermission: json["system_alert_permission"],
        scheduleExactAlarm: json["schedule_exact_alarm"],
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
        "device_os": deviceOs,
        "device_os_version": deviceOsVersion,
        "device_id": deviceId,
        "device_manufacture": deviceManufacture,
        "device_modal": deviceModal,
        "taget_sdk": tagetSdk,
        "app_current_version": appCurrentVersion,
        "call_log_permission": callLogPermission,
        "notification_permission": notificationPermission,
        "contacts_permission": contactsPermission,
        "system_alert_permission": systemAlertPermission,
        "schedule_exact_alarm": scheduleExactAlarm,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn,
        "updated_on": updatedOn.toIso8601String(),
      };
}
