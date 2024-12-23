import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppUtility {
  static bool isAllow = false;
  static String userId = "0";
  static String isloginfirst = "";
  static const platform = MethodChannel("quickensolcrm");
  static String callername = "";
  static String callernumber = "";
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static String password = "";
  static String UserType = "";
  static String CompanyId = "";
  static String Name = "";
  static String isTrackingAllowrdToAdmin = "1";
}
