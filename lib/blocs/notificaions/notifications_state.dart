import 'package:altar_of_prayers/models/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<Future<NotificationModel>> notifications;

  const NotificationsLoaded({this.notifications});
}

class NotificationsError extends NotificationsState {
  final String error;

  const NotificationsError({this.error});
}

class NoNewNotification extends NotificationsState{}