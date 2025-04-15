import 'dart:io';

import 'package:bookmgr/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  DatabaseProvider({required this.databasefile});
  final String databasefile;

  Database? db;
  late String path;

  Future<void> query() async {
    if (db == null) await openDB();
    try {
      var list = await db!.query('exercise_list', columns: ['id', 'date', 'comment']);
      logger.i("DP query() $list");
    } on DatabaseException catch (e) {
      logger.e("DP query() ${e.toString()}");
    }
  }

  Future<void> testDataInsert() async {
    if (db == null) await openDB();
    // testDataInserts(db!);

    // try {
    //   await db!.transaction((txn) async {
    //     await txn.insert('exercise_list', {
    //       'date': '2025/04/02',
    //       'comment': 'テストコメント',
    //     });
    //     // await txn.delete('my_table', where: 'name = ?', whereArgs: ['cat']);
    //   });
    // } on DatabaseException catch (e) {
    //   logger.e("DP inserts() ${e.toString()}");
    // }
  }

  Future<List<String>> getTableNames() async {
    if (db == null) await openDB();
    logger.i("DP getTableNames db : $db");
    var tableNames = (await db!.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: ['table'],
    )).map((row) => row['name'] as String).toList(growable: false)..sort();
    return tableNames;
  }

  Future<void> createTables() async {
    // final String tablename = "dogs";
    if (db == null) await openDB();
    try {
      // await db!.execute('CREATE TABLE exercise_list(id INTEGER, date TEXT, comment TEXT,PRIMARY KEY(id  AUTOINCREMENT))');

      // await db!.execute(sqlExerciseList);
      // await db!.execute(sqlMuscleTrainingList);
      // await db!.execute(sqlMuscleTrainingDetailsList);
      // await db!.execute(sqlAerobicTrainingList);
      // await db!.execute(sqlBikeTrainingList);
      // await db!.execute(sqlStairsTrainingList);
    } on DatabaseException catch (e) {
      logger.e("createTables() error ${e.toString()}");
    }
  }

  Future<void> openDB() async {
    db == null ? logger.i("DP openTable called. db : null path : $databasefile") : logger.i("DP openTable called. db : $db path : $databasefile");
    try {
      logger.i("DP inside try");
      // var databasesPath = await getDatabasesPath();
      // var path = join(databasesPath, dbName);

      // final dbPath = await getDatabasesPath();
      Directory? dbPath = await getExternalStorageDirectory();
      // Future<Directory?> dbPath = await getExternalStorageDirectory();

      // final path = join(dbPath!.path, databasefile);
      path = join(dbPath!.path, databasefile);

      logger.i("openDB()  dbPath : $dbPath");

      db = await openDatabase(
        path,
        // join(await getDatabasesPath(), databasefile),
        // When the database is first created, create a table to store dogs.
        // onCreate: (db, version) {
        //   // Run the CREATE TABLE statement on the database.
        //   return db.execute('CREATE TABLE $dbname(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
        // },
        onConfigure: (Database db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
      logger.i("DP openTable()1 database : $db");
    } on DatabaseException catch (e) {
      logger.e("DP openTable()2 ${e.toString()}");
    }
    logger.i("DP openTable()3 database : $db path : $databasefile");
  }

  // Future<int> countAllTask() async {
  //   final db = await instance.dataBase;
  //   var result = await db.rawQuery('SELECT COUNT(*) FROM $myTable');
  //   int count = Sqflite.firstIntValue(result);
  //   return count;
  // }
}
