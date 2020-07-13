import 'dart:async';

import 'package:altar_of_prayers/blocs/notificaions/bloc.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/repositories/notifications_repository.dart';
import 'package:bloc/bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationsRepository _notificationsRepository = NotificationsRepository();

  @override
  NotificationState get initialState => NotificationLoading();

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is LoadNotifications) {
      yield* _mapLoadNotificationsToState(event);
    }
  }

  Stream<NotificationState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    yield NotificationLoading();

    // get from local
    List notificationsFromLocal =
        await _notificationsRepository.getLocalNotifications();

    yield NotificationsLoaded(
        notifications: notificationsFromLocal
            .map((notification) => Notification.fromDatabaseJson(notification))
            .toList());

    // get from server
    List notificationsFromServer;
    try {
      notificationsFromServer =
          await _notificationsRepository.getNotificationsFromServer();
      yield NotificationsLoaded(
          notifications: notificationsFromServer
              .map(
                  (notification) => Notification.fromDatabaseJson(notification))
              .toList());
    } catch (e) {
      if (notificationsFromLocal.length == 0)
        yield NotificationsError(error: "Error Fetching From Server");
    }

    if (notificationsFromLocal.length == 0 &&
        notificationsFromServer.length == 0) yield NoNewNotification();
  }
}
