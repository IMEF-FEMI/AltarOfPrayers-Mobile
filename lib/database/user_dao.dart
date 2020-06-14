

import 'package:altar_of_prayers/database/database.dart';
import 'package:altar_of_prayers/models/user.dart';
class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  // User Database functions
  Future<int> saveUser(User user) async {
    final db = await dbProvider.database;
    var result = db.insert(userTABLE, user.toDatabaseJson());
    // to remove later
    // await deleteUser();
    return result;
  }

  //Update User record
  Future<int> updateUser(User user) async {
    final db = await dbProvider.database;

    var result = await db.update(userTABLE, user.toDatabaseJson(),
        where: "id = ?", whereArgs: [user.id]);

    return result;
  }

  //delete User
  Future deleteUser() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      userTABLE,
    );

    return result;
  }

  Future<User> getUser() async {
    final db = await dbProvider.database;

    List<Map<dynamic, dynamic>> result = await db.query(
      userTABLE,
    );


    //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //   String path = join(documentsDirectory.path, "AltarOfPrayers.db");

    // deleteDatabase(path);

    // print(result.first);

    // List<User> user = result.isNotEmpty
    //     ? result.map((item) => User.fromDatabaseJson(item)).toList()
    //     : [];

    // print("user returned ${user.length}");

    if (result.length > 0) {
      return new User.fromDatabaseJson(result.first);
    }
    return null;
  }

  //Get All Todo items
  //Searches if query string was passed
  // Future<List<Todo>> getTodos({List<String> columns, String query}) async {
  //   final db = await dbProvider.database;

  //   List<Map<String, dynamic>> result;
  //   if (query != null) {
  //     if (query.isNotEmpty)
  //       result = await db.query(todoTABLE,
  //           columns: columns,
  //           where: 'description LIKE ?',
  //           whereArgs: ["%$query%"]);
  //   } else {
  //     result = await db.query(todoTABLE, columns: columns);
  //   }

  //   List<Todo> todos = result.isNotEmpty
  //       ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
  //       : [];
  //   return todos;
  // }
}
