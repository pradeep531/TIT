import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Updateappdialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      // height: 300,
      height: double.infinity, // Full height
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.dst),
          image: AssetImage(
              'assets/updateapp.png'), // Replace with your image path
          fit: BoxFit.fitHeight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70), // Centered Text Title
            Text(
              'App Update Required!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Centered Message Text
            Text(
              'We have added new features and fix some bugs to make your experience seamless.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Centered Button
            ElevatedButton(
              onPressed: () {
                final String playStoreUrl =
                    'https://play.google.com/store/apps/details?id=com.quick.shauryapay';
                _openPlayStore(playStoreUrl);
              },
              child: Text(
                '  Update App  ',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff032183).withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPlayStore(String playStoreUrl) async {
    // Check if the URL can be launched
    if (await canLaunch(playStoreUrl)) {
      await launch(playStoreUrl);
    } else {
      throw 'Could not launch $playStoreUrl';
    }
  }
}
