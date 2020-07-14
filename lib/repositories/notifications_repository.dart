import 'package:altar_of_prayers/database/notifications_dao.dart';
import 'package:altar_of_prayers/graphql/graphql.dart';
import 'package:altar_of_prayers/models/notification.dart';
import 'package:altar_of_prayers/repositories/user_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NotificationsRepository {
  NotificationsDao _notificationsDao = NotificationsDao();
  UserRepository _userRepository = UserRepository();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation queryMutation = QueryMutation();

  Future<List<Map<String, dynamic>>> getLocalNotifications() async {
    List<Map<String, dynamic>> notifications =
        await _notificationsDao.getNotifications();
    if (notifications != null) return notifications;
    return [];
  }

  Future<bool> markNotificationAsRead({int id}) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.markNotificationAsRead(id: id))),
    );

    if (!result.hasException) {
      return result.data["markNotificationAsRead"]["success"];
    } else {
      return false;
    }
  }

  Future<List> getNotificationsFromServer() async {
    // get notifications from server and empty the prev notificationsTable
    //  then replace with new ones
    Map currentUserInfo = await _userRepository.currentUserInfo();

    _notificationsDao.deleteAllNotifications();

    List<NotificationModel> _userNotifications =
        (currentUserInfo["currentUser"]["userNotification"] as List)
            .map((notification) {
      NotificationModel _notification =
          NotificationModel.fromServerJson(notification);

      return _notification;
    }).toList();

    Future.forEach(_userNotifications, (notification) async {
      // save notification and return
      // print("notification: ${notification.runtimeType}");
      await _notificationsDao.saveNotification(notification: notification);
      return null;
    });
    return _userNotifications;
  }

  Future<int> saveNotification({NotificationModel notification}) async {
    return _notificationsDao.saveNotification(notification: notification);
  }

  Future deleteNotification({NotificationModel notification}) async {
    GraphQLClient _client = await graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.mutate(
      MutationOptions(
          documentNode: gql(queryMutation.deleteUserNotification(id: notification.id))),
    );

    if (!result.hasException) {
      if (result.data["deleteUserNotification"]["success"])
        await _notificationsDao.deleteNotification(notification: notification);
      return result.data["deleteUserNotification"]["success"];
    } else {
      return false;
    }
  }
}
