// dart run build_runner watch --delete-conflicting-outputs

import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/sqlwork.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'loggerdef.dart';

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

// DONE: accept parameters
// TODO: listview from SQL select
// TODO: update a record "purchased"
// TODO: update a record "comment"

class ListRegisteredBooksByGenreScreen extends StatelessWidget {
  ListRegisteredBooksByGenreScreen({super.key, required this.genreID}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int genreID;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('登録済み書籍一覧 ${BookGenre.values[genreID].name}')),
    // body: lstregbooksBody(context, dp),
    body: Column(
      children: [
        LimitedBox(
          maxHeight: 500,
          child: ListView(
            // shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            children: listBooks,
          ),
        ),
        ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')),
      ],
    ),
  );

  List<Widget> get listBooks {
    logger.i("listBooks called");
    return <Widget>[
      ListTile(
        // leading: CircleAvatar(child: Text('A')),
        title: Text('マックス・ウェーバーを読む'),
        subtitle: Text('仲正昌樹  講談社現代新書'),
        // trailing: Icon(Icons.favorite_rounded),
        trailing: IconButton(
          onPressed: () {
            logger.i("IconButton pressed");
          },
          icon: Icon(Icons.favorite_rounded),
        ),
      ),
      ListTile(
        // leading: CircleAvatar(child: Text('A')),
        title: Text('功利主義'),
        subtitle: Text('岩波文庫 白 116-11'),
        // trailing: Icon(Icons.favorite_rounded),
        trailing: IconButton(
          onPressed: () {
            logger.i("IconButton pressed");
          },
          icon: Icon(Icons.favorite_rounded),
        ),
      ),
    ];
  }
}

// TODO: set ListRegisteredBooksByPublisherScreen to routes.dart
class ListRegisteredBooksByPublisherScreen extends StatelessWidget {
  ListRegisteredBooksByPublisherScreen({super.key, required this.pulisherID}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int pulisherID;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('登録済み書籍一覧 ${Publisher.values[pulisherID].name}')),
    body: lstregbooksBody(context, dp),
  );
}
