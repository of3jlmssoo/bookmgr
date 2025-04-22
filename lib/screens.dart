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
// DONE: listview from SQL select
// TODO: update a record "purchased"
// TODO: update a record "comment"
// DONE genreID to BookGenre enum
class ListRegisteredBooksByGenreScreen extends StatefulWidget {
  ListRegisteredBooksByGenreScreen({super.key, required this.genreID}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int genreID;
  // final List<Map<dynamic, dynamic>> list;

  @override
  State<ListRegisteredBooksByGenreScreen> createState() => _ListRegisteredBooksByGenreScreenState();
}

class _ListRegisteredBooksByGenreScreenState extends State<ListRegisteredBooksByGenreScreen> {
  _ListRegisteredBooksByGenreScreenState();
  // final int genreID;
  Future<List<Widget>> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await listBooks3(genreID: widget.genreID);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('登録済み書籍一覧 ${BookGenre.values[widget.genreID].name}')),
    // body: lstregbooksBody(context, dp),
    body: FutureBuilder<List<Widget>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? categories = snapshot.data;
          logger.i("FutureBuilder categories -> catgories $categories --- snapshot $snapshot");
          return ListView.builder(
            itemCount: categories!.length,
            itemBuilder: (context, index) {
              return categories[index];
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
        }
        return SizedBox(width: 60, height: 60, child: CircularProgressIndicator());
      },
    ),
    // body: Column(
    //   children: [
    //     LimitedBox(
    //       maxHeight: 500,
    //       child: ListView(
    //         // shrinkWrap: true,
    //         padding: const EdgeInsets.all(8),
    //         children: listBooks(),
    //       ),
    //     ),
    //     ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')),
    //   ],
    // ),
  );

  Future<List<Widget>> listBooks3({required int genreID}) async {
    logger.i("listBooks3() called");

    if (true) {
      logger.i("listBooks3() then");
      DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
      // List<Map> lm = await dp.query();
      List lm = await dp.selectByGenre(genre: BookGenre.values[genreID]);
      logger.i("listBooks3() lm.length ${lm.length} lm $lm");
      List<Widget> lw = List.empty(growable: true);
      for (int i = 0; i < lm.length; i++) {
        // logger.i("listBooks3() ${lm[i]['id']} --- ${lm[i]['title']} --- ${lm[i]['author']}");
        // logger.i("listBooks3() i=$i --- $lw");
        var apg = "${lm[i]['id'].toString()} ${lm[i]['author']} ${lm[i]['publisher']} ${lm[i]['genre']}";
        lw.add(
          ListTile(
            title: Text(lm[i]['title']),
            subtitle: Text(apg),
            onTap: () async {
              // TODO: display and change the entry
              logger.i("ListTile tapped. ${lm[i]["id"]} ${await dp.selectByID(id: lm[i]["id"])}");
            },
          ),
        );
        logger.i("listBooks3() i=$i --- $lw");
      }
      return lw;
    } else {
      List<Widget> result = [
        ListTile(
          title: const Text('蜘蛛女のキス'),
          subtitle: const Text('プイグ'),
          trailing: PopupMenuButton<ListTileTitleAlignment>(
            onSelected: (ListTileTitleAlignment? value) {
              // titleAlignment = value;
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<ListTileTitleAlignment>>[
                  PopupMenuItem<ListTileTitleAlignment>(
                    onTap: () {
                      logger.i("add comment");
                    },
                    child: Text('コメント追加'),
                  ),
                  PopupMenuItem<ListTileTitleAlignment>(
                    onTap: () {
                      logger.i("purcahsed");
                    },
                    child: Text('購入'),
                  ),
                  PopupMenuItem<ListTileTitleAlignment>(
                    onTap: () {
                      logger.i("delete");
                    },
                    child: Text('削除'),
                  ),
                  // const PopupMenuItem<ListTileTitleAlignment>(value: ListTileTitleAlignment.top, child: Text('削除')),
                ],
          ),
        ),
      ];
      return result;
    }
  }

  List<Widget> listBooks() {
    // ListTileTitleAlignment? titleAlignment;
    // var list = await widget.dp.query();
    // logger.i("listBooks called --- $list");
    return <Widget>[
      ListTile(
        // leading: IconButton(
        //   onPressed: () {
        //     logger.i("IconButton pressed");
        //   },
        //   icon: Icon(Icons.favorite_rounded),
        // ),
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
      ListTile(
        title: const Text('蜘蛛女のキス'),
        subtitle: const Text('プイグ'),
        trailing: PopupMenuButton<ListTileTitleAlignment>(
          onSelected: (ListTileTitleAlignment? value) {
            // titleAlignment = value;
          },
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<ListTileTitleAlignment>>[
                PopupMenuItem<ListTileTitleAlignment>(
                  onTap: () {
                    logger.i("add comment");
                  },
                  child: Text('コメント追加'),
                ),
                PopupMenuItem<ListTileTitleAlignment>(
                  onTap: () {
                    logger.i("purcahsed");
                  },
                  child: Text('購入'),
                ),
                PopupMenuItem<ListTileTitleAlignment>(
                  onTap: () {
                    logger.i("delete");
                  },
                  child: Text('削除'),
                ),
              ],
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
