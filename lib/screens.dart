// dart run build_runner watch --delete-conflicting-outputs

import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/sqlwork.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListGenreScreen extends StatelessWidget {
  const ListGenreScreen({this.choice = "0", super.key});
  final String choice;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ListGenreScreen')),
    body: Center(child: ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen'))),
  );
}

class SqlWorkScreen extends StatelessWidget {
  SqlWorkScreen({super.key}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SQL work')), body: sqlWorkBody(context, dp));

  // Center sqlWorkBody(BuildContext context) => Center(child: ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')));
}
