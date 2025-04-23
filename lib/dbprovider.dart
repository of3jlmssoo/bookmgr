import 'dart:io';

// import 'package:bookmgr/main.dart';
import 'package:bookmgr/consts.dart';
import 'package:bookmgr/testdatainserts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'loggerdef.dart';

class DatabaseProvider {
  DatabaseProvider({required this.databasefile});
  final String databasefile;

  Database? db;
  late String path;

  Future<List> selectByID({required int id}) async {
    if (db == null) await openDB();

    List list;
    list = await db!.rawQuery('SELECT * FROM bookmgr_tbl WHERE id = ?', [id]);
    return list;
  }

  // List<Map> list = await database.rawQuery('SELECT * FROM Test');
  // TODO: rawquery select by genre and purchased
  // TODO: rename the function
  Future<List<Map>> selectWhere() async {
    if (db == null) await openDB();
    // var list = await db.rawQuery('SELECT * FROM my_table WHERE name IN (?, ?, ?)', ['cat', 'dog', 'fish']);
    List<Map> list = await db!.rawQuery('SELECT * FROM bookmgr_tbl where');
    return list;
  }

  Future<List> selectByGenre({required BookGenre genre}) async {
    if (db == null) await openDB();

    List list;
    if (genre == BookGenre.all) {
      list = await db!.rawQuery('SELECT * FROM bookmgr_tbl');
    } else {
      list = await db!.rawQuery('SELECT * FROM bookmgr_tbl WHERE genre IN (?)', [genre.name]);
    }
    return list;
  }

  Future<void> updateById({
    required int id,
    int purchased = 0,
    String? inputDate,
    required String title,
    String author = "",
    String? publisher,
    String? genre,
    String comment = "",
  }) async {
    if (db == null) await openDB();
    try {
      logger.i("updateById BEFORE inputDate $inputDate publisher $publisher genre $genre");
      inputDate = inputDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
      publisher = publisher ?? Publisher.other.name;
      genre = genre ?? BookGenre.other.name;
      logger.i("updateById AFTER  inputDate $inputDate publisher $publisher genre $genre");

      // 'CREATE TABLE bookmgr_tbl(
      //id INTEGER,
      //purchased INTEGER,
      //date TEXT,
      //title TEXT,
      //author TEXT,
      //publisher TEXT,
      //genre TEXT,
      //memo Text,
      //PRIMARY KEY(id  AUTOINCREMENT))',

      int count = await db!.rawUpdate('UPDATE bookmgr_tbl SET purchased=?, date=?, title=?, author=?, publisher=?, genre=?, memo=? WHERE id=?', [
        purchased,
        inputDate,
        title,
        author,
        publisher,
        genre,
        comment,
        id,
      ]);

      // var count = await db!.update(
      //   'bookmgr_tbl',
      //   {'purchased': '?', 'date': '?', 'title': '?', 'author': '?', 'publisher': '?', 'genre': '?', 'memo': '?'},
      //   where: 'id = ?',
      //   whereArgs: [purchased, inputDate, title, author, publisher, genre, comment, id],
      // );
      logger.i("update by id count $count $purchased $inputDate $title $author $publisher $genre $comment $id");
    } on DatabaseException catch (e) {
      logger.e("DP update by id() error ${e.toString()}");
    }
  }

  Future<void> dataInsert({
    int purchased = 0,
    String inputDate = "",
    required String title,
    String author = "",
    Publisher publisher = Publisher.other,
    BookGenre genre = BookGenre.other,
    String comment = "",
  }) async {
    if (db == null) await openDB();

    if (inputDate == "") inputDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // await testdatainserts(txn);
      // var purchased = 0;
      // var t = 'マックス・ウェーバーを読む';
      // var a = "仲正昌樹";
      // var d = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // var p = Publisher.koudangshinsho.name;
      // var g = BookGenre.philosophy.name;
      // var c = 'こめんと';
      int recordId = await db!.rawInsert(
        'INSERT INTO bookmgr_tbl(purchased, date, title, author, publisher, genre, memo) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [purchased, inputDate, title, author, publisher.name, genre.name, comment],
      );
      logger.i("dataInsert recordID $recordId");
    } on DatabaseException catch (e) {
      logger.e("DP DataInserts() error ${e.toString()}");
    }
  }

  Future<void> deleteById({required int id}) async {
    if (db == null) await openDB();
    var count = await db!.delete('bookmgr_tbl', where: 'id = ?', whereArgs: [id]);
    logger.i("deleteById id $id --- count $count");
  }

  Future<void> dropTable() async {
    if (db == null) await openDB();
    await db!.rawQuery('DROP TABLE IF EXISTS bookmgr_tbl');
  }

  Future<int> deleteAllRows() async {
    if (db == null) await openDB();
    return await db!.delete('bookmgr_tbl');
  }

  Future<List<Widget>> query2() async {
    if (db == null) await openDB();
    List<Widget> result = [];
    try {
      var list = await db!.query('bookmgr_tbl', columns: ['id', 'purchased', 'date', 'title', 'author', 'publisher', 'genre', 'memo']);
      for (var l in list) {
        var str4subtitle = "${l['author']}  ${l["publisher"]}";
        // logger.i("query2() ${l["title"]} --- $str4subtitle");
        result.add(ListTile(title: Text(l["title"].toString()), subtitle: Text(str4subtitle)));
      }
      // logger.i('DP query() $result');
      // logger.i('DP query() ${result[0]}');
      return result;
    } on DatabaseException catch (e) {
      logger.e("DP query() error ${e.toString()}");
    }
    return result;
  }

  Future<List<Map>> query() async {
    if (db == null) await openDB();
    List<Map> list = [];
    try {
      list = await db!.query('bookmgr_tbl', columns: ['id', 'purchased', 'date', 'title', 'author', 'publisher', 'genre', 'memo']);
      for (var l in list) {
        // logger.i("DP query() $l");
      }
      // logger.i('DP query() $list');
      return list;
    } on DatabaseException catch (e) {
      logger.e("DP query() error ${e.toString()}");
    }
    return list;
  }

  Future<void> querybookname() async {
    if (db == null) await openDB();
    try {
      var list = await db!.query('bookmgr_tbl', columns: ['title']);
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
    // db == null
    //     ? logger.i("DP openDB() called. db : null, databasefile : $databasefile")
    //     : logger.i("DP openDB() called. db : $db, databasefile : $databasefile");
    try {
      Directory? dbPath;
      if (Platform.isAndroid) {
        dbPath = await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/com.example.mysample/files/bookmgr_database.db
      } else {
        dbPath = await getTemporaryDirectory();
      }

      path = join(dbPath!.path, databasefile);

      // logger.i("openDB()  dbPath : $dbPath --- dbPath.runtimeType : ${dbPath.runtimeType} --- databasefile : $databasefile");

      db = await openDatabase(
        path,
        onConfigure: (Database db) async {
          await db.execute("PRAGMA foreign_keys = ON");
        },
        version: 1,
      );
      // logger.i("DP openDB() 1 db : $db");
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
      await testdatainserts(txn);
    });
  } on DatabaseException catch (e) {
    logger.e("DP testDataInserts() error ${e.toString()}");
  }
}
