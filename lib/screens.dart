// dart run build_runner watch --delete-conflicting-outputs

import 'package:bookmgr/book.dart';
import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/routes.dart';
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
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SQL work')), body: Text("abc"));

  // Center sqlWorkBody(BuildContext context) => Center(child: ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')));
}

class ListAndChangeeRegisteredBook extends StatefulWidget {
  const ListAndChangeeRegisteredBook({required this.book, super.key});
  final Book book;

  @override
  State<ListAndChangeeRegisteredBook> createState() => _ListAndChangeeRegisteredBookState();
}

class _ListAndChangeeRegisteredBookState extends State<ListAndChangeeRegisteredBook> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController genreController = TextEditingController();

  late Book b = widget.book;
  late bool? isChecked = b.purchased == 1;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('List and Change the book')),
    body: SizedBox(width: double.infinity, child: SingleChildScrollView(child: listchangeBook(context))),
  );

  Form listchangeBook(BuildContext context) {
    // isChecked = widget.book.purchased == 1;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: widget.book.name,
            decoration: const InputDecoration(labelText: "書籍名"),
            onSaved: (String? value) {
              b = b.copyWith(name: value!);
              logger.i("list change book name value $value b.name ${b.name}");
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '書籍名を入力してください';
              }
              return null;
            },
          ),
          // Text("名称"),
          // Text(book.name),
          SizedBox(height: 10),
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: widget.book.author ?? "",
            decoration: const InputDecoration(labelText: "著者名"),
            onSaved: (String? value) {
              b = b.copyWith(author: value);
              logger.i("list change book author value $value b.author ${b.author}");
            },
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return '著者名を入力してください';
            //   }
            //   return null;
            // },
          ),
          // Text("著者"),
          // Text(book.author ?? "未登録"),
          SizedBox(height: 10),
          Row(
            children: [
              DropdownMenu<Publisher>(
                width: 130,
                // initialSelection: Publisher.other,
                initialSelection: widget.book.publisher,
                controller: publisherController,
                requestFocusOnTap: true,
                label: const Text('出版社'),
                onSelected: (Publisher? publisher) {
                  b = widget.book.copyWith(publisher: publisher);
                  logger.i("list change book publisher value $publisher b.name ${b.publisher}");
                },

                dropdownMenuEntries: Publisher.entries,
              ),
              SizedBox(width: 20),
              DropdownMenu<BookGenre>(
                width: 140,
                // initialSelection: Publisher.other,
                initialSelection: widget.book.genre,
                controller: genreController,
                requestFocusOnTap: true,
                label: const Text('ジャンル'),
                onSelected: (BookGenre? genre) {
                  b = widget.book.copyWith(genre: genre);
                  logger.i("list change book genre value $genre b.name ${b.genre}");
                },
                dropdownMenuEntries: BookGenre.entries,
              ),
            ],
          ),

          SizedBox(height: 10),
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: widget.book.comment ?? "",
            decoration: const InputDecoration(labelText: "メモ"),
            onSaved: (String? value) {
              b = b.copyWith(comment: value ?? "");
              logger.i("list change book comment value $value b.comment ${b.comment}");
            },
          ),
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              logger.i("list and change the book Checkbox value $value");
              setState(() {
                isChecked = value;
                b = b.copyWith(purchased: value == true ? 1 : 0);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));

                      logger.i('List and Change the book  b $b');
                      var dp = DatabaseProvider(databasefile: databaseName);
                      // TODO: Publisher to its name
                      // TODO: Genre to its name
                      // dp.dataInsert(title: b.name, author: b.author ?? "", purchased: b.purchased ?? 0, comment: b.comment ?? "");
                      dp.updateById(id: b.id!, title: b.name, author: b.author ?? "", purchased: b.purchased ?? 0, comment: b.comment ?? "");
                      nameController.clear();
                      authorController.clear();
                      publisherController.clear();
                      genreController.clear();
                    }
                  },
                  child: const Text('Submit'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    var dp = DatabaseProvider(databasefile: databaseName);
                    dp.deleteById(id: widget.book.id!);
                    HomeRoute().go(context);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
          // Text("メモ"),
          // Text(book.comment == null ? "未登録" : book.comment!),
          ElevatedButton(
            onPressed: () {
              logger.i("List and Change widget.book ${widget.book}");
              logger.i("List and Change b $b");
            },
            child: const Text('Check book'),
          ),
          ElevatedButton(onPressed: () => context.go('/'), child: const Text('Go back to the Home screen')),
        ],
      ),
    );
  }
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
              List list = await dp.selectByID(id: lm[i]["id"]);
              logger.i("ListTile tapped. ${lm[i]["id"]} ${list.runtimeType} $list");
              var p = Publisher.values[Publisher.values.map((id) => id.name).toList().indexOf(lm[i]["publisher"])];
              var g = BookGenre.values[BookGenre.values.map((id) => id.name).toList().indexOf(lm[i]["genre"])];

              Book book = Book(
                id: lm[i]["id"],
                purchased: lm[i]["purchased"],
                date: lm[i]["date"],
                name: lm[i]["title"],
                author: lm[i]["author"],
                publisher: p,
                genre: g,
                comment: lm[i]["memo"],
              );
              // 'CREATE TABLE bookmgr_tbl(id INTEGER, purchased INTEGER, date TEXT, title TEXT, author TEXT, publisher TEXT, genre TEXT, memo Text,PRIMARY KEY(id  AUTOINCREMENT))',
              if (mounted) ListAndChangeRegisteredBookRoute(book).go(context);
              logger.i("ListTile changed?");
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
