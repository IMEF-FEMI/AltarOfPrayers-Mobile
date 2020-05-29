// import 'package:altar_of_prayers/database/database.dart';
// import 'package:altar_of_prayers/models/token.dart';

// class TokensDao {
//   final dbProvider = DatabaseProvider.dbProvider;

//   Future<int> saveToken(Token token) async {
//     final db = await dbProvider.database;
//     var result = db.insert(tokensTABLE, token.toDatabaseJson());
//      // to remove later
//     // await deleteToken();
//     return result;
//   }

//   //Update User record
//   Future<int> updateToken(Token token) async {
//     final db = await dbProvider.database;

//     var result = await db.update(tokensTABLE, token.toDatabaseJson(),
//         where: "id = ?", whereArgs: [token.id]);

//     return result;
//   }

//   //delete User
//   Future deleteToken() async {
//     final db = await dbProvider.database;
//     var result = await db.delete(
//       tokensTABLE,
//     );

//     return result;
//   }

//   Future<Token> getToken() async {
//     final db = await dbProvider.database;

//     List<Map<dynamic, dynamic>> result = await db.query(
//       tokensTABLE,
//     );
    

//     // List<Token> tokens = result.isNotEmpty
//     //     ? result.map((item) => Token.fromDatabaseJson(item)).toList()
//     //     : [];
//     if(result.length > 0){
//       return new Token.fromDatabaseJson(result.first);
//     }
//     return null;
//   }

//   //Get All Todo items
//   //Searches if query string was passed
//   // Future<List<Todo>> getTodos({List<String> columns, String query}) async {
//   //   final db = await dbProvider.database;

//   //   List<Map<String, dynamic>> result;
//   //   if (query != null) {
//   //     if (query.isNotEmpty)
//   //       result = await db.query(todoTABLE,
//   //           columns: columns,
//   //           where: 'description LIKE ?',
//   //           whereArgs: ["%$query%"]);
//   //   } else {
//   //     result = await db.query(todoTABLE, columns: columns);
//   //   }

//   //   List<Todo> todos = result.isNotEmpty
//   //       ? result.map((item) => Todo.fromDatabaseJson(item)).toList()
//   //       : [];
//   //   return todos;
//   // }
// }
