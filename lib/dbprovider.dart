import 'dart:io';

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

  // DONE: try and timeout
  Future<List> dumpTable() async {
    if (db == null) await openDB();
    logger.i('dumpTable() called');

    List<Map> list = [];

    try {
      list = await db!
          .query("bookmgr_tbl")
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => <Map<String, dynamic>>[
                  {"sorry": "timeout"},
                ],
          );
    } on DatabaseException catch (e) {
      logger.e("dumpTable error ${e.toString()}");
    }
    return list;
  }

  // DONE: try and timeout
  Future<List> selectByID({required int id}) async {
    if (db == null) await openDB();

    List<Map> list = [];
    try {
      list = await db!
          .rawQuery('SELECT * FROM bookmgr_tbl WHERE id = ?', [id])
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => <Map<String, dynamic>>[
                  {"sorry": "timeout"},
                ],
          );
    } on DatabaseException catch (e) {
      logger.e("selectByID error ${e.toString()}");
    }
    return list;
  }

  // 登録済み書籍をリスト
  // 	by publisher
  // 	by genre
  // 購入済み書籍をリスト
  // 	by publisher
  // 	by genre
  // 登録済みと購入済み書籍をリスト
  // 	by publisher
  // 	by genre
  //
  // rawQuery('SELECT * FROM bookmgr_tbl WHERE genre = ? AND purchased=?', [val1, val2])
  Future<List<Map>> rawSelectWherePurchasedGenre(String genre, String purchased) async {
    logger.i("rawSelectWherePurchasedGenre called");
    if (db == null) await openDB();

    List inArgs;
    if (genre == BookGenre.all.name) {
      inArgs = [purchased] + BookGenre.values.getRange(0, BookGenre.entries.length - 1).toList().map((g) => g.name).toList();
    } else {
      inArgs = [purchased] + [genre];
    }
    // DONE: try and timeout
    var result = <Map<dynamic, dynamic>>[];
    try {
      result = await db!
          .query('bookmgr_tbl', where: 'purchased = ? AND genre IN (${List.filled(inArgs.length - 1, '?').join(',')})', whereArgs: inArgs)
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => <Map<String, dynamic>>[
                  {"sorry": "timeout"},
                ],
          );
    } on DatabaseException catch (e) {
      logger.e("rawSelectWherePurchasedGenre error ${e.toString()}");
    }
    logger.i("rawSelectWherePurchasedGenre ->  ${result.length} $result");
    return result;
  }

  // DONE: rawquery select by genre and purchased
  // DONE: rename the function
  Future<List<Map>> rawSelectWhereGenrePurchased(String genre, String purchased) async {
    if (db == null) await openDB();
    try {
      logger.i("rawSelectWhereGenrePurchased in then");
      List<Map> list = await db!
          .rawQuery('SELECT * FROM bookmgr_tbl WHERE genre = ? AND purchased=?', [genre, purchased])
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => <Map<String, dynamic>>[
                  {"sorry": "timeout"},
                ],
          );
      return list;
    } on DatabaseException catch (e) {
      logger.e("rawSelectWhereGenrePurchased error ${e.toString()}");
    }
    logger.e("rawSelectWhereGenrePurchased return null list");
    return [];
  }

  Future<List<Map>> rawSelectWherePurchasedPublisher(String publisher, String purchased) async {
    logger.i("rawSelectWherePurchasedPublisher called");
    if (db == null) await openDB();

    List inArgs;
    if (publisher == Publisher.all.name) {
      inArgs = [purchased] + Publisher.values.getRange(0, Publisher.entries.length - 1).toList().map((g) => g.name).toList();
    } else {
      inArgs = [purchased] + [publisher];
    }
    // DONE: try and timeout
    logger.i("rawSelectWherePurchasedPublisher() inArgs $inArgs");
    var result = <Map<dynamic, dynamic>>[];
    try {
      result = await db!
          .query('bookmgr_tbl', where: 'purchased = ? AND publisher IN (${List.filled(inArgs.length - 1, '?').join(',')})', whereArgs: inArgs)
          .timeout(
            const Duration(seconds: 10),
            onTimeout:
                () => <Map<String, dynamic>>[
                  {"sorry": "timeout"},
                ],
          );
    } on DatabaseException catch (e) {
      logger.e("rawSelectWherePurchasedPublisher error ${e.toString()}");
    }
    logger.i("rawSelectWherePurchasedPublisher ->  ${result.length} $result");
    return result;
  }

  Future<List<Map>> rawSelectWherePublisherPurchased(String publisher, String purchase) async {
    if (db == null) await openDB();
    try {
      List<Map> list = await db!
          .rawQuery('SELECT * FROM bookmgr_tbl WHERE publisher = ? AND purchased=?', [publisher, purchase])
          .timeout(const Duration(seconds: 10));
      return list;
    } on DatabaseException catch (e) {
      logger.e("rawSelectWherePublisherPurchased error ${e.toString()}");
    }
    logger.e("rawSelectWherePublisherPurchased return null list");
    return [];
  }

  Future<List> selectByGenre({required BookGenre genre}) async {
    if (db == null) await openDB();

    List list = [];

    try {
      if (genre == BookGenre.all) {
        list = await db!.rawQuery('SELECT * FROM bookmgr_tbl');
      } else {
        list = await db!.rawQuery('SELECT * FROM bookmgr_tbl WHERE genre IN (?)', [genre.name]);
      }
    } on DatabaseException catch (e) {
      logger.e("selectByGenre error ${e.toString()}");
    }

    logger.e("selectByGenre return null list");
    return list;
  }

  Future<List<Map>> selectByPublisher({required Publisher publisher}) async {
    if (db == null) await openDB();

    List<Map> list = [];

    try {
      if (publisher == Publisher.all) {
        list = await db!.rawQuery('SELECT * FROM bookmgr_tbl');
      } else {
        list = await db!.rawQuery('SELECT * FROM bookmgr_tbl WHERE publisher IN (?)', [publisher.name]);
      }
      return list;
    } on DatabaseException catch (e) {
      logger.e("selectByPublisher error ${e.toString()}");
    }
    logger.e("selectByPublisher return null list");
    return list;
  }

  // SQL WORKでのみ使用
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

  // unused
  Future<List<Map>> userquery() async {
    if (db == null) await openDB();
    List<Map> list = [];
    try {
      list = await db!.query('bookmgr_tbl', columns: ['id', 'purchased', 'date', 'title', 'author', 'publisher', 'genre', 'memo']);
      logger.i("userquery() length ${list.length}");
      return list;
    } on DatabaseException catch (e) {
      logger.e("DP query() error ${e.toString()}");
    }
    logger.i("userquery() length ${list.length}");
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

  Future<void> updateById({
    required int id,
    int purchased = 0,
    String? inputDate,
    required String title,
    String author = "",
    String? publisher,
    String? genre,
    String comment = "",
    String purchasedDate = "",
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

      int count = await db!.rawUpdate(
        'UPDATE bookmgr_tbl SET purchased=?, date=?, title=?, author=?, publisher=?, genre=?, memo=?, purchasedDate=? WHERE id=?',
        [purchased, inputDate, title, author, publisher, genre, comment, purchasedDate, id],
      );

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

    var count = 0;
    try {
      count = await db!.delete('bookmgr_tbl', where: 'id = ?', whereArgs: [id]);
    } on DatabaseException catch (e) {
      logger.e("deleteById error ${e.toString()}");
    }
    logger.i("deleteById id $id --- count $count");
  }

  Future<void> dropTable() async {
    if (db == null) await openDB();
    try {
      await db!.rawQuery('DROP TABLE IF EXISTS bookmgr_tbl');
    } on DatabaseException catch (e) {
      logger.e("dropTable error ${e.toString()}");
    }
  }

  Future<int> deleteAllRows() async {
    if (db == null) await openDB();
    try {
      return await db!.delete('bookmgr_tbl');
    } on DatabaseException catch (e) {
      logger.e("deleteAllRows error ${e.toString()}");
    }

    return 0;
  }

  Future<void> testDataInsert() async {
    if (db == null) await openDB();
    testDataInserts(db!);
  }

  Future<List<String>> listTables() async {
    if (db == null) await openDB();
    logger.i("DP listTables() db : $db");

    List<String> tableNames = [];
    try {
      tableNames = (await db!.query(
        'sqlite_master',
        where: 'type = ?',
        whereArgs: ['table'],
      )).map((row) => row['name'] as String).toList(growable: false)..sort();
      logger.i('listTables() $tableNames');
    } on DatabaseException catch (e) {
      logger.e("DP listTables() error ${e.toString()}");
    }
    logger.i("listTables() ${tableNames.contains("bookmgr_tbl")}");
    return tableNames;
  }

  Future<void> createTables() async {
    if (db == null) await openDB();
    try {
      await db!.execute(
        'CREATE TABLE bookmgr_tbl(id INTEGER, purchased INTEGER, date TEXT, title TEXT, author TEXT, publisher TEXT, genre TEXT, memo Text, purchasedDate Text,PRIMARY KEY(id  AUTOINCREMENT))',
      );
    } on DatabaseException catch (e) {
      logger.e("createTables() error ${e.toString()}");
    }
    logger.i('DP createTables() executed');
  }

  Future<void> openDB() async {
    try {
      Directory? dbPath;
      if (Platform.isAndroid) {
        dbPath = await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/com.example.mysample/files/bookmgr_database.db
      } else {
        dbPath = await getTemporaryDirectory();
      }

      path = join(dbPath!.path, databasefile);

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
