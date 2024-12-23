import 'dart:developer';
import 'dart:ffi';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CallLogCard extends StatelessWidget {
  final CallLogEntry entry;
  final VoidCallback onInfoTap;
  final VoidCallback onCallTap;
  final bool showcallbutton;
  CallLogCard(this.entry,
      {required this.onInfoTap,
      required this.onCallTap,
      required this.showcallbutton});

  String formatDuration(int? durationInSeconds) {
    if (durationInSeconds == null) return "0s";
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return "${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime time =
        DateTime.fromMillisecondsSinceEpoch(entry.timestamp!).toLocal();

    Duration duration = now.difference(time).abs();

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    String timeAgo;
    if (days > 0) {
      timeAgo = (days == 1 ? '$days day ago' : '$days days ago');
    } else if (hours > 0) {
      timeAgo = ('$hours hours $minutes minutes ago');
    } else {
      timeAgo = ('$minutes minutes ago');
    }
    return Card(
      // Removed margins for a more compact design
      elevation: 0, // No shadow for flat design
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Softer corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 0), // Smaller padding to reduce height
          decoration: BoxDecoration(
            color: Colors.white, // Flat white background
            border: Border(
              bottom: BorderSide(
                  color: Colors.grey[300]!, width: 0.5), // Subtle bottom border
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(8.0), // Adjusted padding for avatar
                child: CircleAvatar(
                  backgroundColor: _getAvatarColor(entry.callType),
                  radius: 20, // Slightly smaller avatar for compact design
                  child: Text(
                    entry.name != null && entry.name!.isNotEmpty
                        ? entry.name![0].toUpperCase()
                        : 'U', // Placeholder for unknown
                    style: TextStyle(
                        color: Colors.white, fontSize: 16), // Simpler style
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name != null && entry.name!.isNotEmpty
                          ? entry.name!
                          : entry.number ?? 'Unknown Number',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w500, // Slightly lighter font weight
                        fontSize: 14, // Smaller font size for compactness
                        color: Colors.black, // Pure black text
                      ),
                      maxLines: 1, // Single line for the name/number
                      overflow:
                          TextOverflow.ellipsis, // Handle long names/numbers
                    ),
                    SizedBox(height: 2), // Small space between lines
                    Row(
                      children: [
                        Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp!).toLocal())}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          //'Time:${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!).toLocal().toString().split(' ')[1]}',
                          'Time: ${timeAgo}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Duration: ${formatDuration(entry.duration)}',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          _getCallIcon(entry.callType),
                          color: _getCallColor(entry.callType),
                          size: 16.0, // Smaller icon size for subtle design
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 0.0), // Padding for the trailing icon
                child: IconButton(
                  icon: Icon(Icons.info_outline,
                      color: Colors.blue), // Info button in blue color
                  onPressed: onInfoTap,
                ),
              ),
              showcallbutton
                  ? Padding(
                      padding: const EdgeInsets.only(
                          right: 0.0), // Padding for the trailing icon
                      child: IconButton(
                        icon: Icon(Icons.call,
                            color: Colors.green), // Info button in blue color
                        onPressed: onCallTap,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCallIcon(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      default:
        return Icons.phone;
    }
  }

  Color _getCallColor(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blue;
      case CallType.missed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAvatarColor(CallType? callType) {
    switch (callType) {
      case CallType.incoming:
        return Colors.green;
      case CallType.outgoing:
        return Colors.blueAccent;
      case CallType.missed:
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
