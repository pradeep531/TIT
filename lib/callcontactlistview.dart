import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'calldetails.dart';
import 'calllogcard.dart';

class CallContactListView extends StatefulWidget {
  final Map<String, List<CallLogEntry>> contactCallLogs;
  final CallType callType;

  CallContactListView({
    required this.contactCallLogs,
    required this.callType,
  });

  @override
  _CallContactListViewState createState() => _CallContactListViewState();
}

class _CallContactListViewState extends State<CallContactListView> {
  late List<String> contacts = [];
  late List<String> filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  // Initialize contacts based on call type
  Future<void> _initializeContacts() async {
    // Simulating data fetching or processing
    await Future.delayed(Duration(seconds: 1)); // Mock delay for fetching data

    setState(() {
      contacts = _getFilteredContacts(); // Initialize contacts
      filteredContacts = contacts; // Set filtered contacts
      isLoading = false; // Data is loaded
    });
  }

  // Filter contacts based on call type
  List<String> _getFilteredContacts() {
    return widget.contactCallLogs.keys
        .where((contact) => widget.contactCallLogs[contact]!
            .any((entry) => entry.callType == widget.callType))
        .toList();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.toLowerCase().contains(query);
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
        : Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Contacts',
                    hintStyle: TextStyle(
                      color: Colors
                          .grey[500], // Light hint color for minimal design
                      fontSize: 16.0,
                    ),
                    filled: true,
                    fillColor: Colors.white, // Clean white background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // More rounded for a modern look
                      borderSide: BorderSide.none, // No border for minimalism
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600], // Subtle icon color
                      size: 20.0, // Slightly smaller icon
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 20.0), // More padding for a balanced look
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          30.0), // Consistent rounded border
                      borderSide: BorderSide(
                          color: Colors
                              .grey[300]!), // Light grey border for clarity
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
                child: filteredContacts.isEmpty
                    ? Center(
                        child: Text(
                            'No ${widget.callType.toString().split('.').last} calls found'),
                      )
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          final entries = widget.contactCallLogs[contact]!
                              .where(
                                  (entry) => entry.callType == widget.callType)
                              .toList();

                          if (entries.isNotEmpty) {
                            final String number =
                                entries.first.number ?? 'Unknown Number';
                            return ListTile(
                              title: CallLogCard(
                                entries.first,
                                onInfoTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallLogDetailsPage(
                                        contactName: contact.isNotEmpty
                                            ? contact
                                            : "", // Use the contact name or the number
                                        callLogs: entries
                                            .where((entry) =>
                                                entry.number == number)
                                            .toList(), // Filter logs by the specific number
                                      ),
                                    ),
                                  );
                                },
                                onCallTap: () {
                                  _makingPhoneCall(number);
                                },
                                showcallbutton: true,
                              ),
                              // onTap: () {
                              //   // Navigator.push(
                              //   //   context,
                              //   //   MaterialPageRoute(
                              //   //     builder: (context) => CallLogDetailsPage(
                              //   //       contactName: contact.isNotEmpty
                              //   //           ? contact
                              //   //           : "", // Use contact name or number
                              //   //       callLogs: entries
                              //   //           .where(
                              //   //               (entry) => entry.number == number)
                              //   //           .toList(), // Filter by the same number
                              //   //     ),
                              //   //   ),
                              //   // );
                              //   _makingPhoneCall(number);
                              // },
                            );
                          } else {
                            return Container(); // Return an empty container if no entries
                          }
                        },
                      ),
              ),
            ],
          );
  }

  _makingPhoneCall(String number) async {
    var url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
