import 'package:altar_of_prayers/models/notification.dart';

import 'db.dart';

class NotificationsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> saveNotification({NotificationModel notification}) async {
    final db = await dbProvider.database;
    var result = db.insert(notificationsTable, notification.toDatabaseJson());
    return result;
  }

  Future<int> deleteAllNotifications() async {
    final db = await dbProvider.database;
    return await db.delete(notificationsTable);
  }

  Future<int> markNotificationAsRead({NotificationModel notification}) async {
    final db = await dbProvider.database;

    var result = await db.update(
        notificationsTable, notification.toDatabaseJson(),
        where: "id = ?", whereArgs: [notification.id]);

    return result;
  }

  Future deleteNotification({NotificationModel notification}) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      notificationsTable,
      where: "id = ?",
      whereArgs: [notification.id],
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(
      notificationsTable,
    );
    if (result.length > 0) return result;
    return null;
  }
}
