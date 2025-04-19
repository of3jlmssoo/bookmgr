import 'package:bookmgr/book.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bookmgr/maintheme.dart';
import 'package:bookmgr/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'consts.dart';

// part 'main.freezed.dart';

part 'main.g.dart';

var logger = Logger(printer: PrettyPrinter());

@riverpod
String example(Ref ref) {
  return 'foo';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactoryOrNull = null;
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(
    ProviderScope(child: App()),
    // ProviderScope(child: const MyApp())
  );
}

// TODO: make list publishers as registered books
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

class _MyAppState extends State<MyApp> {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text("登録済み書籍確認", style: Theme.of(context).textTheme.displayMedium),
            Wrap(children: listGenre(context)),
            SizedBox(height: 10),
            // TODO: change to by publisher
            Wrap(children: listGenre(context)),
            SizedBox(height: 30),
            Text("購入済み書籍情報", style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 30),
            Text("書籍情報入力", style: Theme.of(context).textTheme.displayMedium),
            InputBookForm(formKey: _formKey),
          ],
        ),
      ),
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
          onPressed: () {
            logger.i('list books. number:$i --- genre ${BookGenre.values[i].name} --- ${BookGenre.values[i].runtimeType}');
            ListRegisteredBooksRoute(genreID: BookGenre.values[i].index).go(context);
          },
          child: Text(BookGenre.values[i].name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }
}

// DONE: Japanese input
// TODO: process warning
class InputBookForm extends StatelessWidget {
  InputBookForm({super.key, required GlobalKey<FormState> formKey}) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  final TextEditingController publisherController = TextEditingController();

  String? bname;
  String? aname;
  String? pname;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(labelText: "書籍名"),
            onSaved: (String? value) {
              bname = value;
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
            decoration: const InputDecoration(labelText: "著者名"),
            onSaved: (String? value) {
              aname = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '著者名を入力してください';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          DropdownMenu<Publisher>(
            initialSelection: Publisher.other,
            controller: publisherController,
            requestFocusOnTap: true,
            label: const Text('出版社'),
            onSelected: (Publisher? publisher) {
              pname = publisher!.name;
            },
            dropdownMenuEntries: Publisher.entries,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              // TODO: stop using bname, aname, publisher. make a class
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));
                  logger.i('InputBookForm $bname $aname ${publisherController.text}');
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

// TODO: extract Scaffold to another file
// TODO: list publishers
// TODO: accept new book
