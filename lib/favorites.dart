import 'package:flutter/material.dart';
import 'package:quickensolcrm/Network/response/userlistresponse.dart';
import 'package:quickensolcrm/callhistorypageforadmin.dart';
import 'package:quickensolcrm/customedesign/apputility.dart';
import 'package:quickensolcrm/customedesign/progressdialog.dart';
import 'package:quickensolcrm/customedesign/sharedpref.dart';
import 'package:quickensolcrm/login.dart';
import 'package:quickensolcrm/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/snackbardesign.dart';

List<UserlistDatum> userlist = [];
bool nodata = true;

class FavoritesContactsPage extends StatefulWidget {
  State createState() => FavoritesContactsPageState();
}

class FavoritesContactsPageState extends State<FavoritesContactsPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();
    Networkcallforverifymobilenumber(false, context);
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

  Future<void> Networkcallforverifymobilenumber(
      bool showprogress, BuildContext context) async {
    try {
      if (showprogress) {
        ProgressDialog.showProgressDialog(context, " title");
      }
      String createjson = Createjson.createjsonforgetuserlist("1");
      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.get_all_user_list,
          NetworkUtility.get_all_user_list_api,
          createjson,
          context);
      if (list != null) {
        if (showprogress) {
          Navigator.pop(context);
        }
        List<Userlistresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            userlist = response[0].data!;
            if (userlist.isEmpty) {
              nodata = true;
            } else {
              nodata = false;
            }
            setState(() {});
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
        if (showprogress) {
          Navigator.pop(context);
        }
        SomethingWentWrongSnackBarDesign(context);
      }
    } catch (e) {
      SomethingWentWrongSnackBarDesign(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600; // Adjust threshold as needed

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites Contacts'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.blueAccent),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.blueAccent),
            onPressed: () async {
              AppUtility.userId =
                  (await SharedPreference().getValue("istrackingallowed"))!;
              _showtrackingDialog(
                  context, AppUtility.userId == "0" ? false : true);
            },
          ),
        ],
      ),
      backgroundColor:
          Colors.grey[100], // Light grey background for minimal look
      body: nodata
          ? Container(child: Center(child: Text("No Contact Found")))
          : RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1), () {
                  Networkcallforverifymobilenumber(false, context);
                });
              },
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      isWideScreen ? 3 : 2, // More columns on wide screens
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8, // Adjust the aspect ratio for blocks
                ),
                itemCount: userlist.length,
                itemBuilder: (context, index) {
                  return ContactCard(
                      userlist[index].fullName,
                      userlist[index].phonenumber1,
                      userlist[index].id.toString());
                },
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

  void _showtrackingDialog(BuildContext context, bool isTracking) {
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
                          "Track My Call",
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
                        ListTile(
                          title: Text(
                            "Track My Call"!,
                          ),
                          trailing: isTracking == true
                              ? Icon(
                                  Icons.toggle_on,
                                  color: Colors.blueAccent,
                                  size: 50,
                                )
                              : Icon(
                                  Icons.toggle_off,
                                  size: 50,
                                ),
                          onTap: () {
                            setState(() {
                              isTracking = !isTracking;
                            });
                            if (isTracking) {
                              SharedPreference().savetrakingvalue("1");
                            } else {
                              SharedPreference().savetrakingvalue("0");
                            }
                            Navigator.pop(context);
                          },
                        )
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

class ContactCard extends StatelessWidget {
  final String Name, MobileNumber, userId;

  ContactCard(this.Name, this.MobileNumber, this.userId);

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600; // Adjust threshold as needed

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Callhistorypageforadmin(userId, Name);
          },
        ));
      },
      child: Card(
        elevation: 1.0, // Reduced elevation for a flatter appearance
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Slightly less rounded corners
        ),
        color: Colors.white,
        child: Padding(
          padding:
              EdgeInsets.all(isWideScreen ? 16.0 : 10.0), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isWideScreen
                    ? 40
                    : 30, // Adjust avatar size for screen size
                backgroundColor: Colors.blue, // Softer blue
                child: Text(
                  Name[0].toUpperCase(), // Ensuring uppercase initials
                  style: TextStyle(
                    fontSize: isWideScreen ? 28 : 22, // Adjust font size
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: isWideScreen ? 12 : 6), // Adjust spacing
              Text(
                Name,
                style: TextStyle(
                  fontSize: isWideScreen ? 16 : 14, // Adjust font size
                  fontWeight:
                      FontWeight.normal, // Normal weight for a clean look
                ),
                textAlign: TextAlign.center, // Center text for better layout
              ),
              SizedBox(height: isWideScreen ? 8 : 4), // Adjust spacing
              Text(
                MobileNumber,
                style: TextStyle(
                  fontSize: isWideScreen ? 14 : 12, // Adjust font size
                  color: Colors.grey[600], // Slightly darker grey for contrast
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model for Contact
class Contact {
  final String name;
  final String phoneNumber;

  Contact({required this.name, required this.phoneNumber});
}
