import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quickensolcrm/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'schedulecalldetails.dart';

class NotificationHelper {
  NotificationHelper._();

  static final NotificationHelper notificationHelper = NotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    Future<void> notificationTapBackground(
        NotificationResponse notificationResponse) async {
      // notificationResponse.payload;
      // handle action
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      Map<String, dynamic> data =
          json.decode(payload!); // Decode the JSON string
      String userId = data['user_id'];
      String selectedDate = data['selected_date'];
      Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
        builder: (context) {
          return Schedulecalldetails(selectedDate, userId);
        },
      ));
    }
  }

  Future<void> scheduleNotification(
      String title, String body, notificationTime, String createjson) async {
    tz.initializeTimeZones();

    // Android-specific notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('channel id 1', 'channel name 1',
            channelDescription: 'channel description',
            icon: 'mipmap/ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
            priority: Priority.high,
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound('notification'));

    // iOS-specific notification details
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Platform-specific notification details (Android/iOS)
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Schedule notification using zonedSchedule
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      notificationTime, // Schedule 10 seconds from now
      platformChannelSpecifics, // Notification details
      payload: createjson, // Custom payload
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime, // Interpretation of the notification time
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Android-specific scheduling behavior
      matchDateTimeComponents:
          DateTimeComponents.time, // Match specific time components
    );
  }
}
