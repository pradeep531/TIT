// To parse this JSON data, do
//
//     final verifynumbercall = verifynumbercallFromJson(jsonString);

import 'dart:convert';

Verifynumbercall verifynumbercallFromJson(String str) =>
    Verifynumbercall.fromJson(json.decode(str));

String verifynumbercallToJson(Verifynumbercall data) =>
    json.encode(data.toJson());

class Verifynumbercall {
  String deviceOsVersion;
  String deviceId;
  String deviceManufacture;
  String deviceModal;
  String tagetSdk;
  String appCurrentVersion;
  String pushToken;
  String callLogPermission;
  String notificationPermission;
  String contactsPermission;
  String systemAlertPermission;
  String scheduleExactAlarm;
  String mobileNumber;
  String device_os;
  Verifynumbercall({
    required this.deviceOsVersion,
    required this.deviceId,
    required this.deviceManufacture,
    required this.deviceModal,
    required this.tagetSdk,
    required this.appCurrentVersion,
    required this.pushToken,
    required this.callLogPermission,
    required this.notificationPermission,
    required this.contactsPermission,
    required this.systemAlertPermission,
    required this.scheduleExactAlarm,
    required this.mobileNumber,
    required this.device_os,
  });

  factory Verifynumbercall.fromJson(Map<String, dynamic> json) =>
      Verifynumbercall(
        deviceOsVersion: json["device_os_version"],
        deviceId: json["device_id"],
        deviceManufacture: json["device_manufacture"],
        deviceModal: json["device_modal"],
        tagetSdk: json["taget_sdk"],
        appCurrentVersion: json["app_current_version"],
        pushToken: json["push_token"],
        callLogPermission: json["call_log_permission"],
        notificationPermission: json["notification_permission"],
        contactsPermission: json["contacts_permission"],
        systemAlertPermission: json["system_alert_permission"],
        scheduleExactAlarm: json["schedule_exact_alarm"],
        mobileNumber: json["mobile_number"],
        device_os: json["device_os"],
      );

  Map<String, dynamic> toJson() => {
        "device_os_version": deviceOsVersion,
        "device_id": deviceId,
        "device_manufacture": deviceManufacture,
        "device_modal": deviceModal,
        "taget_sdk": tagetSdk,
        "app_current_version": appCurrentVersion,
        "push_token": pushToken,
        "call_log_permission": callLogPermission,
        "notification_permission": notificationPermission,
        "contacts_permission": contactsPermission,
        "system_alert_permission": systemAlertPermission,
        "schedule_exact_alarm": scheduleExactAlarm,
        "mobile_number": mobileNumber,
        "device_os": device_os
      };
}
