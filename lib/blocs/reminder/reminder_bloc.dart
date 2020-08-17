import 'dart:async';

import 'package:altar_of_prayers/database/reminder_dao.dart';
import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:flutter/material.dart';
import 'package:altar_of_prayers/widgets/notification_plugin.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderDao _reminderDao = ReminderDao();

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {}

  @override
  get initialState => ReminderInitial();

  @override
  Stream<ReminderState> mapEventToState(
    ReminderEvent event,
  ) async* {
    if (event is CheckReminder) {
      Map isReminderOnMap = await _reminderDao.reminderOn();
      bool isReminderOn = isReminderOnMap['reminder_on'] == 0 ? false : true;
      if (!isReminderOn) {
        yield ReminderOff();
      } else {
        List reminderTime = isReminderOnMap["reminder_time"].split(":");
        yield ReminderOn(
            time: TimeOfDay(
                hour: int.parse(reminderTime[0]),
                minute: int.parse(reminderTime[1])));
      }
      print("isReminderOn: $isReminderOn");
    }
    if (event is SetReminderOn) {
      _reminderDao.setReminderOn(
          reminderOn: true,
          reminderTime: "${event.time.hour}:${event.time.minute}");
      // print("${event.time.hour.runtimeType}, ${event.time.hour.runtimeType}");
      notificationPlugin
          .setListenerForLowerFunctions(onNotificationInLowerVersions);
      notificationPlugin.showDailyAtTimeNotification(
        hour: event.time.hour,
        minute: event.time.minute,
      );

      yield ReminderInitial();
      yield ReminderOn(time: event.time);
    }
    if (event is SetReminderOff) {
      _reminderDao.setReminderOn(reminderOn: false);
      notificationPlugin.cancelReminderNotification();
      yield ReminderOff();
    }
  }
}
