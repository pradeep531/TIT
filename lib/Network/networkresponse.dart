import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:quickensolcrm/Network/response/addcontactresponse.dart';
import 'package:quickensolcrm/Network/response/calllogresponse.dart';
import 'package:quickensolcrm/Network/response/daywisescheduleresponse.dart';
import 'package:quickensolcrm/Network/response/getcallsummaryresponse.dart';
import 'package:quickensolcrm/Network/response/monthwisescheduleresponse..dart';
import 'package:quickensolcrm/Network/response/schedulecallresponse.dart';
import 'package:quickensolcrm/Network/response/userlistresponse.dart';
import 'package:quickensolcrm/Network/response/verifymobilenumberresponse.dart';

import 'response/calllogdetailsresponse.dart';
import 'response/registeruserresponse.dart';

class NetworkResponse {
  Future<List<Object?>?> postMethod(
      int requestCode, String url, String body, BuildContext context) async {
    try {
      log(url);
      log(body);
      var response = await post(Uri.parse(url), body: body);
      var data = response.body;
      log(data);

      if (response.statusCode == 200) {
        String str = "[" + response.body + "]";
        log(str);
        switch (requestCode) {
          case 1:
            final registeruser = registeruserresponseFromJson(str);
            return registeruser;

          case 2:
            final calllog = calllogdetailsresponseFromJson(str);
            return calllog;
          case 3:
            final addcontact = addcontactresponseFromJson(str);
            return addcontact;
          case 4:
            final schedulecall = schedulecallresponseFromJson(str);
            return schedulecall;
          case 5:
            final monthwiseschele = monthwisescheculeresponseFromJson(str);
            return monthwiseschele;
          case 6:
            final daywiseschedule = daywisescheculeresponseFromJson(str);
            return daywiseschedule;
          case 8:
            final verifynumber = verifymobilenumberresponseFromJson(str);
            return verifynumber;
          case 9:
            final getuserlist = userlistresponseFromJson(str);
            return getuserlist;
          case 10:
            final calllog = calllogresponseFromJson(str);
            return calllog;
            break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Object?>?> getMethod(int requestCode, String url) async {
    var response = await get(Uri.parse(url));
    var data = response.body;

    if (response.statusCode == 200) {
      String str = "[" + response.body + "]";
      switch (requestCode) {}
    }
  }

  Future<List<Object?>?> postMethod1(
      int requestCode, String url, String body) async {
    try {
      log(url);
      log(body);
      var response = await post(Uri.parse(url), body: body);
      var data = response.body;
      log(data);

      if (response.statusCode == 200) {
        String str = "[" + response.body + "]";
        log(str);
        switch (requestCode) {
          case 2:
            final calllog = calllogdetailsresponseFromJson(str);
            return calllog;

          case 7:
            final getcallsummary = getcallsummaryresponseFromJson(str);
            return getcallsummary;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
