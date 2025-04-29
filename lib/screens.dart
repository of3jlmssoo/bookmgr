// dart run build_runner watch --delete-conflicting-outputs

import 'package:bookmgr/book.dart';
import 'package:bookmgr/consts.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/routes.dart';
import 'package:bookmgr/sqlwork.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                    if (value == true) b = b.copyWith(purchasedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()));
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
                      dp.updateById(
                        id: b.id!,
                        purchased: b.purchased ?? 0,
                        inputDate: b.date ?? "",
                        title: b.name,
                        author: b.author ?? "",
                        publisher: b.publisher?.name ?? "",
                        genre: b.genre?.name ?? "",
                        comment: b.comment ?? "",
                        purchasedDate: b.purchasedDate ?? "",
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

  @override
  State<ListRegisteredBooksByGenreScreen> createState() => _ListRegisteredBooksByGenreScreenState();
}

class _ListRegisteredBooksByGenreScreenState extends State<ListRegisteredBooksByGenreScreen> {
  _ListRegisteredBooksByGenreScreenState();
  Future<List<Widget>> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await listGenrePurchased(genreID: widget.genreID, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('登録済み書籍一覧 ${BookGenre.values[widget.genreID].name}')),
    body: FutureBuilder<List<Widget>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? categories = snapshot.data;
          // logger.i("FutureBuilder categories -> catgories $categories --- snapshot $snapshot");
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

  Future<List<Widget>> listGenrePurchased({required int genreID, required bool isChecked}) async {
    logger.i("listGenrePurchased() called --- genreID $genreID isChecked $isChecked");
    DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
    List lm = [];
    // DONE: if genreID == 全て
    if (genreID == BookGenre.all.index) {
      // DONE: call dp.
      lm = await dp.rawSelectWherePurchasedGenre(BookGenre.all.name, '0');
    } else {
      lm =
          isChecked == true
              ? await dp.selectByGenre(genre: BookGenre.values[genreID])
              : await dp.rawSelectWhereGenrePurchased(BookGenre.values[genreID].name, '0');
      logger.i("listGenrePurchased() lm.length ${lm.length} lm $lm");
    }
    List<Widget> lw = [];
    if (mounted) lw = makeListOfListTileWidget(context, lm, dp);

    return lw;
  }

  List<Widget> listBooks() {
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
    return await listPublisherPurchased(publisherID: widget.pulisherID, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('登録済み書籍一覧 ${Publisher.values[widget.pulisherID].name}'),
    ),
    body: FutureBuilder<List<Widget>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? categories = snapshot.data;
          // logger.i("FutureBuilder categories -> catgories $categories --- snapshot $snapshot");
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

  // TODO: list all books by pushing all of publishers
  Future<List<Widget>> listPublisherPurchased({required int publisherID, required bool isChecked}) async {
    logger.i("listPublisherPurchased() called -- publisherID $publisherID --- isChecked $isChecked");

    logger.i("listPublisherPurchased() publisherID $publisherID isChecked $isChecked");
    DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
    List<Map> lm = [];
    if (publisherID == Publisher.all.index) {
      lm = await dp.rawSelectWherePurchasedPublisher(Publisher.all.name, '0');
      logger.i("listPublisherPurchased() - publisherID $publisherID - lm $lm");
      // lm = [
      //   {"title": "sorry", "publisher": "constructing", "purchased": 0},

      // ];
    } else {
      lm =
          isChecked == true
              ? await dp.selectByPublisher(publisher: Publisher.values[publisherID])
              : await dp.rawSelectWherePublisherPurchased(Publisher.values[publisherID].name, '0');
      logger.i("listPublisherPurchased() lm.length ${lm.length} lm $lm");
    }

    logger.i("listPublisherPurchased() lm $lm");
    List<Widget> lw = [];
    if (mounted) lw = makeListOfListTileWidget(context, lm, dp);
    return lw;
  }
}

class ListPurchasedBooksByPublisherScreen extends StatefulWidget {
  ListPurchasedBooksByPublisherScreen({super.key, required this.pulisherID, required this.isChecked})
    : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final int pulisherID;
  final bool isChecked;

  @override
  State<ListPurchasedBooksByPublisherScreen> createState() => _ListPurchasedBooksByPublisherScreenState();
}

class _ListPurchasedBooksByPublisherScreenState extends State<ListPurchasedBooksByPublisherScreen> {
  _ListPurchasedBooksByPublisherScreenState();
  Future<List<Widget>> getData() async {
    logger.i("_ListPurchasedBooksScreenState called.");
    await Future.delayed(const Duration(seconds: 1));
    return await listrawSelectWherePurchasedGenre(publisherID: widget.pulisherID, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // DONE: ジャンル検索対応
      title: Text('購入済み書籍一覧 ${Publisher.values[widget.pulisherID].name}'),
      // actions: [IconButton(onPressed: () {
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return purchasedBooksByGenre();
          },
        ),
      ],
    ),
    body: FutureBuilder<List<Widget>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? categories = snapshot.data;
          // logger.i("FutureBuilder categories -> catgories $categories --- snapshot $snapshot");
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

  List<PopupMenuItem> purchasedBooksByGenre() {
    logger.i("purchasedBooksByGenre() called.");
    List<PopupMenuItem> result = [];
    for (var g in BookGenre.values.getRange(0, BookGenre.values.length - 1)) {
      result.add(
        PopupMenuItem(
          onTap: () async {
            // logger.i("purchasedBooksByGenre --- ${await dp.rawSelectWherePurchasedGenre(g.name, '1')}");
            if (mounted) ListBookByGenreRoute(genre: g.name, isChecked: true).push(context);
          },
          child: Text(g.name),
        ),
      );
    }
    logger.i("purchasedBooksByGenre() result $result");
    // return [PopupMenuItem(onTap: () {}, child: Text('')), const PopupMenuItem(child: Text('another work'))];
    return result;
  }

  Future<List<Widget>> listrawSelectWherePurchasedGenre({required int publisherID, required bool isChecked}) async {
    logger.i("listBooks5() called -- publisherID $publisherID --- isChecked $isChecked");

    logger.i("listrawSelectWherePurchasedGenre() then");
    DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);

    List lm = await dp.rawSelectWherePurchasedGenre(BookGenre.all.name, '1');
    logger.i("listrawSelectWherePurchasedGenre() lm.length ${lm.length} lm $lm");
    List<Widget> lw = [];
    if (mounted) lw = makeListOfListTileWidget(context, lm, dp);
    return lw;
  }
}

class ListBooksByGenreScreen extends StatefulWidget {
  ListBooksByGenreScreen({super.key, required this.genre, required this.isChecked}) : dp = DatabaseProvider(databasefile: databaseName);
  final DatabaseProvider dp;
  final String genre;
  final bool isChecked;

  @override
  State<ListBooksByGenreScreen> createState() => _ListBooksByGenreScreenState();
}

class _ListBooksByGenreScreenState extends State<ListBooksByGenreScreen> {
  _ListBooksByGenreScreenState();
  Future<List<Widget>> getData() async {
    logger.i("_ListBooksByGenreScreenState called.");
    await Future.delayed(const Duration(seconds: 1));
    return await listrawSelectWherePurchasedGenre(genre: widget.genre, isChecked: widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //DONE: ジャンル検索対応
      title: Text('購入済み書籍一覧 ${widget.genre}'),
    ),
    body: FutureBuilder<List<Widget>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget>? categories = snapshot.data;
          // logger.i("FutureBuilder categories -> catgories $categories --- snapshot $snapshot");
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

  // DONE: rename the function
  Future<List<Widget>> listrawSelectWherePurchasedGenre({required String genre, required bool isChecked}) async {
    logger.i("listPurchasedGenre() called -- genre $genre --- isChecked $isChecked");

    // DONE: delete if true
    logger.i("listPurchasedGenre() then");
    DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);

    List lm = await dp.rawSelectWherePurchasedGenre(genre, '1');
    logger.i("listPurchasedGenre() lm.length ${lm.length} lm $lm");
    // DONE: try to commonalize
    List<Widget> lw = [];
    if (mounted) lw = makeListOfListTileWidget(context, lm, dp);
    return lw;
  }
}

// DONE: change title and subtitle
List<Widget> makeListOfListTileWidget(BuildContext context, List<dynamic> lm, DatabaseProvider dp) {
  List<Widget> lw = List.empty(growable: true);
  for (int i = 0; i < lm.length; i++) {
    // logger.i(
    //   "makeListOfListTileWidget() id ${lm[i]['id']} - title ${lm[i]['title']} - author ${lm[i]['author']} - purchased ${lm[i]['purchased']}- memo ${lm[i]['memo']}",
    // );
    // logger.i("makeListOfListTileWidget() i=$i --- $lw");
    var s4title = "${lm[i]['title']} ${lm[i]['publisher']} ${lm[i]['purchased'] == 0 ? "" : "購入済み"}";
    var s4subtitle = "${lm[i]['id'].toString()} ${lm[i]['author']} ${lm[i]['genre']} ${lm[i]['memo'] ?? ''}";
    lw.add(
      ListTile(
        title: Text(s4title),
        subtitle: Text(s4subtitle),
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
          if (context.mounted) ListAndChangeRegisteredBookRoute(book).go(context);
          logger.i("ListTile changed?");
        },
      ),
    );
    // logger.i("listBooks3() i=$i --- $lw");
  }
  return lw;
}
