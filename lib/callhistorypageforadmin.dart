import 'package:flutter/material.dart';
import 'package:quickensolcrm/incomingcall.dart';
import 'package:quickensolcrm/login.dart';
import 'package:quickensolcrm/schedulecallpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customedesign/ConnectivityService.dart';
import 'customedesign/snackbardesign.dart';

bool nodata = true;

class Callhistorypageforadmin extends StatefulWidget {
  String userId, Name;
  Callhistorypageforadmin(this.userId, this.Name);

  State createState() => CallhistorypageforadminState();
}

class CallhistorypageforadminState extends State<Callhistorypageforadmin> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();
    _connectivityService.connectionStatus.listen((isConnected) {
      setState(() {
        _isConnected = isConnected; // Update connection status
      });
      if (isConnected) {
        // showinternetstatus(
        //   'You are online!.',
        //   context,
        // );
      } else {
        showinternetstatus('No internet connection.', context, error: true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _connectivityService.dispose(); // Clean up the service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Hi ! ${widget.Name}',
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
                icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => Schedulecallpage(widget.userId)),
                  // );
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Schedulecallpage(widget.userId);
                    },
                  ));
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
              Incomingcall(widget.userId, "incoming"),
              Incomingcall(widget.userId, "outgoing"),
              Incomingcall(widget.userId, "missed"),
            ],
          ),
        ),
      ),
    );
  }
}
