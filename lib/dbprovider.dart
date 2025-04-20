import 'dart:io';

// import 'package:bookmgr/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'loggerdef.dart';

class DatabaseProvider {
  DatabaseProvider({required this.databasefile});
  final String databasefile;

  Database? db;
  late String path;

  Future<void> dropTable() async {
    if (db == null) await openDB();
    await db!.rawQuery('DROP TABLE IF EXISTS bookmgr_tbl');
  }

  Future<int> deleteAllRows() async {
    if (db == null) await openDB();
    return await db!.delete('bookmgr_tbl');
  }

  Future<void> query() async {
    if (db == null) await openDB();
    try {
      // id INTEGER,
      // purchased INTEGER,
      // date TEXT,
      // title TEXT,
      // author TEXT,
      // publisher TEXT,
      // genre
      // memo Text,
      var list = await db!.query('bookmgr_tbl', columns: ['id', 'purchased', 'date', 'title', 'author', 'publisher', 'genre', 'memo']);
      for (var l in list) {
        logger.i("DP query() $l");
      }
      logger.i('DP query() $list');
    } on DatabaseException catch (e) {
      logger.e("DP query() error ${e.toString()}");
    }
  }

  Future<void> testDataInsert() async {
    if (db == null) await openDB();
    testDataInserts(db!);

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

  Future<List<String>> listTables() async {
    if (db == null) await openDB();
    logger.i("DP listTables() db : $db");
    var tableNames = (await db!.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: ['table'],
    )).map((row) => row['name'] as String).toList(growable: false)..sort();
    logger.i('listTables() $tableNames');
    return tableNames;
  }

  Future<void> createTables() async {
    if (db == null) await openDB();
    try {
      await db!.execute(
        'CREATE TABLE bookmgr_tbl(id INTEGER, purchased INTEGER, date TEXT, title TEXT, author TEXT, publisher TEXT, genre TEXT, memo Text,PRIMARY KEY(id  AUTOINCREMENT))',
      );

      // await db!.execute(sqlExerciseList);
      // await db!.execute(sqlMuscleTrainingList);
      // await db!.execute(sqlMuscleTrainingDetailsList);
      // await db!.execute(sqlAerobicTrainingList);
      // await db!.execute(sqlBikeTrainingList);
      // await db!.execute(sqlStairsTrainingList);
    } on DatabaseException catch (e) {
      logger.e("createTables() error ${e.toString()}");
    }
    logger.i('DP createTables() executed');
  }

  Future<void> openDB() async {
    db == null
        ? logger.i("DP openDB() called. db : null, databasefile : $databasefile")
        : logger.i("DP openDB() called. db : $db, databasefile : $databasefile");
    try {
      Directory? dbPath;
      if (Platform.isAndroid) {
        dbPath = await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/com.example.mysample/files/bookmgr_database.db
      } else {
        dbPath = await getTemporaryDirectory();
      }

      path = join(dbPath!.path, databasefile);

      logger.i("openDB()  dbPath : $dbPath --- dbPath.runtimeType : ${dbPath.runtimeType} --- databasefile : $databasefile");

      db = await openDatabase(
        path,
        onConfigure: (Database db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        version: 1,
      );
      logger.i("DP openDB() 1 db : $db");
    } on DatabaseException catch (e) {
      logger.e("DP openDB() error ${e.toString()}");
    }
  }

  // Future<int> countAllTask() async {
  //   final db = await instance.dataBase;
  //   var result = await db.rawQuery('SELECT COUNT(*) FROM $myTable');
  //   int count = Sqflite.firstIntValue(result);
  //   return count;
  // }
}

Future<void> testDataInserts(Database db) async {
  // if (db == null) return;
  try {
    await db.transaction((txn) async {
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル1',
        'author': '著者1',
        'publisher': '中公新書',
        'genre': '経済',
        'memo': 'コメント1',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-15',
        'title': 'タイトル2',
        'author': '著者2',
        'publisher': 'ちくま新書',
        'genre': '宗教',
        'memo': 'コメント2',
      });

      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-15',
        'title': 'タイトル3',
        'author': '著者3',
        'publisher': 'ちくま新書',
        'genre': '経済',
        'memo': 'コメント3',
      });

      await txn.insert('bookmgr_tbl', {
        'purchased': 1,
        'date': '2025-04-15',
        'title': 'タイトル4',
        'author': '著者3',
        'publisher': '講談社現代新書',
        'genre': '宗教',
        'memo': 'コメント4',
      });

      await txn.insert('bookmgr_tbl', {
        'purchased': 1,
        'date': '2025-04-15',
        'title': 'タイトル5',
        'author': '著者5',
        'publisher': '岩波新書',
        'genre': '政治',
        'memo': 'コメント5',
      });
    });
  } on DatabaseException catch (e) {
    logger.e("DP testDataInserts() error ${e.toString()}");
  }
}
/*
        'CREATE TABLE bookmgr_tbl(
        id INTEGER, 
        purchased INTEGER, 
        date TEXT, 
        title TEXT, 
        author TEXT,
        publisher TEXT,
        memo Text,
        
        PRIMARY KEY(id  AUTOINCREMENT))',
        */