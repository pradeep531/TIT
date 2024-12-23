import 'package:carousel_slider/carousel_slider.dart' as slider;

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickensolcrm/splashscreen.dart';

import 'customedesign/sharedpref.dart';
import 'mobileumberselection.dart';

class CursoralViewPage extends StatefulWidget {
  List simNumbers;
  String device_os_version,
      device_id,
      device_manufacture,
      device_modal,
      taget_sdk,
      app_current_version,
      push_token,
      device_os;
  CursoralViewPage(
      this.simNumbers,
      this.device_os_version,
      this.device_id,
      this.device_manufacture,
      this.device_modal,
      this.taget_sdk,
      this.app_current_version,
      this.push_token,
      this.device_os);

  State createState() => CursoralViewPageState();
}

List<String> imageString = [
  "assets/page1.png",
  "assets/page2.png",
  "assets/page3.png"
];

List<String> message = [
  "Save Summary of previous call, record your call history with summary and details",
  "Schecule call or Reminder with app. Our apps lets keep you control over schedule call or reminder always",
  "Get Schedule notification for your call and reminder. Say goodbye to missed schedule call or reminders."
];

class CursoralViewPageState extends State<CursoralViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreference().setValueToSharedPrefernce("isloginfirst", "1");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: _firstWidget()));
  }

  int currentIndex = 0;
  Widget _firstWidget() {
    return Column(
      children: [
        _carsouelSlider(),
        SizedBox(
          height: 20,
        ),

        // ? RoundedCornerButton(
        //     onPressed: () {
        //       Navigator.pushReplacement(context, MaterialPageRoute(
        //         builder: (context) {
        //           return SignIn();
        //         },
        //       ));
        //     },
        //     child: Container(
        //       margin: EdgeInsets.all(10),
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 10, right: 10),
        //         child: Text(
        //           'Get Started',
        //           style: TextDesign.buttonTextStyleDesign,
        //         ),
        //       ),
        //     ),
        //     color: Colorfile().buttonColor)
        currentIndex == 2
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // Set the width to 90% of screen width
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Mobileumberselection(
                                widget.simNumbers,
                                widget.device_os_version,
                                widget.device_id,
                                widget.device_manufacture,
                                widget.device_modal,
                                widget.taget_sdk,
                                widget.app_current_version,
                                widget.push_token,
                                "Android")),
                      );
                    },
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          0.9, // Set the width to 90% of screen width
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentIndex++;
                          });
                        },
                        child: Text(
                          'Next',
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
                  SizedBox(
                    height: 10,
                  ),
                  currentIndex == 2
                      ? Container()
                      : InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Mobileumberselection(
                                      widget.simNumbers,
                                      widget.device_os_version,
                                      widget.device_id,
                                      widget.device_manufacture,
                                      widget.device_modal,
                                      widget.taget_sdk,
                                      widget.app_current_version,
                                      widget.push_token,
                                      "Android")),
                            );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                ],
              ),
        SizedBox(
          height: 30,
        ),
        Align(alignment: Alignment.center, child: _dotIndicator()),
      ],
    );
  }

  Widget _carsouelSlider() {
    return slider.CarouselSlider.builder(
      itemCount: imageString.length,
      options: slider.CarouselOptions(
        viewportFraction: 1,
        initialPage: 0,
        height: MediaQuery.of(context).size.height * 0.7,
        onPageChanged: (index, reason) {
          currentIndex = index;
          setState(() {});
        },
      ),
      itemBuilder: (context, index, realIdx) {
        return _firstCardWidget(currentIndex);
      },
    );
  }

  Widget _dotIndicator() {
    return DotsIndicator(
        dotsCount: imageString.length,
        position: currentIndex,
        decorator: DotsDecorator(
          color: Colors.blueAccent.withOpacity(0.3), // Inactive color
          activeColor: Colors.blueAccent,
        ));
  }

  Widget _firstCardWidget(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 1,
          ),
          Image.asset(imageString[index], width: 350),
          // Lottie.asset(imageString[index], width: 350),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message[index],
              style: TextStyle(
                  color: Color(0xff504848),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
