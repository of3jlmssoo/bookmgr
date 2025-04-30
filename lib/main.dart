import 'dart:convert';

import 'package:bookmgr/book.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/maintheme.dart';
import 'package:bookmgr/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// import 'dart:collection';
// import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'consts.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart';
import 'loggerdef.dart';

// part 'main.freezed.dart';

part 'main.g.dart';

// var logger = Logger(printer: PrettyPrinter());
// DONE: need to time out
// DONE: add try to SQL statetments
// TODO: change mysample to 書籍管理
// TODO: make guide (README)
// TODO: make guide (how to use)
// DONE: date is registered date and make purchased date
// DONE: update comment field
// DONE: check if DB and table exist, if not create them in main()

@riverpod
String example(Ref ref) {
  return 'foo';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactoryOrNull = null;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  var dp = DatabaseProvider(databasefile: databaseName);
  await dp.openDB();
  List tables = await dp.listTables();
  if (!tables.contains("bookmgr_tbl")) {
    dp.createTables();
  }

  runApp(ProviderScope(child: App()));
}

// DONE: list registered books by publisher as genre
class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'GoRouter Example: Named Routes';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    supportedLocales: const [Locale('ja', 'JP')],
    localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
    theme: mainTheme(),
    routerConfig: GoRouter(routes: $appRoutes),
    title: title,
    debugShowCheckedModeBanner: false,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// DONE: 全て対応 by genre
// DONE: 全て対応 by publisher
class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();

  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("書籍管理", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [MainPopouMenu()],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: [
                  Text("登録済み書籍確認", style: Theme.of(context).textTheme.displayMedium),
                  SizedBox(width: 20),
                  Checkbox(
                    tristate: false,
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  Text("購入済みを含める"),
                ],
              ),
              Wrap(children: listGenre(context, isChecked!)),
              SizedBox(height: 10),
              // DONE: change to by publisher
              Wrap(children: listPublisher(context, isChecked!)),
              SizedBox(height: 30),
              Text("購入済み書籍情報", style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 16),
              // DONE: add function to list purchased books
              // DONE: add filter, by publisher, by genre
              ElevatedButton(
                onPressed: () {
                  logger.i("購入済み書籍情報");
                  ListPurchasedBookByPublisherRoute(publisherID: Publisher.all.index, isChecked: true).push(context);
                },
                child: Text("submit"),
              ),
              SizedBox(height: 30),
              Text("書籍情報入力", style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 15),
              // inputBookDmenu(context),
              InputBookForm(formKey: _formKey),
            ],
          ),
        ),
      ),
    );
  }

  // Row inputBookDropDownMenu(BuildContext context) {
  //   return Row(
  //     children: [
  //       SizedBox(width: 20),
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //           // backgroundColor: Colors.grey.shade500,
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           side: BorderSide(color: Colors.black),
  //         ),
  //         onPressed:
  //             () => {
  //               showModalBottomSheet<void>(
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return SizedBox(
  //                     height: 200,
  //                     child: Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           const Text('Modal BottomSheet'),
  //                           TextFormField(
  //                             // The validator receives the text that the user has entered.
  //                             decoration: const InputDecoration(labelText: "書籍名"),
  //                             onSaved: (String? value) {},
  //                             validator: (value) {
  //                               if (value == null || value.isEmpty) {
  //                                 return '書籍名を入力してください';
  //                               }
  //                               return null;
  //                             },
  //                           ),
  //                           ElevatedButton(child: const Text('Close BottomSheet'), onPressed: () => Navigator.pop(context)),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             },
  //         child: Text("入力", style: TextStyle(fontSize: 15, color: Colors.black)),
  //       ),
  //     ],
  //   );
  // }

  List<Widget> listGenre(BuildContext context, bool isChecked) {
    List<Widget> result = [];

    for (var i = 0; i < BookGenre.values.length; i++) {
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Colors.grey.shade500),
          ),
          onPressed: () async {
            logger.i('list books. number:$i --- genre ${BookGenre.values[i].name} --- ${BookGenre.values[i].runtimeType}');
            // DONE: add isChecked to query (or select)
            logger.i("list by genre ${result.runtimeType} $result");
            if (context.mounted) ListRegisteredBooksByGenreRoute(genreID: BookGenre.values[i].index, isChecked: isChecked).push(context);
          },
          child: Text(BookGenre.values[i].name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }

  List<Widget> listPublisher(BuildContext context, bool isChecked) {
    logger.i("listPublisher called ---  isChecked $isChecked");
    List<Widget> result = [];

    for (var i = 0; i < Publisher.values.length; i++) {
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Colors.grey.shade500),
          ),
          onPressed: () {
            // logger.i('list books. number:$i --- genre ${Publisher.values[i].name} --- ${Publisher.values[i].runtimeType}');
            ListRegisteredBooksByPublisherRoute(publisherID: Publisher.values[i].index, isChecked: isChecked).push(context);
          },
          child: Text(Publisher.values[i].name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }
}

// DONE: Japanese input
// DONE: process warning
class InputBookForm extends StatefulWidget {
  const InputBookForm({super.key, required GlobalKey<FormState> formKey}) : _formKey = formKey;
  final GlobalKey<FormState> _formKey;

  @override
  State<InputBookForm> createState() => _InputBookFormState();
}

class _InputBookFormState extends State<InputBookForm> {
  var book = Book(name: "", author: "", publisher: Publisher.other, genre: BookGenre.other);

  // final Book book;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(labelText: "書籍名"),
            onSaved: (String? value) {
              book = book.copyWith(name: value!);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '書籍名を入力してください';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            controller: authorController,
            decoration: const InputDecoration(labelText: "著者名"),
            onSaved: (String? value) {
              book = book.copyWith(author: value!);
            },
          ),
          SizedBox(height: 10),
          Row(
            children: [
              DropdownMenu<Publisher>(
                width: 130,
                // initialSelection: Publisher.other,
                controller: publisherController,
                requestFocusOnTap: true,
                label: const Text('出版社'),
                onSelected: (Publisher? publisher) {
                  book = book.copyWith(publisher: publisher);
                },

                dropdownMenuEntries: Publisher.entries.getRange(0, Publisher.entries.length - 1).toList(),
              ),
              SizedBox(width: 20),
              DropdownMenu<BookGenre>(
                width: 140,
                // initialSelection: Publisher.other,
                controller: genreController,
                requestFocusOnTap: true,
                label: const Text('ジャンル'),
                onSelected: (BookGenre? genre) {
                  book = book.copyWith(genre: genre);
                },
                dropdownMenuEntries: BookGenre.entries.getRange(0, BookGenre.entries.length - 1).toList(),
              ),
            ],
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            controller: commentController,
            decoration: const InputDecoration(labelText: "コメント"),
            onSaved: (String? value) {
              book = book.copyWith(comment: value!);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              // DONE: stop using bname, aname, publisher. make a class
              onPressed: () {
                // DONE: clear input after onPressed()
                // Validate returns true if the form is valid, or false otherwise.
                if (widget._formKey.currentState!.validate()) {
                  widget._formKey.currentState!.save();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));

                  logger.i('InputBookForm class book ${book.name} ${book.author} ${book.publisher} ${book.genre}');
                  var dp = DatabaseProvider(databasefile: databaseName);
                  dp.dataInsert(
                    purchased: 0,
                    inputDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    title: book.name,
                    author: book.author ?? "",
                    publisher: book.publisher ?? Publisher.other,
                    genre: book.genre ?? BookGenre.other,
                    comment: book.comment ?? "",
                  );

                  nameController.clear();
                  authorController.clear();
                  publisherController.clear();
                  genreController.clear();
                  commentController.clear();
                  book = book.copyWith(name: "");
                  book = book.copyWith(author: "");
                  book = book.copyWith(publisher: Publisher.other);
                  book = book.copyWith(genre: BookGenre.other);
                  book = book.copyWith(comment: "");
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class MainPopouMenu extends StatelessWidget {
  const MainPopouMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            onTap: () {
              logger.i("SQlite work tapped");
              SqlWorkRoute().go(context);
            },
            child: Text('SQL処理'),
          ),
          PopupMenuItem(
            // DONE: copied to clipboard message  (snapbar)
            onTap: () async {
              logger.i("保存 called");
              var dp = DatabaseProvider(databasefile: databaseName);
              var list = await dp.dumpTable();
              logger.i("保存 list $list");
              String result = "[";
              // {id: 147, purchased: 0, date: 2025-04-23, title: マックス・ウェーバーを読む, author: 仲正昌樹, publisher: その他, genre: その他, memo: },
              //  [{id: 147, purchased: 0, date: 2025-04-23, title: マックス・ウェーバーを読む, author: 仲正昌樹, publisher: その他, genre: その他, memo: }, {id: 148, purchased: 1, date: 2025-04-14, title: タイトル0, author: 著者0, publisher: ブルーバックス, genre: 経済, memo: コメント0}, {id: 149, purchased: 0, date: 2025-04-14, title: タイトル1, author: 著者1, publisher: 講談社現代新書, genre: 宗教, memo: コメント1}, {id: 150, purchased: 1, date: 2025-04-14, title: タイトル2, author: 著者2, publisher: 講談社学術文庫, genre: IT, memo: コメント2}, {id: 151, purchased: 0, date: 2025-04-14, title: タイトル3, author: 著者3, publisher: 岩波新書, genre: 社会, memo: コメント3}, {id: 152, purchased: 1, date: 2025-04-14, title: タイトル4, author: 著者4, publisher: 岩波ジュニア新書, genre: 政治, memo: コメント4}, {id: 153, purchased: 0, date: 2025-04-14, title: タイトル5, author: 著者5,
              for (var l in list) {
                int pur = l['purchased'];
                String d = l['date'];
                String t = l['title'];
                String a = l['author'];
                String pub = l['publisher'];
                String g = l['genre'];
                String m = l['memo'];
                String pd = l['purchasedDate'] ?? "";
                int nx = l['next'] ?? 0;
                String n =
                    '{"purchased": $pur, "date": "$d", "title": "$t", "author": "$a", "publisher": "$pub", "genre": "$g", "memo": "$m", "purchasedDate": "$pd", "next": "$nx" }';
                // logger.i("--> ${l.toString().runtimeType}");
                result = "$result  $n,\n";
              }
              result = result.substring(0, result.length - 2);
              result = "$result]";
              Clipboard.setData(ClipboardData(text: result));
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("クリップボードにコピーしました"), showCloseIcon: true, duration: Duration(seconds: 3)));
              } else {
                logger.e("保存 context unmounted");
              }
              logger.i("保存 result $result");
            },
            child: Text('クリップボードへ保存'),
          ),
          PopupMenuItem(
            // DONE: copied to clipboard message  (snapbar)
            onTap: () async {
              logger.i("読込 called");
              final text = await Clipboard.getData('text/plain');
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("クリップボードからコピーしました"), showCloseIcon: true, duration: Duration(seconds: 3)));
              } else {
                logger.e("保存 context unmounted");
              }
              logger.i("read clipboard text ${text != null ? text.text : '読込 エラー'}");
              if (text != null && text.text != null) {
                List list = json.decode(text.text!).cast<Map>();
                logger.i("読込 list ${list.runtimeType} $list");
                var dp = DatabaseProvider(databasefile: databaseName);
                await dp.clipBoardDataInserts(list);
              }
            },
            child: Text('クリップボードから読込'),
          ),
        ];
      },
    );
  }
}

// DONE: extract Scaffold to another file
// DONE: list publishers
// DONE: accept new book
