import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final userTABLE = 'user';
final referenceTABLE = 'reference';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "AltarOfPrayers.db");

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $userTABLE ("
        "id INTEGER PRIMARY KEY, "
        "full_name TEXT, "
        "email TEXT, "
        "account_type TEXT, "
        "token TEXT, "
        "staff INTEGER, "
        "is_verified INTEGER, "
        "admin INTEGER) ");

    await database.execute("CREATE TABLE $referenceTABLE ("
        "reference TEXT) ");
  }
}
