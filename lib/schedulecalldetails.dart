import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quickensolcrm/Network/createjson.dart';
import 'package:quickensolcrm/Network/response/daywisescheduleresponse.dart';
import 'package:quickensolcrm/customedesign/apputility.dart';
import 'package:quickensolcrm/customedesign/colorfile.dart';
import 'package:quickensolcrm/customedesign/snackbardesign.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/progressdialog.dart';
import 'schedulecalldialog.dart';

List<DaywisescheculeDatum> listofschedule = [];
List<DaywisescheculeDatum> searchlistofschedule = [];
bool nodata = true, isloading = true;

final TextEditingController _searchController = TextEditingController();

class Schedulecalldetails extends StatefulWidget {
  String date, userid;
  Schedulecalldetails(this.date, this.userid);
  State createState() => Schedulecalldetailsstate();
}

class Schedulecalldetailsstate extends State<Schedulecalldetails> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  int page = 0, limit = 10;
  bool _isFirstloading = false, _hashnextpage = true, isloadingmore = false;
  late ScrollController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isloading = true;
    page = 0;
    _isFirstloading = false;
    _hashnextpage = true;
    isloadingmore = false;
    Networkcallforschedulecalldetails(true, page, "");
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 200) {
          // Trigger loads more when close to the bottom (adjust offset as needed)
          loadmore();
        }
      });
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

    _searchController.addListener(_filterschedule);
  }

  @override
  void dispose() {
    // _controller.dispose();

    super.dispose();
    nodata = false;
    isloading = false;
    listofschedule.clear();
    _connectivityService.dispose(); // Clean up the service
    _searchController.clear();
    page = 0;
    _isFirstloading = false;
    _hashnextpage = true;
    isloadingmore = false;
  }

  Future<void> Networkcallforschedulecalldetails(
      bool showprogress, int page, String searchquery) async {
    try {
      isloading = false;
      setState(() {});
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String create = Createjson().createjsonfordaywisecall(
          widget.userid, widget.date, page, limit, searchquery);

      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.get_date_wise_call_schedule,
          NetworkUtility.get_date_wise_call_schedule_api,
          create,
          context);

      if (list != null) {
        if (showprogress) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        List<Daywisescheculeresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            listofschedule = response[0].data!;
            searchlistofschedule = response[0].data!;
            if (listofschedule.isEmpty) {
              SnackBarDesign(
                  "No call schedule",
                  context,
                  Colorfile().errormessagebcColor,
                  Colorfile().errormessagetxColor);
              nodata = true;
            } else {
              nodata = false;
            }
            setState(() {});
            break;
          case "false":
            nodata = true;
            setState(() {});
            SnackBarDesign(
                "No call schedule",
                context,
                Colorfile().errormessagebcColor,
                Colorfile().errormessagetxColor);
            break;
        }
      } else {
        if (showprogress) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        nodata = true;
        setState(() {});
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  loadmore() async {
    if (_hashnextpage && !_isFirstloading && !isloadingmore) {
      setState(() {
        isloadingmore = true;
      });

      page += 10;

      try {
        String create = Createjson().createjsonfordaywisecall(
            widget.userid,
            widget.date,
            page,
            limit,
            _searchController.text.isNotEmpty ? _searchController.text : "");

        List<Object?>? list = await NetworkResponse().postMethod(
            NetworkUtility.get_date_wise_call_schedule,
            NetworkUtility.get_date_wise_call_schedule_api,
            create,
            context);

        if (list != null) {
          List<Daywisescheculeresponse> response = List.from(list);
          String status = response[0].status!;
          switch (status) {
            case "true":
              List<DaywisescheculeDatum> newsList1 = response[0].data!;
              if (newsList1.isEmpty) {
                _hashnextpage = false;
              } else {
                listofschedule.addAll(newsList1);
                searchlistofschedule.addAll(newsList1);
              }
              break;
            case "false":
              _hashnextpage = false;
              break;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print(e.toString());
      } finally {
        // Make sure loading indicator stops
        setState(() {
          isloadingmore = false;
        });
      }
    }
  }

  loadmore1() async {
    if (_hashnextpage == true &&
        _isFirstloading == false &&
        isloadingmore == false) {
      setState(() {
        isloadingmore = true;
      });
      page = page + 10;
      try {
        String create = Createjson().createjsonfordaywisecall(
            widget.userid,
            widget.date,
            page,
            limit,
            _searchController.text.isNotEmpty ? _searchController.text : "");

        List<Object?>? list = await NetworkResponse().postMethod(
            NetworkUtility.get_date_wise_call_schedule,
            NetworkUtility.get_date_wise_call_schedule_api,
            create,
            context);

        if (list != null) {
          List<Daywisescheculeresponse> response = List.from(list!);
          String status = response[0].status!;
          switch (status) {
            case "true":
              List<DaywisescheculeDatum> newsList1 = response[0].data!;
              if (newsList1.isEmpty) {
                _hashnextpage = false;
              } else {
                listofschedule.addAll(newsList1);
                searchlistofschedule.addAll(newsList1);
              }

              setState(() {});
              break;
            case "false":
              _hashnextpage = false;
              setState(() {});
              break;
          }
          isloadingmore = false;
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Something went wrong",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
          //  SomethingWentWrongSnackBarDesign(context);
        }
      } catch (e) {
        print(e.toString());
      } finally {
        // Make sure loading indicator stops
        setState(() {
          isloadingmore = false;
        });
      }
    } else {
      setState(() {
        isloadingmore = false;
      });
    }
  }

  void _filterschedule() {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty && query.length > 3) {
      page = 0;
      _isFirstloading = false;
      _hashnextpage = true;
      isloadingmore = false;

      Networkcallforschedulecalldetails(true, page, query);
    } else {
      page = 0;
      _isFirstloading = false;
      _hashnextpage = true;
      isloadingmore = false;

      Networkcallforschedulecalldetails(false, page, "");
    }
  }

  String convertTo12HourFormat(String time24hr) {
    // Parse the time string
    DateTime dateTime = DateFormat("HH:mm:ss").parse(time24hr);

    // Format it to 12-hour format
    return DateFormat("hh:mm a").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 80.0,
          title: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'Scheduled Call',
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 1), () {
              page = 0;
              _isFirstloading = false;
              _hashnextpage = true;
              isloadingmore = false;

              Networkcallforschedulecalldetails(false, page, "");
            });
          },
          child: Container(
            color: Colors.white,
            child: isloading
                ? const Center(child: CircularProgressIndicator())
                : nodata
                    ? Center(
                        child: Lottie.asset(
                        'assets/nodata.json',
                      ))
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText:
                                    'Search using atleast 3 characters of name,number,description',
                                hintStyle: TextStyle(
                                  color: Colors.grey[
                                      500], // Light hint color for minimal design
                                  fontSize: 16.0,
                                ),
                                filled: true,
                                fillColor:
                                    Colors.white, // Clean white background
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // More rounded for a modern look
                                  borderSide: BorderSide
                                      .none, // No border for minimalism
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[600], // Subtle icon color
                                  size: 20.0, // Slightly smaller icon
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14.0,
                                    horizontal:
                                        20.0), // More padding for a balanced look
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      30.0), // Consistent rounded border
                                  borderSide: BorderSide(
                                      color: Colors.grey[
                                          300]!), // Light grey border for clarity
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 2.0), // Accent color when focused
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16.0, // Consistent font size
                                color: Colors.black, // Simple black text color
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: _controller,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: listofschedule.length,
                              itemBuilder: (context, index) {
                                int lastdurationcall = 0;
                                if (listofschedule[index].lastCallDuration !=
                                        null &&
                                    listofschedule[index].lastCallDuration !=
                                        "") {
                                  String timeString = listofschedule[index]
                                      .lastCallDuration
                                      .toString();
                                  List<String> parts = timeString.split(" ");

                                  String number = parts[0]; // "45"
                                  lastdurationcall = int.parse(number);
                                }
                                String calltime = convertTo12HourFormat(
                                    listofschedule[index].scheduleCallTime);
                                return Card(
                                    elevation: 0, // No shadow for flat design
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Softer corners
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical:
                                                5), // Smaller padding to reduce height
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .white, // Flat white background
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[300]!,
                                                width:
                                                    0.5), // Subtle bottom border
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(
                                                      5.0), // Adjusted padding for avatar
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    radius:
                                                        20, // Slightly smaller avatar for compact design
                                                    child: FaIcon(
                                                      FontAwesomeIcons.bell,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              'Name  : ',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                            Text(
                                                              listofschedule[index]
                                                                          .name ==
                                                                      null
                                                                  ? ""
                                                                  : listofschedule[
                                                                          index]
                                                                      .name,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black, // You can customize the color
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              'Number  : ',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                            Text(
                                                                listofschedule[index]
                                                                            .number ==
                                                                        null
                                                                    ? ""
                                                                    : listofschedule[
                                                                            index]
                                                                        .number!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black, // You can customize the color
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                'Schedule Date : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                              Text(
                                                                  '${DateFormat('dd-MM-yyyy').format(listofschedule[index].scheduleCallDate!)}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black, // You can customize the color
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                'Schedule Time : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                              Text(calltime,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black, // You can customize the color
                                                                  )),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                'Description : ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300),
                                                              ),
                                                              Text(
                                                                  listofschedule[index]
                                                                              .scheduleCallDescription ==
                                                                          null
                                                                      ? ""
                                                                      : '${listofschedule[index].scheduleCallDescription}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black, // You can customize the color
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                (listofschedule[index].number ==
                                                            null ||
                                                        listofschedule[index]
                                                                .number ==
                                                            "")
                                                    ? Container()
                                                    : IconButton(
                                                        onPressed: () {
                                                          _makingPhoneCall(
                                                              listofschedule[
                                                                      index]
                                                                  .number!);
                                                        },
                                                        icon: const Icon(
                                                          Icons.call,
                                                          color: Colors.green,
                                                          size: 20,
                                                        )),
                                                (listofschedule[index].number ==
                                                            null ||
                                                        listofschedule[index]
                                                                .number ==
                                                            "")
                                                    ? Container()
                                                    : IconButton(
                                                        onPressed: () {
                                                          _launchWhatsApp(
                                                              listofschedule[
                                                                      index]
                                                                  .number!,
                                                              DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(listofschedule[
                                                                          index]
                                                                      .scheduleCallDate!),
                                                              calltime);
                                                        },
                                                        // icon: const Icon(
                                                        //   Icons
                                                        //       .mobile_screen_share,
                                                        //   color: Colors.blue,
                                                        //   size: 20,
                                                        // )
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .whatsapp,
                                                          color: Colors
                                                              .green.shade800,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            (listofschedule[index].number ==
                                                        null ||
                                                    listofschedule[index]
                                                            .number ==
                                                        "")
                                                ? Container()
                                                : Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 35,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      listofschedule[index]
                                                                      .lastCallDuration !=
                                                                  null &&
                                                              listofschedule[
                                                                          index]
                                                                      .lastCallDuration !=
                                                                  "" &&
                                                              lastdurationcall >=
                                                                  30
                                                          ? ElevatedButton(
                                                              onPressed: () {},
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green, // Set background color to red
                                                                foregroundColor:
                                                                    Colors
                                                                        .white, // Set text color to white
                                                              ),
                                                              child: Text(
                                                                'Call Done',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ))
                                                          : ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                                    return ScheduleCallDialog(
                                                                        "schedulecalldetailspage",
                                                                        listofschedule[index]
                                                                            .name!,
                                                                        listofschedule[index]
                                                                            .number!,
                                                                        true,
                                                                        false);
                                                                  },
                                                                ));
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .red, // Set background color to red
                                                                foregroundColor:
                                                                    Colors
                                                                        .white, // Set text color to white
                                                              ),
                                                              child: Text(
                                                                'Reschedule Call',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              )),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          isloadingmore
                              ? const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Container(),
                          const SizedBox(
                            height: 5,
                          ),
                          _hashnextpage
                              ? Container()
                              : const Text(
                                  'You have fetched all schedule call details',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10),
                                ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
          ),
        ));
  }

  _makingPhoneCall(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWhatsApp(String phoneNumber, date, time) async {
    final Uri whatsappUrl = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent("You have scheduled a call with me for $date at $time. Please ensure to be available.")}');

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
