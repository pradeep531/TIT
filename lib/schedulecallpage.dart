import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:quickensolcrm/Network/call/monthwisecall.dart';
import 'package:quickensolcrm/Network/createjson.dart';
import 'package:quickensolcrm/Network/networkresponse.dart';
import 'package:quickensolcrm/Network/networkutility.dart';
import 'package:quickensolcrm/Network/response/monthwisescheduleresponse..dart';
import 'package:quickensolcrm/customedesign/apputility.dart';
import 'package:quickensolcrm/customedesign/progressdialog.dart';
import 'package:quickensolcrm/schedulecalldetails.dart';
import 'package:quickensolcrm/schedulecalldetailsforadmin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/painting.dart' as col;
import '../customedesign/colorfile.dart';
import '../customedesign/snackbardesign.dart';
import 'customedesign/ConnectivityService.dart';
import 'event.dart';

List<MonthwisescheculeDatum> attendancelist = [];

class Schedulecallpage extends StatefulWidget {
  String userid;
  Schedulecallpage(this.userid);
  State createState() => SchedulecallpageState();
}

late DateTime _selectedDay;
late DateTime _focusedDay;
CalendarFormat _calendarFormat = CalendarFormat.month;

class SchedulecallpageState extends State<Schedulecallpage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    Networkcallforgetfomonthattendance(true);
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

  @override
  void dispose() {
    // _controller.dispose();
    _connectivityService.dispose(); // Clean up the service
    super.dispose();
  }

  List<Event> events = [];

  Future<void> Networkcallforgetfomonthattendance(bool showprogress) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      events.clear();

      String createjsonstring = Createjson.createjsonforgetfomonthattendance(
          widget.userid, _selectedDay.month, _selectedDay.year, context);
      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.get_month_wise_call_schedule,
          NetworkUtility.get_month_wise_call_schedule_api,
          createjsonstring,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        List<Monthwisescheculeresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            attendancelist = response[0].data!;
            for (int i = 0; i < attendancelist.length; i++) {
              DateFormat format = DateFormat('yyyy-MM-dd');
              DateTime date =
                  format.parse(attendancelist[i].scheduleCallDate!.toString());
              // if (attendancelist[i].isPunchInSet == 1) {
              events.add(Event(date, Colors.blueAccent.withOpacity(0.5)));
              // }
            }
            setState(() {});
            break;
          case "false":
        }
      } else {
        if (showprogress) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  col.Color hexToColor(String hexString) {
    hexString = hexString.replaceAll("#", ""); // Remove the '#' if it exists
    if (hexString.length == 8) {
      return col.Color(int.parse("0x$hexString"));
    } else if (hexString.length == 6) {
      return col.Color(
          int.parse("0xFF$hexString")); // Add alpha value if not provided
    } else {
      throw FormatException("Invalid hex color format");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 249, 249, 249),
          toolbarHeight: 80.0,
          title: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'Scheduled Call',
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              Networkcallforgetfomonthattendance(false);
            },
            child: ListView(
              // physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 25),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colorfile().backgroundColor2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2023, 1, 1),
                      lastDay: DateTime.utc(2024, 12, 31),
                      focusedDay:
                          DateTime(_focusedDay.year, _focusedDay.month, 1),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      headerStyle: HeaderStyle(
                        formatButtonShowsNext: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          color: Colorfile().backgroundColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colorfile().backgroundColor2,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colorfile().backgroundColor2,
                        ),
                        formatButtonVisible: false,
                      ),
                      calendarFormat: _calendarFormat,
                      eventLoader: (date) {
                        return events
                            .where((event) => isSameDay(event.date, date))
                            .toList();
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, date, _) {
                          return Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                        selectedBuilder: (context, date, _) {
                          return Container(
                            width: 45,
                            height: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        },
                        markerBuilder: (context, date, events) {
                          final List<Event>? typedEvents =
                              events?.cast<Event>();

                          final event = typedEvents?.firstWhere(
                            (event) => isSameDay(event.date, date),
                            orElse: () =>
                                Event(DateTime.now(), Colors.transparent),
                          );

                          if (event != null) {
                            return Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: event.color ?? Colors.grey,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        if (AppUtility.UserType == "2") {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Schedulecalldetails(
                                DateFormat('dd-MM-yyyy').format(_selectedDay),
                                AppUtility.userId,
                              );
                            },
                          ));
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SchedulecalldetailsForAdmin(
                                DateFormat('dd-MM-yyyy').format(_selectedDay),
                                widget.userid,
                              );
                            },
                          ));
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _selectedDay = focusedDay;
                        _focusedDay = focusedDay;
                        setState(() {});
                        Networkcallforgetfomonthattendance(true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
