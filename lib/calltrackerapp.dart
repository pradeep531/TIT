import 'package:flutter/material.dart';

import 'callhistorypage.dart';

class CallTrackerApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Call Tracker',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: CallHistoryPage(navigatorKey),
    );
  }
}
