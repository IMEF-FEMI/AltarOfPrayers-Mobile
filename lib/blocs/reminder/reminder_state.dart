import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();
  @override
  List<Object> get props => [];
}

class ReminderInitial extends ReminderState {}

class ReminderOff extends ReminderState {}

class ReminderOn extends ReminderState {
  final TimeOfDay time;

  const ReminderOn({this.time});
}
