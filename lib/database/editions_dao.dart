import 'package:altar_of_prayers/database/database.dart';
import 'package:altar_of_prayers/models/edition.dart';

class EditionsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> saveReference({int editionId, String reference}) async {
    final db = await dbProvider.database;
    var result = db.insert(
        referenceTABLE, {'editionId': editionId, 'reference': reference});
    // print('save reference result $result');
    return result;
  }

  Future<int> saveEdition(Edition edition) async {
    final db = await dbProvider.database;
    Future<int> result = db.insert(editionsTable, edition.toDatabaseJson());
    return result;
  }

  Future<Map<String, dynamic>> getEdition({int editionId}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(
      editionsTable,
      where: 'id = ? ',
      whereArgs: ['$editionId'],
    );
    if (result.length > 0) return result.first;
    return null;
  }

  Future<Map<dynamic, dynamic>> getReference({int editionId}) async {
    final db = await dbProvider.database;
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
    var result = await db.delete(referenceTABLE,
        where: 'editionId = ?', whereArgs: ['$editionId']);
    return result;
  }
}
