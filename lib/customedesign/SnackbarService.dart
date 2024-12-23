import 'package:flutter/material.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  SnackbarService(this.scaffoldMessengerKey);

  void showSnackbar(String message, {bool error = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : Colors.green,
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
