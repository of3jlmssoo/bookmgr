import 'package:bookmgr/dbprovider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';

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
          await dp.query();
        },
        child: Text('query bookmgr_tbl'),
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
      ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')),
    ],
  ),
);
