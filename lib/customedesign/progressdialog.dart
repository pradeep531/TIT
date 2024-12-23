import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colorfile.dart';

class ProgressDialog {
  static showProgressDialog(BuildContext context, String title) async {
    try {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
            const SizedBox(
              height: 10.0,
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      );
      await Future.delayed(const Duration(milliseconds: 50));
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Lottie.asset("assets/load.json");
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
