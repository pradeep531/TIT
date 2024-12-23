import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state_background/phone_state_background.dart';
import 'package:quickensolcrm/cursorvalviewpage.dart';
import 'package:quickensolcrm/customedesign/SnackbarService.dart';
import 'package:quickensolcrm/main.dart';
import 'package:quickensolcrm/mobileumberselection.dart';
import 'package:quickensolcrm/permissiondetailsdailog.dart';
import 'package:quickensolcrm/updateappdialog.dart';
import 'calltrackerapp.dart';
import 'customedesign/ConnectivityService.dart';
import 'customedesign/apputility.dart';
import 'customedesign/sharedpref.dart';
import 'customedesign/snackbardesign.dart';
import 'favorites.dart';
import 'notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
Map<String, dynamic> _deviceData = <String, dynamic>{};
String device_os_version = "",
    device_id = "",
    device_manufacture = "",
    device_modal = "",
    taget_sdk = "",
    app_current_version = "",
    push_token = "",
    call_log_permission = "0",
    notification_permission = "0",
    contacts_permission = "0",
    system_alert_permission = "0",
    schedule_exact_alarm = "0";

class SplashScreen extends StatefulWidget {
  @override
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SendPort? homePort;
  String? latestMessageFromOverlay;
  String pushtoken = "";
  NotificationService notificationServices = NotificationService();
  bool hasPermission = false;
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();
    //  checkVersion();
    NotificationService().initNotification();

    notificationServices.firebaseInit(context);

    notificationServices.getDevicetoken().then((value) {
      print('Device Token ${value}');
      push_token = value;
    });

    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 5));
    // _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);

    // _controller.forward();
    initPlatformState();
    _getAppVersion();
    // getValueFromSharedPref();
    _checkLocationPermission();
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

  Future<String?> getPlayStoreVersion(String packageName) async {
    try {
      // The URL of your app in the Play Store
      final url = 'https://play.google.com/store/apps/details?id=$packageName';

      // Make an HTTP GET request
      final response = await http.get(Uri.parse(url));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the HTML response
        final document = html.parse(response.body);

        // Use a selector to find the version element
        // final versionElement =
        //     document.querySelector('div[itemprop="softwareVersion"]');
        final versionElement =
            document.querySelector("div:containsOwn(Current Version)");
        // Return the version text
        return versionElement?.text?.trim();
      } else {
        print('Failed to load version. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Play Store version: $e');
      return null;
    }
  }

  void checkVersion() async {
    String packageName =
        'com.quick.shauryapay'; // Replace with your actual package name
    String? playStoreVersion = await getPlayStoreVersion(packageName);
    print('Play Store Version: $playStoreVersion');
  }

  @override
  void dispose() {
    // _controller.dispose();
    _connectivityService.dispose(); // Clean up the service
    super.dispose();
  }

  Future<void> _requestPermission() async {
    await PhoneStateBackground.requestPermissions();
  }

  bool showpopup = false;
  Future<void> _checkLocationPermission() async {
    var phone = await Permission.phone.status;
    var notification = await Permission.notification.status;
    var contacts = await Permission.contacts.status;
    var systemOverlay = await Permission.systemAlertWindow.status;
    var schedule = await Permission.scheduleExactAlarm.status;
    var battery = await Permission.ignoreBatteryOptimizations.status;

    if (phone.isDenied ||
        notification.isDenied ||
        contacts.isDenied ||
        systemOverlay.isDenied ||
        schedule.isDenied ||
        battery.isDenied) {
      if (showpopup == false) {
        showpopup = true;
        setState(() {});
        showPermissionsDialog(context);
      }
    } else {
      call_log_permission = "1";
      notification_permission = "1";
      contacts_permission = "1";
      system_alert_permission = "1";
      schedule_exact_alarm = "1";
      setState(() {});

      getValueFromSharedPref();
    }
  }

  void showPermissionsDialog(BuildContext context) {
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
                    getValueFromSharedPref();
                  } else {
                    _showLocationDisclosureDialog();
                  }
                },
              ),
            ),
          );
        });
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent, child: Updateappdialog());
      },
    );
  }

  void _showLocationDisclosureDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Permissions Required'),
          content: Text(
            'In order to work properly, you must grant all required permissions.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                _requestLocationPermission(context);
              },
              child: Text('Allow'),
            ),
          ],
        ),
      ),
    );
  }

  void _requestLocationPermission(BuildContext context) async {
    bool granted = await requestPermissions();
    if (granted) {
      setState(() {
        call_log_permission = "1";
        notification_permission = "1";
        contacts_permission = "1";
        system_alert_permission = "1";
        schedule_exact_alarm = "1";
      });
      getValueFromSharedPref();
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
      Permission.ignoreBatteryOptimizations
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  getValueFromSharedPref() async {
    try {
      await SharedPreference().getvalueonligin(context);

      print(AppUtility.userId);
      // _getSimInfoForCall();
      getSimNumbers();
    } catch (e) {
      // Handle the error appropriately
    }
  }

  MoveToNext(List simNumbers) {
    if (AppUtility.isloginfirst == "1") {
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Mobileumberselection(
                  simNumbers,
                  device_os_version,
                  device_id,
                  device_manufacture,
                  device_modal,
                  taget_sdk,
                  app_current_version,
                  push_token,
                  "Android")),
        );
      }
    } else {
      SharedPreference().savetrakingvalue("0");

      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return CursoralViewPage(
              simNumbers,
              device_os_version,
              device_id,
              device_manufacture,
              device_modal,
              taget_sdk,
              app_current_version,
              push_token,
              "Android");
        },
      ));
    }
  }

  static const platform = MethodChannel('quickensolcrm');
  getSimNumbers() async {
    try {
      final List<dynamic> simNumbers =
          await platform.invokeMethod('getSimNumbers');

      MoveToNext(simNumbers);
      // _showCustomDialog(context);
    } on PlatformException catch (e) {
      print("Failed to get SIM numbers: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            constraints: const BoxConstraints.expand(),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage("assets/images/background.jpg"),
            //       fit: BoxFit.cover,
            //       opacity: 0.7),
            // ),
            // child: FadeTransition(
            //   alwaysIncludeSemantics: true,
            //   opacity: _animation,
            //   child: Image.asset(
            //     "assets/logo1.png",
            //   ),
            // ),
          ),
          // Center(
          //   child: _isConnected
          //       ? Text('You are online!')
          //       : Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Image.asset('assets/no_internet.png',
          //                 width: 150), // Your no internet image
          //             SizedBox(height: 20),
          //             Text('No internet connection.'),
          //           ],
          //         ),
          // ),
        ]),
      ),
    );
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

    setState(() {
      _deviceData = deviceData;
    });
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
