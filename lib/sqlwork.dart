import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/routes.dart';
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
        child: Text('table info'),
      ),
      TextButton(
        onPressed: () async {
          await dp.query2();
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
      ElevatedButton(onPressed: () => context.push('/'), child: const Text('Go back to the Home screen')),
    ],
  ),
);
