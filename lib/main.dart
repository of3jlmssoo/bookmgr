import 'package:bookmgr/book.dart';
import 'package:bookmgr/dbprovider.dart';
import 'package:bookmgr/maintheme.dart';
import 'package:bookmgr/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

@riverpod
String example(Ref ref) {
  return 'foo';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactoryOrNull = null;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(title: 'Flutter Demo', home: const MyHomePage(title: '書籍管理'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("書籍管理", style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        actions: [MainPopouMenu(), SizedBox(width: 100)],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text("登録済み書籍確認", style: Theme.of(context).textTheme.displayMedium),
              Wrap(children: listGenre(context)),
              SizedBox(height: 10),
              // DONE: change to by publisher
              Wrap(children: listPublisher(context)),
              SizedBox(height: 30),
              Text("購入済み書籍情報", style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: Text("submit")),
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

  Row inputBookDropDownMenu(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(color: Colors.black),
          ),
          onPressed:
              () => {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Modal BottomSheet'),
                            TextFormField(
                              // The validator receives the text that the user has entered.
                              decoration: const InputDecoration(labelText: "書籍名"),
                              onSaved: (String? value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '書籍名を入力してください';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(child: const Text('Close BottomSheet'), onPressed: () => Navigator.pop(context)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              },
          child: Text("入力", style: TextStyle(fontSize: 15, color: Colors.black)),
        ),
      ],
    );
  }

  List<Widget> listGenre(BuildContext context) {
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
            DatabaseProvider dp = DatabaseProvider(databasefile: databaseName);
            List<Map<dynamic, dynamic>> result = await dp.query();
            logger.i("list by genre ${result.runtimeType} $result");
            if (context.mounted) ListRegisteredBooksRoute(genreID: BookGenre.values[i].index).push(context);
          },
          child: Text(BookGenre.values[i].name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }

  List<Widget> listPublisher(BuildContext context) {
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
            ListRegisteredBooksByPublisherRoute(publisherID: Publisher.values[i].index).go(context);
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
                controller: publisherController,
                requestFocusOnTap: true,
                label: const Text('出版社'),
                onSelected: (Publisher? publisher) {
                  book = book.copyWith(publisher: publisher);
                },

                dropdownMenuEntries: Publisher.entries,
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
                dropdownMenuEntries: BookGenre.entries,
              ),
            ],
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

                  // var p = book.publisher == "" ? Publisher.other.name : book.publisher;
                  // var p = book.publisher == "" ? Publisher.other.name : book.publisher;
                  // logger.i('InputBookForm class book ${book.name} ${book.author} $p');
                  logger.i('InputBookForm class book ${book.name} ${book.author} ${book.publisher} ${book.genre}');
                  var dp = DatabaseProvider(databasefile: databaseName);
                  dp.dataInsert(title: book.name, author: book.author ?? "");
                  nameController.clear();
                  authorController.clear();
                  publisherController.clear();
                  genreController.clear();
                  book = book.copyWith(name: "");
                  book = book.copyWith(author: "");
                  book = book.copyWith(publisher: Publisher.other);
                  book = book.copyWith(genre: BookGenre.other);
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
            child: Text('SQLite work'),
          ),
          const PopupMenuItem(child: Text('another work')),
        ];
      },
    );
  }
}

// DONE: extract Scaffold to another file
// DONE: list publishers
// DONE: accept new book
