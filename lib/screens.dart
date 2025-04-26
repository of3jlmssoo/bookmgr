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
  // Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SQL work')), body: Text("abc"));
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('SQL x 2 work')), body: sqlWorkBody(context, dp));
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
                  // b = widget.book.copyWith(publisher: publisher);
                  b = b.copyWith(publisher: publisher);
                  logger.i("list change book publisher value $publisher b.name ${b.publisher}");
                },

                dropdownMenuEntries: Publisher.entries.getRange(0, Publisher.entries.length - 1).toList(),
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
                  b = b.copyWith(genre: genre);
                  logger.i("list change book genre value $genre b.name ${b.genre}");
                },
                dropdownMenuEntries: BookGenre.entries.getRange(0, BookGenre.entries.length - 1).toList(),
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
          // DONE: add height
          // DONE: add row 購入済み and Checkbox
          SizedBox(height: 10),
          Row(
            children: [
              Text("購入済"),
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
            ],
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
                      // DONE: Publisher to its name
                      // DONE: Genre to its name
                      // dp.dataInsert(title: b.name, author: b.author ?? "", purchased: b.purchased ?? 0, comment: b.comment ?? "");

                      // Future<void> updateById({
                      //   required int id,
                      //   int purchased = 0,
                      //   String? inputDate,
                      //   required String title,
                      //   String author = "",
                      //   String? publisher,
                      //   String? genre,
                      //   String comment = "",

                      dp.updateById(
                        id: b.id!,
                        purchased: b.purchased ?? 0,
                        inputDate: b.date ?? "",
                        title: b.name,
                        author: b.author ?? "",
                        publisher: b.publisher?.name ?? "",
                        genre: b.genre?.name ?? "",
                        comment: b.comment ?? "",
                      );
                      nameController.clear();
                      authorController.clear();
                      publisherController.clear();
                      genreController.clear();
                    }
                    HomeRoute().go(context);
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
// DONE: update a record "purchased"
// DONE: update a record "comment"
// DONE genreID to BookGenre enum
class ListRegisteredBooksByGenreScreen extends StatefulWidget {
  ListRegisteredBooksByGenreScreen({super.key, required this.genreID, required this.isChecked}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int genreID;
  final bool isChecked;
  // final List<Map<dynamic, dynamic>> list;

  @override
  State<ListRegisteredBooksByGenreScreen> createState() => _ListRegisteredBooksByGenreScreenState();
}

class _ListRegisteredBooksByGenreScreenState extends State<ListRegisteredBooksByGenreScreen> {
  _ListRegisteredBooksByGenreScreenState();
  // final int genreID;
  Future<List<Widget>> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await listBooks3(genreID: widget.genreID, isChecked: widget.isChecked);
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
  );

  Future<List<Widget>> listBooks3({required int genreID, required bool isChecked}) async {
    logger.i("listBooks3() called");

    // TODO: if genreID == 全て
    if (genreID == BookGenre.all.index) {
      // TODO: call dp.
    } else {
      DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
      // List<Map> lm = await dp.query();
      // List lm = await dp.selectByGenre(genre: BookGenre.values[genreID]);
      // lm = await dp.rawSelectWhereGenrePurchased(BookGenre.values[genreID].name, '0');
      List lm =
          isChecked == true
              ? await dp.selectByGenre(genre: BookGenre.values[genreID])
              : await dp.rawSelectWhereGenrePurchased(BookGenre.values[genreID].name, '0');
      logger.i("listBooks3() lm.length ${lm.length} lm $lm");
      List<Widget> lw = List.empty(growable: true);
      for (int i = 0; i < lm.length; i++) {
        // logger.i("listBooks3() ${lm[i]['id']} --- ${lm[i]['title']} --- ${lm[i]['author']}");
        // logger.i("listBooks3() i=$i --- $lw");
        var apg = "${lm[i]['id'].toString()} ${lm[i]['author']} ${lm[i]['publisher']} ${lm[i]['genre']} ${lm[i]['purchased'] == 0 ? "" : "購入済み"}";
        lw.add(
          ListTile(
            title: Text(lm[i]['title']),
            subtitle: Text(apg),
            onTap: () async {
              // DONE: display and change the entry
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
    }
    return [ListTile(title: Text("Sorry"), subtitle: Text("unable provide"))];
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

// DONE: set ListRegisteredBooksByPublisherScreen to routes.dart
class ListRegisteredBooksByPublisherScreen extends StatefulWidget {
  ListRegisteredBooksByPublisherScreen({super.key, required this.pulisherID, required this.isChecked})
    : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int pulisherID;
  final bool isChecked;

  @override
  State<ListRegisteredBooksByPublisherScreen> createState() => _ListRegisteredBooksByPublisherScreenState();
}

class _ListRegisteredBooksByPublisherScreenState extends State<ListRegisteredBooksByPublisherScreen> {
  _ListRegisteredBooksByPublisherScreenState();
  Future<List<Widget>> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await listBooks4(publisherID: widget.pulisherID, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('登録済み書籍一覧 ${Publisher.values[widget.pulisherID].name}'),
    ),
    // body: lstregbooksBody(context, widget.dp),
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
  );

  Future<List<Widget>> listBooks4({required int publisherID, required bool isChecked}) async {
    logger.i("listBooks4() called -- publisherID $publisherID --- isChecked $isChecked");

    if (true) {
      logger.i("listBooks4() then");
      DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
      // List<Map> lm = await dp.query();
      // List lm = await dp.selectByGenre(genre: BookGenre.values[genreID]);
      // lm = await dp.rawSelectWhereGenrePurchased(BookGenre.values[genreID].name, '0');
      List lm =
          isChecked == true
              ? await dp.selectByPublisher(publisher: Publisher.values[publisherID])
              : await dp.rawSelectWherePublisherPurchased(Publisher.values[publisherID].name, '0');
      logger.i("listBooks4() lm.length ${lm.length} lm $lm");
      List<Widget> lw = List.empty(growable: true);
      for (int i = 0; i < lm.length; i++) {
        // logger.i("listBooks3() ${lm[i]['id']} --- ${lm[i]['title']} --- ${lm[i]['author']}");
        // logger.i("listBooks3() i=$i --- $lw");
        var apg = "${lm[i]['id'].toString()} ${lm[i]['author']} ${lm[i]['publisher']} ${lm[i]['genre']} ${lm[i]['purchased'] == 0 ? "" : "購入済み"}";
        lw.add(
          ListTile(
            title: Text(lm[i]['title']),
            subtitle: Text(apg),
            onTap: () async {
              // DONE: display and change the entry
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
        logger.i("listBooks4() i=$i --- $lw");
      }
      return lw;
    }
  }
}

class ListPurchasedBooksScreen extends StatefulWidget {
  ListPurchasedBooksScreen({super.key, required this.pulisherID, required this.isChecked}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int pulisherID;
  final bool isChecked;

  @override
  State<ListPurchasedBooksScreen> createState() => _ListPurchasedBooksScreenState();
}

class _ListPurchasedBooksScreenState extends State<ListPurchasedBooksScreen> {
  _ListPurchasedBooksScreenState();
  Future<List<Widget>> getData() async {
    logger.i("_ListPurchasedBooksScreenState called.");
    await Future.delayed(const Duration(seconds: 1));
    return await listBooks5(publisherID: widget.pulisherID, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('購入済み書籍一覧 ${Publisher.values[widget.pulisherID].name}'),
    ),
    // body: lstregbooksBody(context, widget.dp),
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
  );

  Future<List<Widget>> listBooks5({required int publisherID, required bool isChecked}) async {
    logger.i("listBooks5() called -- publisherID $publisherID --- isChecked $isChecked");

    if (true) {
      logger.i("listBooks5() then");
      DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
      // List lm =
      //     isChecked == true
      //         ? await dp.selectByPublisher(publisher: Publisher.values[publisherID])
      //         : await dp.rawSelectWherePublisherPurchased(Publisher.values[publisherID].name, '0');
      List lm = await dp.rawSelectWherePurchasedGenre(BookGenre.all.name, '1');
      logger.i("listBooks5() lm.length ${lm.length} lm $lm");
      List<Widget> lw = List.empty(growable: true);
      for (int i = 0; i < lm.length; i++) {
        // logger.i("listBooks3() ${lm[i]['id']} --- ${lm[i]['title']} --- ${lm[i]['author']}");
        // logger.i("listBooks3() i=$i --- $lw");
        var apg = "${lm[i]['id'].toString()} ${lm[i]['author']} ${lm[i]['publisher']} ${lm[i]['genre']} ${lm[i]['purchased'] == 0 ? "" : "購入済み"}";
        lw.add(
          ListTile(
            title: Text(lm[i]['title']),
            subtitle: Text(apg),
            onTap: () async {
              // DONE: display and change the entry
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
        logger.i("listBooks5() i=$i --- $lw");
      }
      return lw;
    }
  }
}
