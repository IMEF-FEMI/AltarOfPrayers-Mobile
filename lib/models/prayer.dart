import 'dart:convert';
import 'package:meta/meta.dart';

class Prayer {
  int id;
  int day;
  int month;
  int year;
  String topic;
  String passage;
  String message;
  List prayerPoints;

  Prayer({
    @required this.id,
    @required this.day,
    @required this.month,
    @required this.year,
    @required this.topic,
    @required this.passage,
    @required this.message,
    @required this.prayerPoints,
  });

  Prayer.fromDatabaseJson(Map<String, dynamic> json) {
    id = json["id"];
    day = json["day"];
    month = json["month"];
    year = json["year"];
    topic = json["topic"];
    passage = json["passage"];
    message = json["message"];
    prayerPoints = JsonDecoder().convert(json["prayer_points"]);
  }

  Map<String, dynamic> toDatabasejson() {
    return {
      'id': id,
      'day': day,
      'month': month,
      'year': year,
      'topic': topic,
      'passage': passage,
      'message': message,
      'prayer_points': JsonEncoder().convert(prayerPoints)
    };
  }
}
