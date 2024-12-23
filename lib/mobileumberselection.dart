import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickensolcrm/customedesign/progressdialog.dart';
import 'package:quickensolcrm/login.dart';
import 'package:quickensolcrm/schedulecalldetails.dart';
import 'package:quickensolcrm/splashscreen.dart';

import 'Network/createjson.dart';
import 'Network/networkresponse.dart';
import 'Network/networkutility.dart';
import 'Network/response/verifymobilenumberresponse.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/colorfile.dart';
import 'customedesign/sharedpref.dart';
import 'customedesign/snackbardesign.dart';
import 'permissiondetailsdailog.dart';

String call_log_permission = "0",
    notification_permission = "0",
    contacts_permission = "0",
    system_alert_permission = "0",
    schedule_exact_alarm = "0";

class Mobileumberselection extends StatefulWidget {
  List simNumbers;
  String device_os_version,
      device_id,
      device_manufacture,
      device_modal,
      taget_sdk,
      app_current_version,
      push_token,
      device_os;
  Mobileumberselection(
      this.simNumbers,
      this.device_os_version,
      this.device_id,
      this.device_manufacture,
      this.device_modal,
      this.taget_sdk,
      this.app_current_version,
      this.push_token,
      this.device_os);

  @override
  _MobileumberselectionState createState() => _MobileumberselectionState();
}

class _MobileumberselectionState extends State<Mobileumberselection> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivityService.dispose(); // Clean up the service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backimage.jpg'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/mobileselection.png',
                ),
              ),
              SizedBox(
                height: 96,
              ),
              Text(
                'Track Made Simple',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Select Your Mobile Number',
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: List.generate(widget.simNumbers.length, (index) {
                  String number = widget.simNumbers[index];
                  return number.isNotEmpty
                      ? Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  0.9, // Set the width to 90% of screen width
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.blueAccent,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey
                                //         .withOpacity(0.1), // Shadow color
                                //     spreadRadius: 2,
                                //     blurRadius: 5,
                                //     offset: Offset(0,
                                //         3), // Changes the position of the shadow
                                //   ),
                                // ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Networkcallforverifymobilenumber(
                                  //     number, context);
                                  _checkLocationPermission(number, context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/frame.png",
                                          height: 30,
                                        ),
                                        SizedBox(width: 5),
                                        VerticalDivider(
                                          color: Colors.grey,
                                          thickness: 1,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          number,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Add Divider if it's not the last item
                            if (index < widget.simNumbers.length - 1 &&
                                widget.simNumbers[index + 1].isNotEmpty)
                              SizedBox(
                                height: 14,
                              ),
                          ],
                        )
                      : Container();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool showpopup = false;
  Future<void> _checkLocationPermission(
      String number, BuildContext context1) async {
    var phone = await Permission.phone.status;
    var notification = await Permission.notification.status;
    var contacts = await Permission.contacts.status;
    var systemOverlay = await Permission.systemAlertWindow.status;
    var schedule = await Permission.scheduleExactAlarm.status;

    if (phone.isDenied ||
        notification.isDenied ||
        contacts.isDenied ||
        systemOverlay.isDenied ||
        schedule.isDenied) {
      if (showpopup == false) {
        showpopup = true;
        setState(() {});
        showPermissionsDialog(context, number);
      }
    } else {
      call_log_permission = "1";
      notification_permission = "1";
      contacts_permission = "1";
      system_alert_permission = "1";
      schedule_exact_alarm = "1";
      setState(() {});
      Networkcallforverifymobilenumber(number, context1);
    }
  }

  void showPermissionsDialog(
      BuildContext context, String selectedMobileNumber) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(15), // Add padding around the dialog
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity, // Full height
              child: Permissiondetailsdailog(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  bool permissionsGranted = await requestPermissions();
                  if (permissionsGranted) {
                    call_log_permission = "1";
                    notification_permission = "1";
                    contacts_permission = "1";
                    system_alert_permission = "1";
                    schedule_exact_alarm = "1";
                    setState(() {});
                    Networkcallforverifymobilenumber(
                        selectedMobileNumber, context);
                  } else {
                    _showLocationDisclosureDialog(
                        selectedMobileNumber, context);
                  }
                },
              ),
            ),
          );
        });
  }

  void _showLocationDisclosureDialog(String number, BuildContext context1) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Permissions Required'),
          content: Center(
            child: Text(
              'In order to work properly, you must grant all required permissions.',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                _requestLocationPermission(number, context1);
              },
              child: Text('Allow'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestLocationPermission(String number, BuildContext context1) async {
    bool granted = await requestPermissions();
    if (granted) {
      setState(() {
        call_log_permission = "1";
        notification_permission = "1";
        contacts_permission = "1";
        system_alert_permission = "1";
        schedule_exact_alarm = "1";
      });
      Networkcallforverifymobilenumber(number, context1);
    } else {
      openAppSettings();
    }
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.notification,
      Permission.contacts,
      Permission.systemAlertWindow,
      Permission.scheduleExactAlarm,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> Networkcallforverifymobilenumber(
      String selectedMobileNumber, BuildContext context1) async {
    try {
      ProgressDialog.showProgressDialog(context1, "Please wait...");
      String createjson = Createjson.createjsonforverifynumber(
          selectedMobileNumber,
          widget.app_current_version,
          widget.device_os_version,
          widget.device_id,
          widget.device_manufacture,
          widget.device_modal,
          widget.push_token,
          widget.taget_sdk,
          call_log_permission,
          contacts_permission,
          notification_permission,
          schedule_exact_alarm,
          system_alert_permission,
          widget.device_os);
      List<Object?>? list = await NetworkResponse().postMethod(
          NetworkUtility.get_mobile_number_verify,
          NetworkUtility.get_mobile_number_verify_api,
          createjson,
          context);
      if (list != null) {
        Navigator.of(context, rootNavigator: true).pop();
        List<Verifymobilenumberresponse> response = List.from(list!);
        String status = response[0].status!;
        switch (status) {
          case "true":
            // savevaluetosharedpref(
            //     response[0].data!.id,
            //     "1",
            //     response[0].data!.password,
            //     response[0].data!.userType,
            //     response[0].data!.companyId,
            //     response[0].data!.fullName!,
            //     selectedMobileNumber);
            Movetologin(
                selectedMobileNumber,
                response[0].data!.id,
                "1",
                response[0].data!.password,
                response[0].data!.userType,
                response[0].data!.companyId,
                response[0].data!.fullName!);
            break;
          case "false":
            SnackBarDesign(
                "Authentication failed. Please select a registered number or contact the administrator for assistance",
                context1,
                Colorfile().errormessagebcColor,
                Colorfile().errormessagetxColor);
            break;
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        SnackBarDesign(
            "Authentication failed. Please select a registered number or contact the administrator for assistance",
            context1,
            Colorfile().errormessagebcColor,
            Colorfile().errormessagetxColor);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Movetologin(
    String selectedMobileNumber,
    String id,
    String isloginfirst,
    String password,
    String userType,
    String CompanyId,
    String Name,
  ) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return LoginPage(selectedMobileNumber, "Mobile Number Selection", id,
            isloginfirst, password, userType, CompanyId, Name);
      },
    ));
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        // deviceData = switch (defaultTargetPlatform) {
        //   TargetPlatform.android =>
        //     _readAndroidBuildData(await deviceInfoPlugin.androidInfo),
        //   TargetPlatform.iOS =>
        //     _readIosDeviceInfo(await deviceInfoPlugin.iosInfo),
        //   TargetPlatform.linux =>
        //     _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo),
        //   TargetPlatform.windows =>
        //     _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo),
        //   TargetPlatform.macOS =>
        //     _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo),
        //   TargetPlatform.fuchsia => <String, dynamic>{
        //       'Error:': 'Fuchsia platform isn\'t supported'
        //     },
        // };

        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        device_os_version = deviceData['version.release'];
        device_id = deviceData['id'];
        device_manufacture = deviceData['manufacturer'];
        device_modal = deviceData['model'];
        taget_sdk = "34";
        return;
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      app_current_version = packageInfo.version; // Access the app version here
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
      'isLowRamDevice': build.isLowRamDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }
}
