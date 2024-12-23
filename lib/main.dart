import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quickensolcrm/schedulecalldialog.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'notification_services.dart';
import 'notificationhelper.dart';
import 'splashscreen.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    // Handle background task
    print("Native called background task: $task");
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    FirebaseMessaging.onBackgroundMessage(firebasebackgroundHandler);
  });
  // NotificationService().initNotification();
  // tz.initializeTimeZones();
  tz.initializeTimeZones();
  NotificationHelper.initializeNotifications();
  // runApp(
  //   MyApp(),
  // );
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    home: MyApp(),
  ));
}

@pragma('vm:entry-point')
Future<void> firebasebackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Background message title ' + message.data['title'].toString());
    // NotificationService notificationServices = NotificationService();
    // notificationServices.showIncomingCallNotification(message.from!);
  } catch (e) {
    print('Error for notification' + e.toString());
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('quickensolcrm');
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @pragma('vm:entry-point')
  MyApp() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "getAppVersion") {
        String? playstoreappversion = await getAppVersion();
        log(playstoreappversion!);
      }
    });
  }

  Future<String?> getAppVersion() async {
    try {
      final String? version = await platform.invokeMethod('getAppVersion');
      return version;
    } on PlatformException catch (e) {
      print("Failed to get app version: '${e.message}'.");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Call Popup',
        scaffoldMessengerKey: scaffoldMessengerKey, // Assign the key here
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}
