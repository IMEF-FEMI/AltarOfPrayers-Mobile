import 'package:altar_of_prayers/database/database.dart';

class EditionsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> saveReference({int editionId, String reference}) async {
    final db = await dbProvider.database;
    var result = db.insert(
        referenceTABLE, {'editionId': editionId, 'reference': reference});
    print('save reference result $result');
    return result;
  }

  Future<Map<dynamic, dynamic>> getReference({int editionId}) async {
    final db = await dbProvider.database;
    print('we here');
    var result = await db.query(
      referenceTABLE,
      where: 'editionId = ? ',
      whereArgs: ['$editionId'],
    );

    if (result.length > 0) {
      return result.first;
    }
    return null;
  }

  Future deleteReference({int editionId}) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      referenceTABLE,
      where: 'editionId = ?',
      whereArgs: ['$editionId']
    );
    return result;
  }
}
