import 'package:altar_of_prayers/database/database.dart';

class EditionsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> saveReference(String reference) async {
    final db = await dbProvider.database;
    var result = db.insert(referenceTABLE, {reference: reference});
    return result;
  }

  Future<String> getReference()async{
    final db = await dbProvider.database;
    List<Map<dynamic, dynamic>> result = await db.query(referenceTABLE);

    String reference = result.isNotEmpty ? result.first['reference']: '';
    return reference;
  }}
