import 'dart:developer';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:quickensolcrm/notificationhelper.dart';
import 'Network/call/reminder_model.dart';
import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/addcontactresponse.dart';
import 'Network/response/schedulecallresponse.dart';
import 'customedesign/apputility.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/progressdialog.dart';
import 'customedesign/snackbardesign.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'custompicker.dart';
import 'dbhelper.dart';
import 'notification_services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class ScheduleCallDialog extends StatefulWidget {
  String pagename, name, mobile;
  bool isnameeditable, isnumbereditable;
  ScheduleCallDialog(this.pagename, this.name, this.mobile, this.isnameeditable,
      this.isnumbereditable);

  @override
  ScheduleCallDialogState createState() => ScheduleCallDialogState();
}

class ScheduleCallDialogState extends State<ScheduleCallDialog> {
  final _nameController = TextEditingController();
  final _calldateController = TextEditingController();
  final _calltimeController = TextEditingController();
  final _mobilenumberController = TextEditingController();
  final _decriptionController = TextEditingController();
  DateTime calldate = DateTime.now();
  DateTime finalDateTime = DateTime.now();
  TimeOfDay initialTime = TimeOfDay.now();

  bool validateName = true;
  bool validatedate = true;
  bool validatetime = true;
  bool validatenumber = true;
  String errorTime = "Please Select Call Schedule Time", _fullPhoneNumber = "";
  @override
  void initState() {
    super.initState();
    if (widget.name.isNotEmpty) {
      _nameController.text = widget.name;
    }
    if (widget.mobile.isNotEmpty) {
      setPhoneNumber(widget.mobile);
    }
  }

  String name = "", mobileNumber = "";
  Future<void> _getDataFromAndroid() async {
    try {
      final Map<String, dynamic> data =
          await AppUtility.platform.invokeMethod('getInitialData');
      setState(() {
        name = data['name'] ?? '';
        mobileNumber = data['mobileNumber'] ?? '';
      });
      log("Name: $name, MobileNumber: $mobileNumber");
    } on PlatformException catch (e) {
      print("Failed to get data: '${e.message}'.");
    }
  }

  void setPhoneNumber(String fullNumber) {
    if (fullNumber.startsWith("+")) {
      // Extract country code (e.g., +91) and phone number
      String countryCode = fullNumber.substring(0, 3); // "+91" for India
      String phoneNumber = fullNumber.substring(3); // "7709778899"

      // Set the initial country code and phone number
      setState(() {
        _mobilenumberController.text = phoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract the route name
    // final routeName = ModalRoute.of(context)?.settings.name;

    // // Parse the query parameters
    // final uri = Uri.parse(routeName ?? '');
    // final number = uri.queryParameters['name'];
    // final mobileNumber = uri.queryParameters['mobileNumber'];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for iOS style
        ),
        elevation: 0, // Remove elevation for a flat look
        backgroundColor: Colors.transparent, // Transparent background
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.only(
              bottom: 20, top: 5, right: 10, left: 10), // Uniform padding
          decoration: BoxDecoration(
            color: Colors.white, // White background for the dialog
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Soft shadow
                blurRadius: 15,
                offset: Offset(0, 5), // Shadow below the dialog
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent.withOpacity(0.5),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    )
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Left-aligned content
                    children: [
                      Text(
                        'Schedule Call',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.w500, // Bold font for the title
                          fontSize: 22, // Font size for the title
                          color: Colors.black, // Black text for contrast
                        ),
                      ),
                      const SizedBox(height: 16), // Spacing below the title

                      // Input Fields
                      _sizeBoxWidget(),
                      _nameWidget(),
                      _sizeBoxWidget(),
                      _scheduledDateWidget(),
                      _sizeBoxWidget(),
                      _scheduledTimeWidget(),
                      _sizeBoxWidget(),
                      _numberWidget(),
                      _sizeBoxWidget(),
                      _descWidget(), _sizeBoxWidget(),
                      // Schedule Call Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            validateName = _nameController.text.isNotEmpty;
                            validatedate = _calldateController.text.isNotEmpty;
                            validatetime = _calltimeController.text.isNotEmpty;
                            // validatenumber =
                            //     _mobilenumberController.text.isNotEmpty;
                          });

                          if (validateName && validatedate && validatetime) {
                            _addReminder();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20), // Margin above the button
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF), // iOS blue color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    14), // Vertical padding for the button
                            child: Center(
                              child: Text(
                                'Schedule Call',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Colors.white, // White text for the button
                                  fontSize: 18, // Font size for button text
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Spacing below the button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizeBoxWidget() {
    return SizedBox(height: 10);
  }

  Widget _nameWidget() {
    return TextFormField(
      controller: _nameController,
      readOnly: widget.isnameeditable ? true : false,
      onChanged: (value) {
        setState(() {
          validateName = true;
        });
      },
      decoration: InputDecoration(
        labelText: 'Name *',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        errorText: validateName ? null : 'Please Enter Name',
      ),
    );
  }

  Widget _scheduledDateWidget() {
    return TextFormField(
      controller: _calldateController,
      decoration: InputDecoration(
        labelText: 'Schedule Date*',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        errorText: validatedate ? null : 'Please Select Call Schedule Date',
        suffixIcon: IconButton(
          onPressed: () async {
            validatedate = true;
            _selectDateTime(context);
          },
          icon: Icon(CupertinoIcons.calendar),
        ),
      ),
    );
  }

  Widget _scheduledTimeWidget() {
    return TextFormField(
      controller: _calltimeController,
      decoration: InputDecoration(
        labelText: 'Schedule Time*',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        suffixIcon: IconButton(
          onPressed: () async {
            if (selectedDate != null) {
              validatedate = true;
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                finalDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );

                var formattedTime =
                    DateFormat('hh:mm a').format(finalDateTime!);

                _calltimeController.text =
                    formattedTime; // Set the value of text field.
                setState(() {});
              }
            } else {
              validatedate = false;
              setState(() {});
            }
          },
          icon: Icon(Icons.punch_clock),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        errorText: validatetime ? null : errorTime,
      ),
    );
  }

  Widget _numberWidget() {
    return IntlPhoneField(
      controller: _mobilenumberController,
      readOnly: widget.isnumbereditable ? true : false,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide:
              BorderSide(color: Colors.grey), // Change to your border color
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        errorText: validatenumber ? null : 'Please Enter Mobile Number',
      ),
      initialCountryCode: 'IN', // Set your initial country code
      onChanged: (phone) {
        // Update the full phone number with country code
        setState(() {
          _fullPhoneNumber = '${phone.countryCode}${phone.number}';
        });
        print('Full Phone Number: $_fullPhoneNumber');
      },
      validator: (value) {
        if (value == null ||
            value.number.isEmpty ||
            value.number.length != 10) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
    );
  }

  Widget _descWidget() {
    return TextFormField(
      controller: _decriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor3),
        ),
      ),
    );
  }

  DateTime? selectedDate;
  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      selectedDate = pickedDate;
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        _calldateController.text = formattedDate;

        var formattedTime = DateFormat('HH:mm').format(finalDateTime!);
        _calltimeController.text =
            formattedTime; // Set the value of text field.
        setState(() {});
      }
    }
  }

  void _addReminder() async {
    try {
      if (finalDateTime != null) {
        Reminder newReminder = Reminder(
          title: "Schedule Reminder",
          dateTime: finalDateTime!,
        );
        int id = await DBHelper().insertReminder(newReminder);

        DateTime now = DateTime.now();
        DateTime reminderTime = newReminder.dateTime;
        Duration difference = reminderTime.difference(now);
        Duration notificationOffset = Duration(minutes: 15);

        if (difference > notificationOffset) {
          DateTime notificationTime = reminderTime.subtract(notificationOffset);

          final tz.TZDateTime scheduledTime =
              tz.TZDateTime.from(notificationTime, tz.local);
          // NotificationService().scheduleNotification(
          //   id: id,
          //   title: 'Schedule Call Reminder',
          //   body:
          //       'You have scheduled a call with ${_nameController.text} after 15 mins',
          //   scheduledNotificationDateTime: notificationTime,
          // );
          String createjson = Createjson().cratejsonforpayload(
              DateFormat('dd-MM-yyyy').format(notificationTime),
              AppUtility.userId);
          NotificationHelper.notificationHelper.scheduleNotification(
              'Schedule Reminder',
              _mobilenumberController.text.isEmpty
                  ? 'You have schdeule reminder'
                  : 'You have scheduled a call with ${_nameController.text} after 15 mins',
              scheduledTime,
              createjson);
          Networkcallforschedulecall(true);
        } else {
          // DateTime notificationTime = DateTime.now().add(Duration(seconds: 5));
          // NotificationService().scheduleNotification(
          //     title: 'Scheduled Notification',
          //     body: '$notificationTime',
          //     scheduledNotificationDateTime: notificationTime);
          // log("Scheduling notification for: $notificationTime");
          validatetime = false;
          errorTime =
              "Time should be greater than 15 minutes from current time";
        }
      } else {
        log("Final date time not set.");
      }
    } catch (e) {
      SnackBarDesign(e.toString(), context, Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
  }

  Future<void> Networkcallforschedulecall(showprogress) async {
    try {
      // if (showprogress) {
      //   ProgressDialog.showProgressDialog(context, "Please Wait...");
      // }
      String createjson = Createjson.createjsonforschedulecall(
          _nameController.text,
          _fullPhoneNumber,
          calldate,
          _calltimeController.text,
          AppUtility.userId,
          _decriptionController.text.isEmpty ? '' : _decriptionController.text,
          context);

      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.add_call_schedule,
          NetworkUtility.add_call_schedule_api,
          createjson,
          context);
      if (list != null) {
        // if (showprogress) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }
        List<Schedulecallresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            SnackBarDesign(
                "Call Schedule Successfully",
                context,
                Colorfile().sucessmessagebcColor,
                Colorfile().sucessmessagetxColor);
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context); // Pops the current screen after 3 seconds
            });
            break;
          case "false":
            SnackBarDesign(
                response[0].message!,
                context,
                Colorfile().errormessagebcColor,
                Colorfile().errormessagetxColor);
            break;
        }
      } else {
        // if (showprogress) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      SnackBarDesign(e.toString(), context, Colorfile().errormessagebcColor,
          Colorfile().errormessagetxColor);
    }
  }
}

// To call the dialog

