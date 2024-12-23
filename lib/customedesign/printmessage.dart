import 'package:flutter/material.dart';

import 'snackbardesign.dart';

class PrintMessage {
  static printmessage(String message, String functioname, String fileName,
      BuildContext context, Color bccolor, Color txcolor) {
    print(
        'Message: ${message}/ Function: ${functioname}/ FileName: ${fileName}');
    SnackBarDesign(
        'Message: ${message}/ Function: ${functioname}/ FileName: ${fileName}',
        context,
        bccolor,
        txcolor);
  }
}
