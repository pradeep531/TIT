import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/getcallsummaryresponse.dart';
import 'callsummarypage.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/snackbardesign.dart';

List<SummaryDatum> data = [];
bool nodata = true;

class Calldetailsforadmin extends StatefulWidget {
  String userId, calltype, contactname, callernumber;
  Calldetailsforadmin(
      this.userId, this.calltype, this.contactname, this.callernumber);
  CalldetailsforadminState createState() => CalldetailsforadminState();
}

class CalldetailsforadminState extends State<Calldetailsforadmin> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforgetlastcallsummary(widget.callernumber);
    _connectivityService.connectionStatus.listen((isConnected) {
      setState(() {
        _isConnected = isConnected; // Update connection status
      });
      if (isConnected) {
        //showinternetstatus('You are online!.', context);
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

  Future<void> Networkcallforgetlastcallsummary(String callernumber) async {
    String createjson = Createjson.createjsonforgetcallsummary(
      callernumber,
      "all",
      widget.userId,
    );

    List<Object?>? list = await NetworkResponse().postMethod1(
      NetworkUtility.get_call_all_summary,
      NetworkUtility.get_call_all_summary_api,
      createjson,
    );
    if (list != null) {
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
          break;
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // Set AppBar background to white
          title: Text(
            'Details for ${widget.contactname}',
            style:
                TextStyle(color: Colors.black), // Set title text color to black
          ),
          iconTheme:
              IconThemeData(color: Colors.black), // Set icon color to black
        ),
        body: nodata
            ? Center(
                child: Text('No call details found'),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1), () {
                    Networkcallforgetlastcallsummary(widget.callernumber);
                  });
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return calllogcard(index);
                        },
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget calllogcard(int index) {
    DateTime now = DateTime.now();

    Duration duration = now.difference(data[index].createdOn!).abs();

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    String timeAgo;
    if (days > 0) {
      timeAgo = (days == 1 ? '$days day ago' : '$days days ago');
    } else if (hours > 0) {
      timeAgo = ('$hours hours $minutes minutes ago');
    } else {
      timeAgo = ('$minutes minutes ago');
    }
    return Card(
      // Removed margins for a more compact design
      elevation: 0, // No shadow for flat design
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Softer corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 0), // Smaller padding to reduce height
          decoration: BoxDecoration(
            color: Colors.white, // Flat white background
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey[300]!, width: 0.5), // Subtle bottom border
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(8.0), // Adjusted padding for avatar
                child: CircleAvatar(
                  backgroundColor: _getAvatarColor(widget.calltype),
                  radius: 20, // Slightly smaller avatar for compact design
                  child: Text(
                    data[index].callerName != null &&
                            data[index].callerName!.isNotEmpty
                        ? data[index].callerName![0].toUpperCase()
                        : 'U', // Placeholder for unknown
                    style: TextStyle(
                        color: Colors.white, fontSize: 16), // Simpler style
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data[index].callerName != null &&
                              data[index].callerName!.isNotEmpty
                          ? data[index].callerName!
                          : data[index].callerName ?? 'Unknown Number',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w500, // Slightly lighter font weight
                        fontSize: 14, // Smaller font size for compactness
                        color: Colors.black, // Pure black text
                      ),
                      maxLines: 1, // Single line for the name/number
                      overflow:
                          TextOverflow.ellipsis, // Handle long names/numbers
                    ),
                    SizedBox(height: 2), // Small space between lines
                    Row(
                      children: [
                        Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(data[index].createdOn!)} ',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       timeAgo,
                    //       style: TextStyle(fontSize: 12, color: Colors.black54),
                    //     ),

                    //   ],
                    // ),
                    Row(
                      children: [
                        Text(
                          'Duration: ${data[index].callDuration!}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          _getCallIcon(widget.calltype),
                          color: _getCallColor(widget.calltype),
                          size: 16.0, // Smaller icon size for subtle design
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 0.0), // Padding for the trailing icon
                child: IconButton(
                  icon: Icon(Icons.info_outline,
                      color: Colors.blue), // Info button in blue color
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CallSummaryPage(
                            data[index].callerNumber, widget.userId);
                      },
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCallIcon(String callType) {
    switch (callType) {
      case "incoming":
        return Icons.call_received;
      case "outgoing":
        return Icons.call_made;
      case "missed":
        return Icons.call_missed;
      default:
        return Icons.phone;
    }
  }

  Color _getCallColor(String callType) {
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

  Color _getAvatarColor(String callType) {
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
