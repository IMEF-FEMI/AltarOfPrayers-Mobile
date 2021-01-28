import 'db.dart';

class DarkModeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<bool> darkModeOn({int id = 1}) async {
    final db = await dbProvider.database;

    var result = await db.query(
      darkModeTable,
      where: 'id = ?',
      whereArgs: ['$id'],
    );
    if (result.length > 0)
      return result.first['dark_mode_on'] == 0 ? false : true;
    return null;
  }

  Future<int> changeDarkMode({bool darkModeOn, int id = 1}) async {
    final db = await dbProvider.database;
    Future<int> result = db.update(
        darkModeTable, {'dark_mode_on': darkModeOn == false ? 0 : 1},
        where: 'id = ?', whereArgs: ['$id']);
    return result;
  }

  
}
