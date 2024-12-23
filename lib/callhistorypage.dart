import 'dart:ui';

import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_state/phone_state.dart';
import 'package:quickensolcrm/customedesign/apputility.dart';
import 'package:quickensolcrm/login.dart';
import 'package:quickensolcrm/schedulecalldialog.dart';
import 'package:quickensolcrm/schedulecallpage.dart';
import 'package:quickensolcrm/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_alert_window/system_alert_window.dart';

import 'callcontactlistview.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/sharedpref.dart';
import 'customedesign/snackbardesign.dart';

class CallHistoryPage extends ConsumerStatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  CallHistoryPage(this.navigatorKey);

  @override
  CallHistoryPageState createState() => CallHistoryPageState();
}

class CallHistoryPageState extends ConsumerState<CallHistoryPage> {
  List<CallLogEntry> _callLogs = [];
  Map<String, List<CallLogEntry>> _contactCallLogs = {};
  PhoneStateStatus _status = PhoneStateStatus.NOTHING;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();

    _getCallLogs();
    _listenToPhoneState();
    _connectivityService.connectionStatus.listen((isConnected) {
      setState(() {
        _isConnected = isConnected; // Update connection status
      });
      if (isConnected) {
        // showinternetstatus('You are online!.', context);
      } else {
        showinternetstatus('No internet connection.', context, error: true);
      }
    });
  }

  Future<void> _listenToPhoneState() async {
    PhoneState.stream.listen(
      (event) async {
        switch (event.status) {
          case PhoneStateStatus.CALL_ENDED:
            break;
          case PhoneStateStatus.NOTHING:
            // TODO: Handle this case.
            break;
          case PhoneStateStatus.CALL_INCOMING:
            _callLogs = [];
            _getCallLogs();
            break;
          case PhoneStateStatus.CALL_STARTED:
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivityService.dispose(); // Clean up the service
  }

  String formatDuration(int? durationInSeconds) {
    if (durationInSeconds == null) return "0s";
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  Future<void> _getCallLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    setState(() {
      _callLogs = entries.toList();
      _aggregateCallLogs();
    });
  }

  void _aggregateCallLogs() {
    _contactCallLogs.clear();
    for (var entry in _callLogs) {
      final contactName = entry.name ?? entry.number ?? 'Unknown Number';
      if (!_contactCallLogs.containsKey(contactName)) {
        _contactCallLogs[contactName] = [];
      }
      _contactCallLogs[contactName]!.add(entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Hi ! ${AppUtility.Name}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 1, // Slight elevation for a more defined look
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ScheduleCallDialog(
                        "callhistorypage", "", "", false, false);
                  },
                ));
                // showScheduleCallDialog(context, "callhistorypage", "", "");
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Schedulecallpage(AppUtility.userId)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.blueAccent),
              onPressed: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Increased font size for better visibility
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              tabs: [
                Tab(text: "Incoming"),
                Tab(text: "Outgoing"),
                Tab(text: "Missed"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  _getCallLogs();
                  setState(() {});
                });
              },
              child: CallContactListView(
                contactCallLogs: _contactCallLogs,
                callType: CallType.incoming,
              ),
            ),
            RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  _getCallLogs();
                });
              },
              child: CallContactListView(
                contactCallLogs: _contactCallLogs,
                callType: CallType.outgoing,
              ),
            ),
            RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  _getCallLogs();
                });
              },
              child: CallContactListView(
                contactCallLogs: _contactCallLogs,
                callType: CallType.missed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Wrap(
              children: [
                ClipRect(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 86, 208, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300], // Horizontal gray line
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              // Use Expanded for Cancel button
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                },
                                style: ButtonStyle(
                                  side: MaterialStateProperty.resolveWith<
                                      BorderSide>(
                                    (Set<MaterialState> states) {
                                      return BorderSide(
                                          color:
                                              Colors.grey[300]!); // Gray border
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: 50), // Adjust spacing between buttons
                            Expanded(
                              // Use Expanded for Yes, logout button
                              child: ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences idsaver =
                                      await SharedPreferences.getInstance();
                                  await idsaver.clear();
                                  Navigator.pop(context);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color.fromRGBO(
                                        0, 86, 208, 1), // Blue background
                                  ),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Yes, logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
