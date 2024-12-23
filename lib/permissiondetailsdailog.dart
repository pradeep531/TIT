import 'package:flutter/material.dart';

bool _isAlwaysShown = true;
bool _trackVisibility = false;
final _scrollController = ScrollController(initialScrollOffset: 10.0);

class Permissiondetailsdailog extends StatelessWidget {
  final VoidCallback onPressed;
  const Permissiondetailsdailog({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      padding: EdgeInsets.only(right: 10, top: 20, bottom: 30),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: _isAlwaysShown,
        trackVisibility: _trackVisibility,
        child: ListView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Permissions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  commonRow(
                    'Phone',
                    "Limited information about your calls, such as phone numbers and outgoing incoming calls, is collected by us. This helps us display your call history, verify your phone number through a missed call, and assist you in managing your calls efficiently.",
                    Icons.phone,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  commonRow(
                    'Contacts',
                    "We collect limited information from your contacts to help you quickly connect and communicate with people from your contact list. This allows you to manage your contacts and track communication efficiently.",
                    Icons.contact_page,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  commonRow(
                    'Notification',
                    "We request access to send you notifications to keep you informed about important updates, reminders, and alerts related to your account and activities within the app. This ensures you never miss crucial information.",
                    Icons.notifications,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  commonRow(
                    'Schedule Exact Alarm',
                    "This permission is needed to schedule precise reminders, ensuring that you receive timely alerts for call reminder, even when the app is not actively running.",
                    Icons.alarm,
                  ),
                  SizedBox(height: 10),
                  commonRow(
                      'System Alert Window',
                      "We require access to display notifications and helpful prompts over other apps, ensuring you can interact with key features like call pop-ups or reminders even when you're using other applications.",
                      Icons.display_settings),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.blueAccent.withOpacity(0.2),
                    margin: EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.safety_check,
                            color: Colors.blueAccent,
                            size: 16,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                "Your contacts are safe and will not be shared with anyone.",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onPressed,
                        child: Text('CONTINUE',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commonRow(
    String title,
    String desc,
    IconData iconData,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: Colors.blueAccent,
          size: 20,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                desc,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              )
            ],
          ),
        ),
      ],
    );
  }
}
