import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/routes.dart';
import 'package:bookmgr/testdatacreate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'loggerdef.dart';

// import 'main.dart';

Center lstregbooksBody(BuildContext context, DatabaseProvider dp) => Center(
  child: Column(
    children: [Text('list registered books'), ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen'))],
  ),
);

Center sqlWorkBody(BuildContext context, DatabaseProvider dp) => Center(
  child: Column(
    children: [
      TextButton(onPressed: () async => {await dp.openDB()}, child: Text('Open database')),
      TextButton(onPressed: () async => {await dp.createTables()}, child: Text('Create tables')),
      TextButton(
        onPressed: () async {
          logger.i('List tables ${await dp.listTables()}');
        },
        child: Text('List tables'),
      ),
      TextButton(
        onPressed: () async {
          await dp.testDataInsert();
        },
        child: Text('test data inserts'),
      ),
      TextButton(
        onPressed: () async {
          await dp.dataInsert(purchased: 0, title: "マックス・ウェーバーを読む", author: "仲正昌樹");
        },
        child: Text('test data insert'),
      ),
      TextButton(
        onPressed: () async {
          await dp.selectTable();
        },
        child: Text('select table,bookmgr_tbl'),
      ),
      TextButton(
        onPressed: () async {
          logger.i("${await dp.userquery()}");
        },
        child: Text('selet *'),
      ),
      TextButton(
        onPressed: () async {
          logger.i("${await dp.query2()}");
        },
        child: Text('query2'),
      ),

      TextButton(
        onPressed: () async {
          await dp.querybookname();
        },
        child: Text('query book names only'),
      ),
      TextButton(
        onPressed: () async {
          // var list = await dp.selectByGenre(BookGenre.economy);
          var list = await dp.selectByGenre(genre: BookGenre.values[1]);
          logger.i("select by genre list $list");
        },
        child: Text('select by genre/economy'),
      ),
      TextButton(
        onPressed: () async {
          var list = await dp.rawSelectWhereGenrePurchased(BookGenre.economy.name, '1');
          logger.i("rawSelectWhereTwoConditions $list");
        },
        child: Text('rawSelectWhereTwoConditions'),
      ),
      TextButton(
        onPressed: () async {
          var list = await dp.rawSelectWherePurchasedGenre(BookGenre.economy.name, '0');
          logger.i("rawSelectWherePurchasedGenre caller --> ${list.length} $list");
        },
        child: Text('rawSelectWherePurchasedGenre(new)'),
      ),
      TextButton(
        onPressed: () async {
          await dp.deleteAllRows();
        },
        child: Text('delete all rows from bookmgr_tbl'),
      ),
      TextButton(
        onPressed: () async {
          await dp.dropTable();
        },
        child: Text('drop table bookmgr_tbl'),
      ),
      TextButton(
        onPressed: () async {
          ListBookByGenreRoute(genre: '経済', isChecked: true).push(context);
        },
        child: Text('ListBookByGenreRoute'),
      ),
      TextButton(
        onPressed: () async {
          // 'CREATE TABLE bookmgr_tbl(id INTEGER, purchased INTEGER, date TEXT,
          //  title TEXT, author TEXT, publisher TEXT, genre TEXT, memo Text,
          //  purchasedDate Text, next INTEGER,PRIMARY KEY(id  AUTOINCREMENT))',

          var result = createData();
          logger.i("$result");
          DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
          await dp.clipBoardDataInserts(result);

          // for (int i = 0; i < 100; i++) {
          //   var d = getdate();
          //   var p = getpurchased();

          //   logger.i(
          //     "$p $d ${gettitle()} ${getname()} ${getpublisher()} ${getgenre()} ${p == 1 ? getpurchaseddate(d) : ""} ${p == 0 ? getnext() : 0}",
          //   );
          // }
        },
        child: Text('create test data'),
      ),
      ElevatedButton(onPressed: () => context.push('/'), child: const Text('Go back to the Home screen')),
    ],
  ),
);

List<Map<String, dynamic>> createData() {
  List<Map<String, dynamic>> result = [];
  // {"purchased": 1, "date": "2025-04-14", "title": "タイトル0TITLETAITORU完成かな", "author": "著者0CHOHACHOSHANAME", "publisher": "ブルーバックス", "genre": "経済", "memo": "コメント0", "purchasedDate": "", "next": "0" },

  for (int i = 0; i < 100; i++) {
    var d = getdate();
    var p = getpurchased();

    result.add({
      "purchased": p,
      "date": getdate(),
      "title": gettitle(),
      "author": getname(),
      "publisher": getpublisher(),
      "genre": getgenre(),
      "memo": "コメントドラフト",
      "purchasedDate": p == 1 ? getpurchaseddate(d) : "",
      "next": p == 0 ? getnext() : 0,
    });
  }
  logger.i("createData() $result");
  return result;
}
