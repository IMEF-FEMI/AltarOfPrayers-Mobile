import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _initializePlatformSpecifics();
  }

  _initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceiveLocalNotificationSubject.add(receivedNotification);
        });
    initializationSettings = InitializationSettings(
      initializationSettingsAndroid,
      initializationSettingsIOS,
    );
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  setListenerForLowerFunctions(Function onNotificationInLowerVersions) {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
    
  }

  Future<void> showNotification(
      {ReceivedNotification receivedNotification}) async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      "AltarofPrayers.id",
      "AltarofPrayers.channel",
      "AltarofPrayers.description",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      // timeoutAfter: 5000
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platFormSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      "Altar of Prayers",
      receivedNotification.body,
      platFormSpecifics,
      payload: receivedNotification.payload,
    );
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannelSpecifics = AndroidNotificationDetails(
      "AltarofPrayers.schedule.id",
      "AltarofPrayers.schedule.channel",
      "AltarofPrayers.schedule.description",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      // timeoutAfter: 5000
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platFormSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      0,
      "Test",
      "Test Body",
      scheduleNotificationDateTime,
      platFormSpecifics,
      payload: "Test PAyload",
    );
  }

  Future<void> showDailyAtTimeNotification() async {
    var time = Time(8, 9, 0);
    var androidChannelSpecifics = AndroidNotificationDetails(
      "AltarofPrayers.daily.id",
      "AltarofPrayers.daily.channel",
      "AltarofPrayers.daily.description",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      // timeoutAfter: 5000
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platFormSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      "Test",
      null,
      time,
      platFormSpecifics,
      // payload: "Test PAyload",
    );
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({this.id, this.title, this.body, this.payload});
}
