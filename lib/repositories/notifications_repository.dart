import 'package:altar_of_prayers/database/notifications_dao.dart';
import 'package:altar_of_prayers/models/notification.dart';

class NotificationsRepository {
  NotificationsDao _notificationsDao = NotificationsDao();

  Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    List<Map<String, dynamic>> notifications =
        await _notificationsDao.getNotifications();
    if (notifications != null) return notifications;
    return [];
  }

   Future<List<Map<String, dynamic>>>  getNotificationsFromServer() async{
      // get notifications from server and empty the prev notificationsTable
      //  then replace with new ones
   }

  Future<int> saveNotification({Notification notification}) async {
    return _notificationsDao.saveNotification(notification: notification);
  }

  Future deleteNotification({Notification notification}) async {
    return _notificationsDao.deleteNotification(notification: notification);
  }
}
