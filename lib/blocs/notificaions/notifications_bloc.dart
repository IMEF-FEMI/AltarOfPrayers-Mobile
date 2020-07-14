import 'dart:async';

import 'package:altar_of_prayers/blocs/notificaions/bloc.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/repositories/notifications_repository.dart';
import 'package:bloc/bloc.dart';

class NotificationsBloc extends Bloc<NotificationEvent, NotificationsState> {
  NotificationsRepository _notificationsRepository = NotificationsRepository();

  @override
  NotificationsState get initialState => NotificationLoading();

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    } else if (event is MarkAsRead) {
      yield* _mapMarkAsReadToState(event);
    } else if (event is RemoveNotification) {
      yield* _mapRemoveNotificationToState(event);
    } else if (event is DeleteNotification) {
      yield* _mapDeleteNotificationToState(event);
    }
    //  else if (event is UndoRemove) {
    //   yield* _mapUndoRemoveToState(event);
    // }
  }

  Stream<NotificationsState> _mapDeleteNotificationToState(
      DeleteNotification event) async* {
    yield NotificationLoading();
      await _notificationsRepository.deleteNotification(notification: event.notification);
    this.add(LoadNotifications());
  }

  Stream<NotificationsState> _mapRemoveNotificationToState(
      RemoveNotification event) async* {
    List<NotificationModel> _notifications = (state as NotificationsLoaded)
        .notifications
        .where((
          notification,
        ) =>
            notification.id != event.notification.id)
        .toList();
    yield NotificationsLoaded(notifications: _notifications);
  }

  Stream<NotificationsState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    yield NotificationLoading();

    // get from local
    List notificationsFromLocal =
        await _notificationsRepository.getLocalNotifications();
    if (notificationsFromLocal.length != 0)
      yield NotificationsLoaded(
          notifications: notificationsFromLocal
              .map((notification) =>
                  NotificationModel.fromDatabaseJson(notification))
              .toList());

    // get from server
    List notificationsFromServer;
    try {
      notificationsFromServer =
          await _notificationsRepository.getNotificationsFromServer();
      yield NotificationLoading();
      yield NotificationsLoaded(notifications: notificationsFromServer);
    } catch (e) {
      print("error: $e");
      if (notificationsFromLocal.length == 0)
        yield NotificationsError(error: "Error Fetching From Server");
    }

    if (notificationsFromLocal.length == 0 &&
        notificationsFromServer.length == 0) yield NoNewNotification();
  }

  Stream<NotificationsState> _mapMarkAsReadToState(MarkAsRead event) async* {
    await _notificationsRepository.markNotificationAsRead(
        id: event.notification.id);
  }
}
