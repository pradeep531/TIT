import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/getcallsummaryresponse.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/apputility.dart';
import 'customedesign/progressdialog.dart';
import 'customedesign/snackbardesign.dart';

bool nodata = true;
List<SummaryDatum> data = [];

class CallSummaryPage extends StatefulWidget {
  String callernumber, user_id;
  CallSummaryPage(this.callernumber, this.user_id);

  @override
  _CallSummaryPageState createState() => _CallSummaryPageState();
}

class _CallSummaryPageState extends State<CallSummaryPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforgetlastcallsummary(widget.callernumber, true);
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
    // TODO: implement dispose
    super.dispose();
    data.clear();
    nodata = true;
    _connectivityService.dispose();
  }

  Future<void> Networkcallforgetlastcallsummary(
      String callernumber, bool showprogress) async {
    if (showprogress) {
      ProgressDialog.showProgressDialog(context, 'Loading...');
    }
    String createjson = Createjson.createjsonforgetcallsummary(
      callernumber,
      "latest_3",
      widget.user_id,
    );

    List<Object?>? list = await NetworkResponse().postMethod1(
      NetworkUtility.get_call_all_summary,
      NetworkUtility.get_call_all_summary_api,
      createjson,
    );
    if (list != null) {
      if (showprogress) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      List<Getcallsummaryresponse> response = List.from(list!);
      String status = response[0].status!;
      switch (status) {
        case "true":
          data = response[0].data;
          if (data.isEmpty) {
            nodata = true;
          } else {
            nodata = false;
          }
          setState(() {});
          break;
        case "false":
          nodata = true;
          setState(() {});
          break;
      }
    } else {
      if (showprogress) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      nodata = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        title: const Text(
          'Call Summary ',
          style:
              TextStyle(color: Colors.black), // Set title text color to black
        ),
        iconTheme:
            const IconThemeData(color: Colors.black), // Set icon color to black
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            Networkcallforgetlastcallsummary(widget.callernumber, false);
          });
        },
        child: Container(
          color: Colors.white, // Set body background to white
          child: nodata
              ? Center(
                  child: Lottie.asset(
                  'assets/nodata.json',
                ))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return carddesign(index);
                  },
                ),
        ),
      ),
    );
  }

  Widget carddesign(int index) {
    return data[index].callSummary.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              // Removed margins for a more compact design
              elevation: 0, // No shadow for flat design
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Softer corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0), // Smaller padding to reduce height
                    decoration: BoxDecoration(
                      color: Colors.white, // Flat white background
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 0.5), // Subtle bottom border
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Adjusted padding for avatar
                          child: CircleAvatar(
                            backgroundColor:
                                _getAvatarColor(data[index].callSummary),
                            radius:
                                20, // Slightly smaller avatar for compact design
                            child: Text(
                              data[index].callerName != null &&
                                      data[index].callerName.isNotEmpty
                                  ? data[index].callerName![0].toUpperCase()
                                  : 'U', // Placeholder for unknown
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16), // Simpler style
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Date: ${DateFormat('dd-MM-yyyy').format(data[index].createdOn!)}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Summary : ', // Static text part
                                      style: const TextStyle(
                                        fontWeight: FontWeight
                                            .bold, // Bold for the label
                                        fontSize: 14,
                                        color: Colors
                                            .black, // You can customize the color
                                      ),
                                    ),
                                    TextSpan(
                                      text: data[index]
                                          .callSummary, // Dynamic summary data
                                      style: const TextStyle(
                                        fontSize:
                                            14, // Smaller font size for the summary
                                        color: Colors
                                            .black54, // Lighter color for the summary text
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  height: 5), // Small space between lines
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          )
        : Container();
  }

  String formatDuration(int? durationInSeconds) {
    if (durationInSeconds == null) return "0s";
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  Color _getAvatarColor(String? callType) {
    switch (callType) {
      case "incoming":
        return Colors.green;
      case "outgoing":
        return Colors.blueAccent;
      case "missed":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
