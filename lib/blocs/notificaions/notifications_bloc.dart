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
    }
  }

  Stream<NotificationsState> _mapLoadNotificationsToState(
      LoadNotifications event) async* {
    yield NotificationLoading();

    // get from local
    List notificationsFromLocal =
        await _notificationsRepository.getLocalNotifications();
      print('notificationsFromLocal: $notificationsFromLocal');
    if (notificationsFromLocal.length != 0)
      yield NotificationsLoaded(
          notifications: notificationsFromLocal
              .map((notification) async =>
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
}
