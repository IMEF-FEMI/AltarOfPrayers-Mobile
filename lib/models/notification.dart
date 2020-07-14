class NotificationModel {
  int id;
  String title;
  String message;
  bool read;

  NotificationModel({
    this.id,
    this.title,
    this.message,
    this.read,
  });

  NotificationModel.fromServerJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == String ? int.parse(json['id']) : json['id'];
    title = json['title'];
    message = json['message'];
    read = json['read'];
  }

  NotificationModel.fromDatabaseJson(Map<String, dynamic> json) {
    id = json['id'].runtimeType == String ? int.parse(json['id']) : json['id'];
    title = json['title'];
    message = json['message'];
    read = json['read'] == 0 ? false : true;
  }

  Map<String, dynamic> toDatabaseJson() => {
        "id": this.id,
        "title": this.title,
        "message": this.message,
        "read": this.read == false ? 0 : 1,
      };
}
