import 'package:altar_of_prayers/database/notifications_dao.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';

class NotificationsRepository {
  NotificationsDao _notificationsDao = NotificationsDao();
  UserRepository _userRepository = UserRepository();

  Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    List<Map<String, dynamic>> notifications =
        await _notificationsDao.getNotifications();
    if (notifications != null) return notifications;
    return [];
  }

  Future<List> getNotificationsFromServer() async {
    // get notifications from server and empty the prev notificationsTable
    //  then replace with new ones
    Map currentUserInfo = await _userRepository.currentUserInfo();

    _notificationsDao.deleteAllNotifications();

    List<Future<NotificationModel>> _userNotifications =
        (currentUserInfo["currentUser"]["userNotification"] as List)
            .map((notification) async {
      NotificationModel _notification = NotificationModel.fromServerJson(notification);

      // save notification and return
      await _notificationsDao.saveNotification(notification: _notification);
      return _notification;
    }).toList();


    return _userNotifications;
  }

  Future<int> saveNotification({NotificationModel notification}) async {
    return _notificationsDao.saveNotification(notification: notification);
  }

  Future deleteNotification({NotificationModel notification}) async {
    return _notificationsDao.deleteNotification(notification: notification);
  }
}
