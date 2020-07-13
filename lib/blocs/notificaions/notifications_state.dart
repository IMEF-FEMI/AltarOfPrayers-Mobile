import 'package:altar_of_prayers/models/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;

  const NotificationsLoaded({this.notifications});
}

class NotificationsError extends NotificationState {
  final String error;

  const NotificationsError({this.error});
}

class NoNewNotification extends NotificationState{}