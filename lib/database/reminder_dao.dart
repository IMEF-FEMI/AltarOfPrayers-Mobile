import 'db.dart';

class ReminderDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Map> reminderOn({int id = 1}) async {
    final db = await dbProvider.database;

    var result = await db.query(
      reminderTable,
      where: 'id = ?',
      whereArgs: ['$id'],
    );
    if (result.length > 0)
      return result.first;
    return null;
  }

  Future<int> setReminderOn(
      {bool reminderOn, int id = 1, String reminderTime=""}) async {
    final db = await dbProvider.database;
    Future<int> result = db.update(
        reminderTable,
        {
          'reminder_on': reminderOn == false ? 0 : 1,
          "reminder_time": reminderTime
        },
        where: 'id = ?',
        whereArgs: ['$id']);
    return result;
  }
}
