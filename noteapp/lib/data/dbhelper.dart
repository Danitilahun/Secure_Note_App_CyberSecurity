// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/note_model.dart';

// class DbHelper {
//   final int version = 1;
//   Database? db;

//   static final DbHelper _dbHelper = DbHelper._internal();
//   DbHelper._internal();
//   factory DbHelper() {
//     return _dbHelper;
//   }

//   Future<Database?> openDb() async {
//     if (db == null) {
//       db = await openDatabase(join(await getDatabasesPath(), 'note.db'),
//           onCreate: (database, version) {
//         database.execute(
//             'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT,content TEXT)');
//       }, version: version);
//     }
//     return db;
//   }

//   Future testDB() async {
//     db = await openDb();
//     await db?.execute('INSERT INTO notes VALUES (0, "Fruit", "2")');

//     List<Map<String, Object?>>? lists =
//         await db?.rawQuery('select * from notes');
//     print(lists?[0].toString());
//   }

//   Future<int?> insertList(Note list) async {
//     int? id = await this.db?.insert(
//           'notes',
//           list.toMap(),
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//     return id;
//   }

//   Future<List<Note>?> getLists() async {
//     final List<Map<String, Object?>>? maps = await this.db?.query('notes');
//     return List.generate(maps!.length, (i) {
//       return Note(
//         maps![i]['id'] as int?,
//         maps![i]['title'] as String?,
//         maps![i]['content'] as String?,
//       );
//     });
//   }

//   Future<int> deleteList(Note note) async {
//     int result =
//         await db!.delete("notes", where: "id = ?", whereArgs: [note.id]);
//     return result;
//   }
// }

// import 'dart:typed_data';
// import 'package:noteapp/data/encryptionHelper.dart';
// import 'package:noteapp/utils/config.dart';
// import 'package:path/path.dart';
// import '../models/note_model.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';
// import 'package:sqflite_sqlcipher/sql.dart';

// class DbHelper {
//   final int version = 1;
//   Database? db;

//   static final DbHelper _dbHelper = DbHelper._internal();
//   DbHelper._internal();
//   factory DbHelper() {
//     return _dbHelper;
//   }

//   Future<Database?> openDb() async {
//     if (db == null) {
//       final databasesPath = await getDatabasesPath();
//       final path = join(databasesPath, 'notesss.db');

//       // Initialize SQLCipher with the encryption key
//       await openDatabase(
//         path,
//         // password: Config.dbPassword,
//         onCreate: (db, version) {
//           db.execute(
//             'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)',
//           );
//         },
//         onConfigure: (db) {
//           db.execute('PRAGMA cipher_default_use_hmac = off');
//         },
//         version: version,
//       );

//       db = await openDatabase(
//         path,
//         // password: Config.dbPassword,
//       );
//     }
//     return db;
//   }

//   Future testDB() async {
//     db = await openDb();
//     await db?.execute('INSERT INTO notes VALUES (0, "Fruit", "2")');

//     List<Map<String, Object?>>? lists =
//         await db?.rawQuery('SELECT * FROM notes');
//     print(lists?[0].toString());
//   }

//   Future<int?> insertList(Note list) async {
//     final encryptedTitle =
//         EncryptionHelper.encrypt(list.title!, _generateKey());
//     final encryptedContent =
//         EncryptionHelper.encrypt(list.content!, _generateKey());

//     int? id = await db?.insert(
//       'notes',
//       {
//         'title': encryptedTitle,
//         'content': encryptedContent,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print(id);
//     return id;
//   }

//   Future<List<Note>?> getLists() async {
//     final List<Map<String, Object?>>? maps = await db?.query('notes');
//     return List.generate(maps!.length, (i) {
//       final encryptedTitle = maps[i]['title'] as Uint8List?;
//       final encryptedContent = maps[i]['content'] as Uint8List?;

//       // print('Encrypted Title: ${encryptedTitle.toString()}');
//       // print('Encrypted Content: ${encryptedContent.toString()}');

//       final decryptedTitle =
//           EncryptionHelper.decrypt(encryptedTitle!, _generateKey());
//       final decryptedContent =
//           EncryptionHelper.decrypt(encryptedContent!, _generateKey());

//       return Note(
//         maps[i]['id'] as int?,
//         decryptedTitle,
//         decryptedContent,
//       );
//     });
//   }

//   Future<int> updateList(Note list) async {
//     final encryptedTitle =
//         EncryptionHelper.encrypt(list.title!, _generateKey());
//     final encryptedContent =
//         EncryptionHelper.encrypt(list.content!, _generateKey());

//     int rowsAffected = await db?.update(
//           'notes',
//           {
//             'title': encryptedTitle,
//             'content': encryptedContent,
//           },
//           where: 'id = ?',
//           whereArgs: [list.id],
//         ) ??
//         0;
//     return rowsAffected ?? 0;
//   }

//   Future<int> deleteList(Note note) async {
//     int result =
//         await db!.delete('notes', where: 'id = ?', whereArgs: [note.id]);
//     return result;
//   }

//   Uint8List _generateKey() {
//     final key = EncryptionHelper.generateKey(Config.dbPassword);
//     return Uint8List.fromList(key);
//   }
// }

// import 'dart:typed_data';
// import 'package:noteapp/data/encryptionHelper.dart';
// import 'package:noteapp/utils/config.dart';
// import 'package:path/path.dart';
// import '../models/note_model.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';
// import 'package:sqflite_sqlcipher/sql.dart';
// import 'package:bcrypt/bcrypt.dart';

// class DbHelper {
//   final int version = 1;
//   Database? db;

//   static final DbHelper _dbHelper = DbHelper._internal();
//   DbHelper._internal();
//   factory DbHelper() {
//     return _dbHelper;
//   }

//   Future<Database?> openDb() async {
//     if (db == null) {
//       final databasesPath = await getDatabasesPath();
//       final path = join(databasesPath, 'notessss.db');

//       // Initialize SQLCipher with the encryption key
//       await openDatabase(
//         path,
//         // password: Config.dbPassword,
//         onCreate: (db, version) {
//           db.execute(
//             'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
//           );
//           db.execute(
//             'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT)',
//           );
//         },
//         onConfigure: (db) {
//           db.execute('PRAGMA cipher_default_use_hmac = off');
//         },
//         version: version,
//       );

//       db = await openDatabase(
//         path,
//         // password: Config.dbPassword,
//       );
//     }
//     return db;
//   }

//   // User Registration
//   Future<bool> registerUser(
//       String username, String email, String password) async {
//     final hashedPassword = await hashPassword(password);
//     print(hashedPassword);
//     int? id = await db?.insert(
//       'users',
//       {'username': username, 'email': email, 'password': hashedPassword},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print(id);
//     return id != null;
//   }

//   // User Login
//   Future<bool> loginUser(String email, String password) async {
//     final List<Map<String, Object?>>? result = await db?.query(
//       'users',
//       where: 'email = ?',
//       whereArgs: [email],
//     );

//     if (result != null && result.isNotEmpty) {
//       final storedPassword = result[0]['password'] as String;
//       return await verifyPassword(password, storedPassword);
//     }

//     return false;
//   }

//   // User Logout (Assuming a simple boolean flag in this case)
//   Future<bool> logoutUser() async {
//     // Perform necessary logout operations
//     return true;
//   }

//   // Hash a password using bcrypt
//   Future<String> hashPassword(String password) async {
//     final salt = await BCrypt.gensalt();
//     final hash = await BCrypt.hashpw(password, salt);
//     return hash;
//   }

//   // Verify a password against a stored hash
//   Future<bool> verifyPassword(String password, String storedHash) async {
//     return await BCrypt.checkpw(password, storedHash);
//   }

//   Future<int?> insertList(Note list) async {
//     final encryptedTitle =
//         EncryptionHelper.encrypt(list.title!, _generateKey());
//     final encryptedContent =
//         EncryptionHelper.encrypt(list.content!, _generateKey());

//     int? id = await db?.insert(
//       'notes',
//       {
//         'title': encryptedTitle,
//         'content': encryptedContent,
//       },
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print(id);
//     return id;
//   }

//   Future<List<Note>?> getLists() async {
//     final List<Map<String, Object?>>? maps = await db?.query('notes');
//     return List.generate(maps!.length, (i) {
//       final encryptedTitle = maps[i]['title'] as Uint8List?;
//       final encryptedContent = maps[i]['content'] as Uint8List?;

//       // print('Encrypted Title: ${encryptedTitle.toString()}');
//       // print('Encrypted Content: ${encryptedContent.toString()}');

//       final decryptedTitle =
//           EncryptionHelper.decrypt(encryptedTitle!, _generateKey());
//       final decryptedContent =
//           EncryptionHelper.decrypt(encryptedContent!, _generateKey());

//       return Note(
//         maps[i]['id'] as int?,
//         decryptedTitle,
//         decryptedContent,
//       );
//     });
//   }

//   Future<int> updateList(Note list) async {
//     final encryptedTitle =
//         EncryptionHelper.encrypt(list.title!, _generateKey());
//     final encryptedContent =
//         EncryptionHelper.encrypt(list.content!, _generateKey());

//     int rowsAffected = await db?.update(
//           'notes',
//           {
//             'title': encryptedTitle,
//             'content': encryptedContent,
//           },
//           where: 'id = ?',
//           whereArgs: [list.id],
//         ) ??
//         0;
//     return rowsAffected ?? 0;
//   }

//   Future<int> deleteList(Note note) async {
//     int result =
//         await db!.delete('notes', where: 'id = ?', whereArgs: [note.id]);
//     return result;
//   }

//   Uint8List _generateKey() {
//     final key = EncryptionHelper.generateKey(Config.dbPassword);
//     return Uint8List.fromList(key);
//   }
// }

import 'dart:typed_data';
import 'package:noteapp/data/encryptionHelper.dart';
import 'package:noteapp/models/insertResult.dart';
import 'package:noteapp/utils/config.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher/sql.dart';
import 'package:bcrypt/bcrypt.dart';

class DbHelper {
  final int version = 1;
  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database?> openDb() async {
    if (db == null) {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'notesapp.db');

      // Initialize SQLCipher with the encryption key
      await openDatabase(
        path,
        // password: Config.dbPassword,
        onCreate: (db, version) {
          db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, email TEXT, password TEXT)',
          );
          db.execute(
            'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, content TEXT, userId INTEGER, FOREIGN KEY (userId) REFERENCES users(id))',
          );
        },
        onConfigure: (db) {
          db.execute('PRAGMA cipher_default_use_hmac = off');
        },
        version: version,
      );

      db = await openDatabase(
        path,
        // password: Config.dbPassword,
      );
    }
    return db;
  }

  // User Registration
  Future<InsertResult?> registerUser(
      String username, String email, String password) async {
    final hashedPassword = await hashPassword(password);
    print(hashedPassword);
    int? id = await db?.insert(
      'users',
      {'username': username, 'email': email, 'password': hashedPassword},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(id);
    return InsertResult(id, email);
  }

  // User Login
  Future<InsertResult?> loginUser(String email, String password) async {
    print("here");
    final List<Map<String, Object?>>? result = await db?.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    print(result);
    if (result != null && result.isNotEmpty) {
      final storedPassword = result[0]['password'] as String;
      final userId = result[0]['id'] as int?;
      final passwordVerified = await verifyPassword(password, storedPassword);

      if (passwordVerified) {
        return InsertResult(userId, email);
      }
    }

    return null;
  }

  // User Logout (Assuming a simple boolean flag in this case)
  Future<bool> logoutUser() async {
    // Perform necessary logout operations
    return true;
  }

  // Hash a password using bcrypt
  Future<String> hashPassword(String password) async {
    final salt = await BCrypt.gensalt();
    final hash = await BCrypt.hashpw(password, salt);
    return hash;
  }

  // Verify a password against a stored hash
  Future<bool> verifyPassword(String password, String storedHash) async {
    return await BCrypt.checkpw(password, storedHash);
  }

  Future<int?> insertList(Note list, int userId) async {
    final encryptedTitle =
        EncryptionHelper.encrypt(list.title!, _generateKey());
    final encryptedContent =
        EncryptionHelper.encrypt(list.content!, _generateKey());

    int? id = await db?.insert(
      'notes',
      {
        'title': encryptedTitle,
        'content': encryptedContent,
        'userId': userId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(id);
    return id;
  }

  Future<List<Note>?> getLists({required int userId}) async {
    final List<Map<String, Object?>>? maps = await db?.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps!.length, (i) {
      final encryptedTitle = maps[i]['title'] as Uint8List?;
      final encryptedContent = maps[i]['content'] as Uint8List?;

      final decryptedTitle =
          EncryptionHelper.decrypt(encryptedTitle!, _generateKey());
      final decryptedContent =
          EncryptionHelper.decrypt(encryptedContent!, _generateKey());

      return Note(
        id: maps[i]['id'] as int?,
        title: decryptedTitle,
        content: decryptedContent,
        userId: maps[i]['userId'] as int?, // Include userId
      );
    });
  }

  Future<int> updateList(Note list) async {
    final encryptedTitle =
        EncryptionHelper.encrypt(list.title!, _generateKey());
    final encryptedContent =
        EncryptionHelper.encrypt(list.content!, _generateKey());

    int rowsAffected = await db?.update(
          'notes',
          {
            'title': encryptedTitle,
            'content': encryptedContent,
          },
          where: 'id = ?',
          whereArgs: [list.id],
        ) ??
        0;
    return rowsAffected ?? 0;
  }

  Future<int> deleteList(Note note) async {
    int result =
        await db!.delete('notes', where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  Uint8List _generateKey() {
    final key = EncryptionHelper.generateKey(Config.dbPassword);
    return Uint8List.fromList(key);
  }

  Future<bool> changePassword(
      int userId, String currentPassword, String newPassword) async {
    final List<Map<String, Object?>>? result = await db?.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result != null && result.isNotEmpty) {
      final storedPassword = result[0]['password'] as String;
      final passwordVerified =
          await verifyPassword(currentPassword, storedPassword);

      if (passwordVerified) {
        final hashedPassword = await hashPassword(newPassword);

        int rowsAffected = await db?.update(
              'users',
              {'password': hashedPassword},
              where: 'id = ?',
              whereArgs: [userId],
            ) ??
            0;

        return rowsAffected > 0;
      }
    }

    return false;
  }

  Future<bool> changeEmail(int userId, String newEmail) async {
    int rowsAffected = await db?.update(
          'users',
          {'email': newEmail},
          where: 'id = ?',
          whereArgs: [userId],
        ) ??
        0;

    return rowsAffected > 0;
  }
}
