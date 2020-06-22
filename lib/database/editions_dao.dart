import 'dart:convert';

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

  Future<int> saveSeenEdition({int editionId}) async {
    final db = await dbProvider.database;
    Map seenEditions = await getSeenEditions();
    if (seenEditions.containsKey(editionId.toString())) {
      return 1;
    }

    seenEditions[editionId.toString()] = editionId;
    var result = await db.update(seenEditionsTable,
        {'seen_editions': JsonEncoder().convert(seenEditions)},
        where: "id = ?", whereArgs: [1]);
    return result;
  }

  Future<Map<String, dynamic>> getEdition(
      {int editionId, int startingMonth, int year}) async {
    final db = await dbProvider.database;
    String where;
    List whereArgs;
    if (editionId != null) {
      where = 'id = ? ';
      whereArgs = [editionId];
    } else {
      where = 'starting_month = ? and year = ? ';
      whereArgs = [startingMonth, year];
    }

    List<Map<String, dynamic>> result = await db.query(
      editionsTable,
      where: where,
      whereArgs: whereArgs,
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

  Future<Map> getSeenEditions({int id = 1}) async {
    final db = await dbProvider.database;
    var result = await db.query(
      seenEditionsTable,
      where: 'id = ? ',
      whereArgs: ['$id'],
    );

    if (result.length > 0) {
      return JsonDecoder().convert(result.first['seen_editions']);
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
