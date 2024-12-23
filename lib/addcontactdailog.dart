import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/addcontactresponse.dart';
import 'customedesign/apputility.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/snackbardesign.dart';

class AddContactDialog extends StatefulWidget {
  final String mobilenumber;
  AddContactDialog(this.mobilenumber);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _mobilenumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Validation flags and error messages
  bool validatefName = true;
  bool validatelName = true;
  bool validatenumber = true;
  String fNameError = '';
  String lNameError = '';
  String numberError = '';

  @override
  void initState() {
    super.initState();
    _mobilenumberController.text = widget.mobilenumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CupertinoAlertDialog(
        title: const Text(
          'Add New Contact',
          style: TextStyle(fontWeight: FontWeight.w400), // Make the title bold
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _firstnameWidget(),
              const SizedBox(height: 10),
              _lastnameWidget(),
              const SizedBox(height: 10),
              _numberWidget(),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              // Close the dialog without saving
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red), // Change text color to red
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              setState(() {
                // Simple validation logic
                validatefName = _firstnameController.text.isNotEmpty;
                validatelName = _lastnameController.text.isNotEmpty;
                validatenumber = _mobilenumberController.text.isNotEmpty;

                // Set error messages
                fNameError = validatefName ? '' : 'First Name cannot be empty';
                lNameError = validatelName ? '' : 'Last Name cannot be empty';
                numberError =
                    validatenumber ? '' : 'Mobile Number cannot be empty';
              });

              // If all fields are valid, close dialog and save the contact
              if (validatefName && validatelName && validatenumber) {
                Networkcallforaddcontact(context);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.green), // Change text color to red
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstnameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40, // Increase height as needed
          child: CupertinoTextField(
            controller: _firstnameController,
            placeholder: 'First Name *',
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colorfile().backgroundColor3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            onChanged: (value) {
              setState(() {
                validatefName = value.isNotEmpty;
                fNameError = validatefName ? '' : 'First Name cannot be empty';
              });
            },
            placeholderStyle: TextStyle(
              fontSize: 12, // Adjust the font size for the placeholder
              color: Colors.grey, // Customize the placeholder color if needed
            ),
            style: TextStyle(
              fontSize: 14, // Adjust the font size for the input text
            ),
          ),
        ),
        if (fNameError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              fNameError,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _lastnameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40, // Increase height as needed
          child: CupertinoTextField(
            controller: _lastnameController,
            placeholder: 'Last Name *',
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colorfile().backgroundColor3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            onChanged: (value) {
              setState(() {
                validatelName = value.isNotEmpty;
                lNameError = validatelName ? '' : 'Last Name cannot be empty';
              });
            },
            placeholderStyle: TextStyle(
              fontSize: 12, // Adjust the font size for the placeholder
              color: Colors.grey, // Customize the placeholder color if needed
            ),
            style: TextStyle(
              fontSize: 14, // Adjust the font size for the input text
            ),
          ),
        ),
        if (lNameError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              lNameError,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _numberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40, // Increase height as needed
          child: CupertinoTextField(
            controller: _mobilenumberController,
            placeholder: 'Mobile Number *',
            readOnly: true, // Keep the readOnly property as needed
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(color: Colorfile().backgroundColor3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            onChanged: (value) {
              setState(() {
                validatenumber = value.isNotEmpty;
                numberError =
                    validatenumber ? '' : 'Mobile Number cannot be empty';
              });
            },
            placeholderStyle: TextStyle(
              fontSize: 12, // Adjust the font size for the placeholder
              color: Colors.grey, // Customize the placeholder color if needed
            ),
            style: TextStyle(
              fontSize: 14, // Adjust the font size for the input text
            ),
          ),
        ),
        if (numberError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              numberError,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
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
      List<Addcontactresponse> response = List.from(list);
      String status = response[0].status!;
      switch (status) {
        case "true":
          SnackBarDesign(
              response[0].message!,
              context,
              Colorfile().sucessmessagebcColor,
              Colorfile().sucessmessagetxColor);
          _addContact(
              _firstnameController.text + ' ' + _lastnameController.text,
              _mobilenumberController.text,
              context);
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

  void _addContact(
      String name, String mobilenumber, BuildContext context) async {
    final Contact contact = Contact(
      givenName: name,
      phones: [Item(label: 'mobile', value: mobilenumber)],
    );

    try {
      await ContactsService.addContact(contact);
      SnackBarDesign("Add to contact successfully!", context,
          Colorfile().sucessmessagebcColor, Colorfile().sucessmessagetxColor);
    } catch (e) {
      SnackBarDesign("Failed to add contact: $e", context,
          Colorfile().errormessagebcColor, Colorfile().errormessagetxColor);
    }
  }
}
