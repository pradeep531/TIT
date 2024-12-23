import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickensolcrm/Network/call/addcontactcall.dart';
import 'package:quickensolcrm/Network/call/daywiseschedulecall.dart';
import 'package:quickensolcrm/Network/call/getcallhistorycall.dart';
import 'package:quickensolcrm/Network/call/getcallsummarycall.dart';
import 'package:quickensolcrm/Network/call/monthwisecall.dart';
import 'package:quickensolcrm/Network/call/payloadcall.dart';
import 'package:quickensolcrm/Network/call/schedulecallcall.dart';
import 'package:quickensolcrm/Network/call/userlistcall.dart';
import 'package:quickensolcrm/Network/call/verifynumbercall.dart';

import 'call/calllogdetailscall.dart';
import 'call/registerusercall.dart';

class Createjson {
  static String createjsonforcalllogdetails(
      String simName,
      String duration,
      String callfromdate,
      String calltodate,
      String caller_number,
      String caller_name,
      String calltype,
      String receiver_number,
      String simsoltindex,
      String userId,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Calllogdetailscall logincall = Calllogdetailscall(
          callDuration: duration,
          callFrom: callfromdate,
          callTo: calltodate,
          caller_number: caller_number,
          callerName: caller_name,
          callType: calltype,
          simName: simName,
          simSlot: simsoltindex,
          receiver_number: receiver_number,
          user_id: userId);
      var result = Calllogdetailscall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforcalllogdetails1(
      String simName,
      String duration,
      String callfromdate,
      String calltodate,
      String caller_number,
      String caller_name,
      String calltype,
      String receiver_number,
      String simsoltindex,
      String userId,
      String call_summary) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Calllogdetailscall logincall = Calllogdetailscall(
          callDuration: duration,
          callFrom: callfromdate,
          callTo: calltodate,
          caller_number: caller_number,
          callerName: caller_name,
          callType: calltype,
          simName: simName,
          simSlot: simsoltindex,
          receiver_number: receiver_number,
          user_id: userId,
          call_summary: call_summary);
      var result = Calllogdetailscall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforregister(
      String simslot1,
      String simname1,
      String phonenumber1,
      String simslot2,
      String simname2,
      String phonenumber2,
      String pushtoken,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Registerusercall logincall = Registerusercall(
          simname1: simname1,
          simslot1: simslot1,
          phonenumber1: phonenumber1,
          simname2: simname2,
          simslot2: simslot2,
          phonenumber2: phonenumber2,
          push_token: pushtoken);
      var result = Registerusercall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforaddcontact(String firstName, String lastname,
      String mobileNumber, String userId, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Addcontactcall logincall = Addcontactcall(
          firstName: firstName,
          lastName: lastname,
          mobileNumber: mobileNumber,
          userId: userId);
      var result = Addcontactcall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforschedulecall(
      String name,
      String number,
      DateTime calldate,
      String calltime,
      String userId,
      String decription,
      BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Schedulecallcall logincall = Schedulecallcall(
          name: name,
          number: number,
          scheduleCallDate: calldate,
          scheduleCallTime: calltime,
          userId: userId,
          schedule_call_description: decription);
      var result = Schedulecallcall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforgetfomonthattendance(
      String userid, int month, int year, BuildContext context) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Monthwisescheculecall logincall = Monthwisescheculecall(
          userId: userid, month: month.toString(), year: year.toString());
      var result = Monthwisescheculecall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String createjsonfordaywisecall(
      String userId, String date, int page, int limit, String seachquery) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Daywisescheculecall logincall = Daywisescheculecall(
          userId: userId,
          date: date,
          limit: limit.toString(),
          offset: page.toString(),
          searchQuery: seachquery);
      var result = Daywisescheculecall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforgetcallsummary(
      String callernumber, String type, String userId) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getcallsummarycall logincall = Getcallsummarycall(
          userId: userId, summaryType: type, callerNumber: callernumber);
      var result = Getcallsummarycall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforverifynumber(
      String mobilenumber,
      appCurrentVersion,
      deviceOsVersion,
      deviceId,
      deviceManufacture,
      deviceModal,
      pushToken,
      tagetSdk,
      callLogPermission,
      contactsPermission,
      notificationPermission,
      scheduleExactAlarm,
      systemAlertPermission,
      device_os) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Verifynumbercall logincall = Verifynumbercall(
          mobileNumber: mobilenumber,
          appCurrentVersion: appCurrentVersion,
          callLogPermission: callLogPermission,
          contactsPermission: contactsPermission,
          deviceId: deviceId,
          deviceManufacture: deviceManufacture,
          deviceModal: deviceModal,
          deviceOsVersion: deviceOsVersion,
          notificationPermission: notificationPermission,
          pushToken: pushToken,
          scheduleExactAlarm: scheduleExactAlarm,
          systemAlertPermission: systemAlertPermission,
          tagetSdk: tagetSdk,
          device_os: device_os);
      var result = Verifynumbercall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforgetuserlist(String companyid) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Userlistcall logincall = Userlistcall(companyId: companyid);
      var result = Userlistcall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createjsonforgetcallhistory(String calltype, String userId) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Getcallhistorycall logincall =
          Getcallhistorycall(callType: calltype, userId: userId);
      var result = Getcallhistorycall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  String cratejsonforpayload(String format, String userId) {
    try {
      JsonEncoder encoder = JsonEncoder.withIndent('');
      Payloadcall logincall = Payloadcall(selectedDate: format, userId: userId);
      var result = Payloadcall.fromJson(logincall.toJson());
      String str = encoder.convert(result);
      return str;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }
}
