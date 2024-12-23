import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:quickensolcrm/customedesign/colorfile.dart';
import 'package:quickensolcrm/customedesign/progressdialog.dart';
import 'package:quickensolcrm/favorites.dart';

import 'calltrackerapp.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/apputility.dart';
import 'customedesign/sharedpref.dart';
import 'customedesign/snackbardesign.dart';

class LoginPage extends StatefulWidget {
  String number, frompage;
  String id, isloginfirst, password, userType, companyId, name;
  LoginPage(
    this.number,
    this.frompage,
    this.id,
    this.isloginfirst,
    this.password,
    this.userType,
    this.companyId,
    this.name,
  );

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isNextClicked = true;
  bool _isLoading = false; // State to manage loading indicator
  String _enteredMobileNumber = ''; // Variable to store the mobile number
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mobileController.text = widget.number;
    _enteredMobileNumber = widget.number;
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

  void _showFeedback(String message, {bool error = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: error ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  savevaluetosharedpref(
      String id,
      String isloginfirst,
      String password,
      String userType,
      String CompanyId,
      String Name,
      String selectedMobileNumber) {
    try {
      SharedPreference().savevalueonlogin(
          id, isloginfirst, password, userType, CompanyId, Name, context);
      if (userType == "1") {
        SharedPreference().savetrakingvalue("0");
      } else {
        SharedPreference().savetrakingvalue("1");
      }
    } catch (e) {}
  }

  void _login(BuildContext context) {
    String mobileNumber = _mobileController.text;
    final password = _passwordController.text;

    if (password.isNotEmpty) {
      if (password == widget.password) {
        _showFeedback('Login Successful for $mobileNumber');
        savevaluetosharedpref(widget.id, widget.isloginfirst, widget.password,
            widget.userType, widget.companyId, widget.name, widget.number);
        if (AppUtility.UserType == "2") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return CallTrackerApp();
            },
          ), (route) => false);
        } else if (AppUtility.UserType == "1") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return FavoritesContactsPage();
            },
          ), (route) => false);
        } else {
          SnackBarDesign("Check user type", context,
              Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
        }
      } else {
        _showFeedback('Incorrect password', error: true);
      }
    } else {
      _showFeedback('Please fill in all fields correctly', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing on keyboard
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Login to continue',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
              SizedBox(height: 200),
              if (!_isNextClicked) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Set the width to 90% of screen width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(
                              0, 3), // Changes the position of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _mobileController,
                      decoration: InputDecoration(
                        hintText: 'Enter your mobile number',
                        hintStyle: TextStyle(
                          color: Color(0xFFC4C4C4), // Hint text color
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Icon(Icons.phone,
                            color: Colors.blueAccent), // Icon added
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 1), // Change border color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2), // Change focus border color
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFC4C4C4), width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true, // Add fill color
                        fillColor:
                            Colors.white, // Background color of the text field
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10), // Padding inside the text field
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
              if (_isNextClicked) ...[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // Minimal vertical padding
                  child: Text(
                    'Mobile Number: $_enteredMobileNumber', // Display the mobile number
                    style: TextStyle(
                      fontSize:
                          18, // Slightly smaller font size for a minimal look
                      fontWeight: FontWeight.w600, // Medium weight for emphasis
                      color: Colors.black54, // Darker text color for contrast
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(
                              0, 3), // Changes the position of the shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      // focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter your password', // Updated hint text
                        hintStyle: TextStyle(
                          color: Color(0xFFC4C4C4), // Hint text color
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.blueAccent), // Added prefix icon
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueAccent, // Change border color
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Colors.blueAccent, // Change focus border color
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFC4C4C4), // Enabled border color
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true, // Add fill color
                        fillColor:
                            Colors.white, // Background color of the text field
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10, // Padding inside the text field
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle password visibility
                            });
                          },
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                ),

                SizedBox(height: 40.0),

                // Login Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Set the width to 90% of screen width
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _login(context),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white))
                          : Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black45,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Centered Back Button
                widget.frompage == "Mobile Number Selection"
                    ? Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container()
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _connectivityService.dispose(); // Clean up the service
    super.dispose();
  }
}
