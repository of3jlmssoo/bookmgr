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
      // await txn.insert('bookmgr_tbl', {
      //   'purchased': 0,
      //   'date': '2025-04-14',
      //   'title': 'タイトル1',
      //   'author': '著者1',
      //   'publisher': '中公新書',
      //   'genre': '経済',
      //   'memo': 'コメント1',
      // });
      // await txn.insert('bookmgr_tbl', {
      //   'purchased': 0,
      //   'date': '2025-04-15',
      //   'title': 'タイトル2',
      //   'author': '著者2',
      //   'publisher': 'ちくま新書',
      //   'genre': '宗教',
      //   'memo': 'コメント2',
      // });

      // await txn.insert('bookmgr_tbl', {
      //   'purchased': 0,
      //   'date': '2025-04-15',
      //   'title': 'タイトル3',
      //   'author': '著者3',
      //   'publisher': 'ちくま新書',
      //   'genre': '経済',
      //   'memo': 'コメント3',
      // });

      // await txn.insert('bookmgr_tbl', {
      //   'purchased': 1,
      //   'date': '2025-04-15',
      //   'title': 'タイトル4',
      //   'author': '著者3',
      //   'publisher': '講談社現代新書',
      //   'genre': '宗教',
      //   'memo': 'コメント4',
      // });

      // await txn.insert('bookmgr_tbl', {
      //   'purchased': 1,
      //   'date': '2025-04-15',
      //   'title': 'タイトル5',
      //   'author': '著者5',
      //   'publisher': '岩波新書',
      //   'genre': '政治',
      //   'memo': 'コメント5',
      // });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル0',
        'author': '著者0',
        'publisher': 'ブルーバックス',
        'genre': '経済',
        'memo': 'コメント0',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル1',
        'author': '著者1',
        'publisher': '講談社現代新書',
        'genre': '宗教',
        'memo': 'コメント1',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル2',
        'author': '著者2',
        'publisher': '講談社学術文庫',
        'genre': 'IT',
        'memo': 'コメント2',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル3',
        'author': '著者3',
        'publisher': '岩波新書',
        'genre': '社会',
        'memo': 'コメント3',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル4',
        'author': '著者4',
        'publisher': '岩波ジュニア新書',
        'genre': '政治',
        'memo': 'コメント4',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル5',
        'author': '著者5',
        'publisher': '河出書房新社',
        'genre': 'その他',
        'memo': 'コメント5',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル6',
        'author': '著者6',
        'publisher': '岩波現代文庫',
        'genre': '全て',
        'memo': 'コメント6',
      });

      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル7',
        'author': '著者7',
        'publisher': 'ちくま新書',
        'genre': 'IT',
        'memo': 'コメント7',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル8',
        'author': '著者8',
        'publisher': 'ちくまプリマー新書',
        'genre': '宗教',
        'memo': 'コメント8',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル9',
        'author': '著者9',
        'publisher': 'ちくま学芸文庫',
        'genre': '宗教',
        'memo': 'コメント9',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル10',
        'author': '著者10',
        'publisher': '早川文庫',
        'genre': 'IT',
        'memo': 'コメント10',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル11',
        'author': '著者11',
        'publisher': 'PHP新書',
        'genre': '宗教',
        'memo': 'コメント11',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル12',
        'author': '著者12',
        'publisher': '朝日新著',
        'genre': '経済',
        'memo': 'コメント12',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル13',
        'author': '著者13',
        'publisher': '中公新書',
        'genre': '経済',
        'memo': 'コメント13',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル14',
        'author': '著者14',
        'publisher': '講談社学術文庫',
        'genre': '宗教',
        'memo': 'コメント14',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル15',
        'author': '著者15',
        'publisher': '講談社現代新書',
        'genre': 'その他',
        'memo': 'コメント15',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル16',
        'author': '著者16',
        'publisher': '講談社+α新書',
        'genre': '宗教',
        'memo': 'コメント16',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル17',
        'author': '著者17',
        'publisher': 'ブルーバックス',
        'genre': '社会',
        'memo': 'コメント17',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル18',
        'author': '著者18',
        'publisher': '光文社新書',
        'genre': '社会',
        'memo': 'コメント18',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル19',
        'author': '著者19',
        'publisher': '新潮新書',
        'genre': '宗教',
        'memo': 'コメント19',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル20',
        'author': '著者20',
        'publisher': '河出書房新社',
        'genre': '政治',
        'memo': 'コメント20',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル21',
        'author': '著者21',
        'publisher': '集英社新書',
        'genre': '経済',
        'memo': 'コメント21',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル22',
        'author': '著者22',
        'publisher': '岩波現代文庫',
        'genre': 'その他',
        'memo': 'コメント22',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル23',
        'author': '著者23',
        'publisher': '岩波文庫',
        'genre': '社会',
        'memo': 'コメント23',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル24',
        'author': '著者24',
        'publisher': '岩波新書',
        'genre': '社会',
        'memo': 'コメント24',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル25',
        'author': '著者25',
        'publisher': '岩波ジュニア新書',
        'genre': '経済',
        'memo': 'コメント25',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル26',
        'author': '著者26',
        'publisher': '早稲田新書',
        'genre': 'その他',
        'memo': 'コメント26',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル0',
        'author': '著者0',
        'publisher': '扶桑社新書',
        'genre': '政治',
        'memo': 'コメント0',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル1',
        'author': '著者1',
        'publisher': '幻冬舎新書',
        'genre': 'その他',
        'memo': 'コメント1',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル2',
        'author': '著者2',
        'publisher': '祥伝社新書',
        'genre': 'その他',
        'memo': 'コメント2',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル3',
        'author': '著者3',
        'publisher': 'その他',
        'genre': '社会',
        'memo': 'コメント3',
      });
      await txn.insert('bookmgr_tbl', {
        'purchased': 0,
        'date': '2025-04-14',
        'title': 'タイトル4',
        'author': '著者4',
        'publisher': '全て',
        'genre': 'その他',
        'memo': 'コメント4',
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