import 'package:altar_of_prayers/models/prayer.dart';
import 'db.dart';

class PrayerDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> savePrayer({Prayer prayer}) async {
    final db = await dbProvider.database;

    Map savedPrayer = await getPrayer(id: prayer.id);
    if (savedPrayer == null) {
      var result = await db.insert(prayersTable, prayer.toDatabasejson());

      return result;
    }
    return 1;
  }

  Future deletePrayer({int id}) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      prayersTable,
      where: "id = ?",
      whereArgs: [id],
    );

    return result;
  }

  Future<Map<String, dynamic>> getPrayer({int id}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(
      prayersTable,
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.length > 0) return result.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getPrayers() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(
      prayersTable,
    );
    if (result.length > 0) return result;
    return null;
  }
}
