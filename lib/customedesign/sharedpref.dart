import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apputility.dart';
import 'colorfile.dart';
import 'printmessage.dart';

class SharedPreference {
  late SharedPreferences sharedPreferences;

  Future setValueToSharedPrefernce(String key, String Value) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setString(key, Value);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getValueFromSharedPrefernce(
      String key, BuildContext context) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String? abc = sharedPreferences.getString(key);
      if (abc == null) {
        return "";
      } else {
        return abc;
      }
    } catch (e) {
      PrintMessage.printmessage(
          e.toString(),
          'getValueFromSharedPrefernce',
          'SharedPreference',
          context,
          Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
    return "";
  }

  Future<String?> getValue(
    String key,
  ) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      String? abc = sharedPreferences.getString(key);
      if (abc == null) {
        return "";
      } else {
        return abc;
      }
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  Future setboolValueToSharedPrefernce(
      String key, bool Value, BuildContext context) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setBool(key, Value);
    } catch (e) {
      PrintMessage.printmessage(
          e.toString(),
          'setboolValueToSharedPrefernce',
          'SharedPreference',
          context,
          Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
  }

  Future<bool?> getboolValueFromSharedPrefernce(
      String key, BuildContext context) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      bool? abc = sharedPreferences.getBool(key);
      if (abc == null) {
        return false;
      } else {
        return abc;
      }
    } catch (e) {
      PrintMessage.printmessage(
          e.toString(),
          'getValueFromSharedPrefernce',
          'SharedPreference',
          context,
          Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
    return false;
  }

  savevalueonlogin(String id, String isloginfirst, String password,
      String UserType, String CompanyId, String Name, BuildContext context) {
    try {
      SharedPreference().setValueToSharedPrefernce("user_id", id);
      SharedPreference()
          .setValueToSharedPrefernce("isloginfirst", isloginfirst);
      SharedPreference().setValueToSharedPrefernce("password", password);
      SharedPreference().setValueToSharedPrefernce("usertype", UserType);
      SharedPreference().setValueToSharedPrefernce("companyid", CompanyId);
      SharedPreference().setValueToSharedPrefernce("name", Name);

      AppUtility.userId = id;
      AppUtility.isloginfirst = isloginfirst;
      AppUtility.password = password;
      AppUtility.UserType = UserType;
      AppUtility.CompanyId = CompanyId;
      AppUtility.Name = Name;
    } catch (e) {
      PrintMessage.printmessage(
          e.toString(),
          'savevalueonlogin',
          'SharedPreference',
          context,
          Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
  }

  getvalueonligin(BuildContext context) async {
    try {
      AppUtility.userId = (await SharedPreference()
          .getValueFromSharedPrefernce("user_id", context))!;
      AppUtility.isloginfirst = (await SharedPreference()
          .getValueFromSharedPrefernce("isloginfirst", context))!;
      AppUtility.password = (await SharedPreference()
          .getValueFromSharedPrefernce("password", context))!;
      AppUtility.CompanyId = (await SharedPreference()
          .getValueFromSharedPrefernce("companyid", context))!;
      AppUtility.UserType = (await SharedPreference()
          .getValueFromSharedPrefernce("usertype", context))!;
      AppUtility.Name = (await SharedPreference()
          .getValueFromSharedPrefernce("name", context))!;
    } catch (e) {
      PrintMessage.printmessage(
          e.toString(),
          'getvalueonlogin',
          'SharedPreference',
          context,
          Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
  }

  Future setboolValue(String key, bool Value) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setBool(key, Value);
    } catch (e) {}
  }

  Future<bool?> getboolValue(String key) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      bool? abc = sharedPreferences.getBool(key);
      if (abc == null) {
        return false;
      } else {
        return abc;
      }
    } catch (e) {}
    return false;
  }

  savetrakingvalue(String istrackingallowed) {
    SharedPreference()
        .setValueToSharedPrefernce("istrackingallowed", istrackingallowed);
  }

  gettrakingvalue() async {
    AppUtility.userId =
        (await SharedPreference().getValue("istrackingallowed"))!;
  }
}
