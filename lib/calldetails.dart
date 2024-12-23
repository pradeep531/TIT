import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:quickensolcrm/Network/response/addcontactresponse.dart';
import 'package:quickensolcrm/addcontactdailog.dart';
import 'package:quickensolcrm/customedesign/apputility.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/calllogdetailsresponse.dart';
import 'Network/response/getcallsummaryresponse.dart';
import 'calllogcard.dart';
import 'callsummarypage.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/snackbardesign.dart';

class CallLogDetailsPage extends StatelessWidget {
  final String contactName;
  final List<CallLogEntry> callLogs;

  CallLogDetailsPage({
    required this.contactName,
    required this.callLogs,
    required,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set AppBar background to white
        title: Text(
          'Details for ${(contactName == "" || contactName.isEmpty) ? 'Unknown' : contactName}',
          style:
              TextStyle(color: Colors.black), // Set title text color to black
        ),
        iconTheme:
            IconThemeData(color: Colors.black), // Set icon color to black
        actions: [
          if (contactName == "" || contactName.isEmpty)
            IconButton(
              icon:
                  Icon(Icons.add, color: Colors.blue), // Set icon color to blue
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddContactDialog(callLogs.first.number!);
                  },
                );
              },
            ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set body background to white
        child: ListView.builder(
          itemCount: callLogs.length,
          itemBuilder: (context, index) {
            final entry = callLogs[index];
            return CallLogCard(
              entry,
              onInfoTap: () {
                //   Networkcallforgetlastcallsummary(contactName);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return CallSummaryPage(
                      entry.number!,
                      AppUtility.userId,
                    );
                  },
                ));
              },
              onCallTap: () {},
              showcallbutton: false,
            ); // Ensure CallLogCard has a clean design
          },
        ),
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context, String mobilenumber) {
    _mobilenumberController.text = mobilenumber;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // elevation: 0.0,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sizeBoxWidget(),
                  _firstnameWidget(),
                  _sizeBoxWidget(),
                  _lastnameWidget(),
                  _sizeBoxWidget(),
                  _numberWidget(),
                  _sizeBoxWidget(),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        Networkcallforaddcontact(context);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colorfile().sucessmessagebcColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Add TO Contact',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _mobilenumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _sizeBoxWidget() {
    return SizedBox(
      height: 10,
    );
  }

  _firstnameWidget() {
    return TextFormField(
      controller: _firstnameController,
      decoration: InputDecoration(
        labelText: 'First Name *',
        // border: InputBorder.none, // Remove border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide:
              BorderSide(color: Colorfile().backgroundColor), // White border
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter First Name';
        }
        return null;
      },
    );
  }

  _lastnameWidget() {
    return TextFormField(
      controller: _lastnameController,
      decoration: InputDecoration(
        labelText: 'Last Name *',
        // border: InputBorder.none, // Remove border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide:
              BorderSide(color: Colorfile().backgroundColor), // White border
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Last Name';
        }
        return null;
      },
    );
  }

  _numberWidget() {
    return TextFormField(
      controller: _mobilenumberController,
      readOnly: true,
      enabled: true,
      decoration: InputDecoration(
        labelText: 'Mobile Number *',
        // border: InputBorder.none, // Remove border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide:
              BorderSide(color: Colorfile().backgroundColor), // White border
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: Colorfile().backgroundColor),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Enter Mobile Number';
        }
        return null;
      },
    );
  }

  void _showAddContactDialog(BuildContext context, String number) {
    _mobilenumberController.text = number;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Unknown Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _firstnameWidget(),
            _sizeBoxWidget(),
            _lastnameWidget(),
            _sizeBoxWidget(),
            _numberWidget(),
            _sizeBoxWidget()
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final name = _firstnameController.text.trim();
              if (name.isNotEmpty) {
                Networkcallforaddcontact(context);
              } else {
                // Show an error message or handle the empty name case
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a contact name.'),
                  ),
                );
              }
            },
            child: Text('Add'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addContact(
      String name, String mobilenumber, BuildContext context) async {
    //   final Iterable<Contact> contacts = await ContactsService.getContacts();
    final Contact contact = Contact(
      givenName: name,
      phones: [Item(label: 'mobile', value: mobilenumber)],
    );

    try {
      await ContactsService.addContact(contact);

      SnackBarDesign("Add to contact successfully!", context,
          Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
    } catch (e) {
      SnackBarDesign("Failed to add contact: $e", context,
          Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
    }
  }

  Future<void> Networkcallforaddcontact(BuildContext context) async {
    String createjson = Createjson.createjsonforaddcontact(
        _firstnameController.text,
        _lastnameController.text,
        _mobilenumberController.text,
        AppUtility.userId,
        context);

    List<Object?>? list = await NetworkResponse().postMethod(
        NetworkUtility.add_new_contact,
        NetworkUtility.add_new_contact_api,
        createjson,
        context);
    if (list != null) {
      List<Addcontactresponse> response = List.from(list!);
      String status = response[0].status!;
      switch (status) {
        case "true":
          SnackBarDesign(response[0].message!, context,
              Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
          // Navigator.pop(context);
          _addContact(_firstnameController.text + _lastnameController.text,
              _mobilenumberController.text, context);
          Navigator.pop(context);

          break;
        case "false":
          SnackBarDesign(response[0].message!, context,
              Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
          break;
      }
    } else {
      SomethingWentWrongSnackBarDesign(context);
    }
  }
}
