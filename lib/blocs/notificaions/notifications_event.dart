import 'package:altar_of_prayers/models/notification.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final NotificationModel notification;

  MarkAsRead({this.notification});
}

class RemoveNotification extends NotificationEvent {
  final NotificationModel notification;
  final int index;

  const RemoveNotification({this.notification, this.index});
}

class DeleteNotification extends NotificationEvent {
  final NotificationModel notification;
  final int index;

  const DeleteNotification({this.notification, this.index});
}

class UndoRemove extends NotificationEvent {
  final NotificationModel notification;
  final int index;

  const UndoRemove({this.notification, this.index});
}

class DeletePrayer extends NotificationEvent {
  final NotificationModel notification;

  const DeletePrayer({this.notification});
}
