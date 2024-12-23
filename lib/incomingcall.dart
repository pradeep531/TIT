import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quickensolcrm/Network/response/calllogresponse.dart';
import 'package:quickensolcrm/calldetailsforadmin.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/snackbardesign.dart';

class Incomingcall extends StatefulWidget {
  String userId, calltype;
  Incomingcall(this.userId, this.calltype);
  @override
  _IncomingcallState createState() => _IncomingcallState();
}

class _IncomingcallState extends State<Incomingcall> {
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool nodata = true;
  List<CalllogDatum> filteredContacts = [];
  List<CalllogDatum> contacts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Networkcallforgetcalllog();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
  }

  Future<void> Networkcallforgetcalllog() async {
    try {
      String createjson = Createjson.createjsonforgetcallhistory(
          widget.calltype, widget.userId);
      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.get_user_call_logs,
          NetworkUtility.get_user_call_logs_api,
          createjson,
          context);
      if (list != null) {
        List<Calllogresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            List<CalllogDatum> filteredContacts1 = response[0].data!;
            // filteredContacts = filteredContacts1.toSet().toList();
            List<CalllogDatum> filteredContacts2 =
                removeDuplicateCallers(filteredContacts1);
            if (filteredContacts.isEmpty) {
              nodata = true;
              isLoading = false;
            } else {
              _searchController.addListener(_filterContacts);
              nodata = false;
              isLoading = false;
            }
            setState(() {});
            break;
          case "false":
            nodata = true;
            isLoading = false;
            setState(() {});
            break;
        }
      } else {
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      SomethingWentWrongSnackBarDesign(context);
    }
  }

  List<CalllogDatum> removeDuplicateCallers(List<CalllogDatum> callLogs) {
    // A map to keep track of seen caller names
    final Map<String, CalllogDatum> uniqueCallers = {}; // Ensure correct types

    // Loop through each call log entry
    for (var log in callLogs) {
      // Check if the caller name has already been seen
      if (!uniqueCallers.containsKey(log.callerName)) {
        // If not, add it to the map
        uniqueCallers[log.callerName] = log;
        filteredContacts.add(log);
        contacts.add(log);
      }
    }

    // Return a list of unique call logs
    return uniqueCallers.values.toList();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.callerName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.blue,
          )) // Show a loader while data is being fetched
        : nodata
            ? Center(
                child: Lottie.asset(
                'assets/nodata.json',
              ))
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1), () {
                    Networkcallforgetcalllog();
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Contacts',
                          hintStyle: TextStyle(
                            color: Colors.grey[
                                500], // Light hint color for minimal design
                            fontSize: 16.0,
                          ),
                          filled: true,
                          fillColor: Colors.white, // Clean white background
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // More rounded for a modern look
                            borderSide:
                                BorderSide.none, // No border for minimalism
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600], // Subtle icon color
                            size: 20.0, // Slightly smaller icon
                          ),
                          contentPadding: EdgeInsets.symmetric(
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
                            borderSide: BorderSide(
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
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          return calllogcard(index);
                        },
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget calllogcard(int index) {
    DateTime now = DateTime.now();

    Duration duration =
        now.difference(filteredContacts[index].createdOn!).abs();

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
                    filteredContacts[index].callerName != null &&
                            filteredContacts[index].callerName!.isNotEmpty
                        ? filteredContacts[index].callerName![0].toUpperCase()
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
                      filteredContacts[index].callerName != null &&
                              filteredContacts[index].callerName!.isNotEmpty
                          ? filteredContacts[index].callerName!
                          : filteredContacts[index].callerName ??
                              'Unknown Number',
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
                          'Date: ${DateFormat('dd-MM-yyyy').format(filteredContacts[index].createdOn!)} ',
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
                          'Duration: ${filteredContacts[index].callDuration!}',
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
                        return Calldetailsforadmin(
                            widget.userId,
                            widget.calltype,
                            filteredContacts[index].callerName,
                            filteredContacts[index].callerNumber);
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
