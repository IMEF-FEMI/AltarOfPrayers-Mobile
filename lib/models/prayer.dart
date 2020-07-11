import 'dart:convert';

class Prayer {
  int id;
  String topic;
  String passage;
  String message;
  List prayerPoints;

  Prayer({
    this.id,
    this.topic,
    this.passage,
    this.message,
    this.prayerPoints,
  });

  Prayer.fromDatabaseJson(Map<String, dynamic> json) {
    id = json["id"];
    topic = json["topic"];
    passage = json["passage"];
    message = json["message"];
    prayerPoints = JsonDecoder().convert(json["prayer_points"]);
  }

  Map<String, dynamic> toDatabasejson() {
    return {
      'id': id,
      'topic': topic,
      'passage': passage,
      'message': message,
      'prayerPoints': JsonEncoder().convert(prayerPoints)
    };
  }
}
