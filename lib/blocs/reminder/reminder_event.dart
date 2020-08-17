import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
  @override
  List<Object> get props => [];
}

class SetReminderOn extends ReminderEvent {
  final TimeOfDay time;

  const SetReminderOn({@required this.time});

  @override
  List<Object> get props => [time];
}

class SetReminderOff extends ReminderEvent {}

class CheckReminder extends ReminderEvent {}
