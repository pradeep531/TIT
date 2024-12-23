import 'package:flutter/material.dart';
import 'colorfile.dart';

void SnackBarDesign(String Message, BuildContext context, Color backgroundColor,
    Color textColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(
      Message,
      style: TextStyle(color: textColor),
    ),
    backgroundColor: backgroundColor.withOpacity(0.7),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating, // Customize the behavior
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Customize the border radius
    ),
  ));

  print(Message);
}

void SomethingWentWrongSnackBarDesign(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(
      "Something went wrong!",
      style: TextStyle(color: Colorfile().errormessagetxColor),
    ),
    backgroundColor: Colorfile().errormessagebcColor.withOpacity(0.7),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating, // Customize the behavior
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Customize the border radius
    ),
  ));
}

void SnackBarDesignLowTime(String Message, BuildContext context,
    Color backgroundColor, Color textColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: new Text(
      Message,
      style: TextStyle(color: textColor),
    ),
    backgroundColor: backgroundColor.withOpacity(0.7),
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating, // Customize the behavior
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Customize the border radius
    ),
  ));

  print(Message);
}

void showinternetstatus(String message, BuildContext context,
    {bool error = false}) {
  final snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    backgroundColor: error ? Colors.red : Colors.green,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
