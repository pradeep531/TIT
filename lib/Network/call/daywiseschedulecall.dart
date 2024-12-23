// To parse this JSON data, do
//
//     final daywisescheculecall = daywisescheculecallFromJson(jsonString);

import 'dart:convert';

Daywisescheculecall daywisescheculecallFromJson(String str) =>
    Daywisescheculecall.fromJson(json.decode(str));

String daywisescheculecallToJson(Daywisescheculecall data) =>
    json.encode(data.toJson());

class Daywisescheculecall {
  String userId;
  String date;
  String limit;
  String offset;
  String searchQuery;

  Daywisescheculecall({
    required this.userId,
    required this.date,
    required this.limit,
    required this.offset,
    required this.searchQuery,
  });

  factory Daywisescheculecall.fromJson(Map<String, dynamic> json) =>
      Daywisescheculecall(
        userId: json["user_id"],
        date: json["date"],
        limit: json["limit"],
        offset: json["offset"],
        searchQuery: json["search_query"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "date": date,
        "limit": limit,
        "offset": offset,
        "search_query": searchQuery,
      };
}
