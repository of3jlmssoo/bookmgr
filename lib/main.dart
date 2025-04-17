import 'package:bookmgr/maintheme.dart';
import 'package:bookmgr/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'consts.dart';

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

// TODO: make list publishers
class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'GoRouter Example: Named Routes';

  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(theme: mainTheme(), routerConfig: GoRouter(routes: $appRoutes), title: title, debugShowCheckedModeBanner: false);
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
            TextButton(
              onPressed: () {
                logger.i("aaa");
                ListGenre(choice: "0").go(context);
              },
              child: Text('abc'),
            ),
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
      // for (var v in BookGenre.values) {
      // logger.i('listGenre() v:${v.name}');
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
          // child: Text(v.name, style: TextStyle(color: Colors.black)),
          child: Text(BookGenre.values[i].name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }
}

class InputBookForm extends StatelessWidget {
  const InputBookForm({super.key, required GlobalKey<FormState> formKey}) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

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
            onSaved: (String? value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '書籍名を入力してください';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(labelText: "出版社名"),
            onSaved: (String? value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '出版社名を入力してください';
              }
              return null;
            },
          ),
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(labelText: "出版社名"),
            onSaved: (String? value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '出版社名を入力してください';
              }
              return null;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));
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

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// TODO: extract Scaffold to another file
// TODO: list publishers
// TODO: accept new book
// class _MyHomePageState extends State<MyHomePage> {
//   // int _counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (BuildContext context) {
//               return [
//                 PopupMenuItem(
//                   onTap: () {
//                     logger.i("SQlite work tapped");
//                     SqlWorkRoute().go(context);
//                   },
//                   child: Text('SQLite work'),
//                 ),
//                 const PopupMenuItem(child: Text('another work')),
//               ];
//             },
//           ),
//           SizedBox(width: 100),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("登録済み書籍確認"),
//             Wrap(children: listGenre(context)),
//             TextButton(
//               onPressed: () {
//                 logger.i("aaa");
//                 ListGenre(choice: "0").go(context);
//               },
//               child: Text('abc'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> listGenre(BuildContext context) {
//     List<Widget> result = [];

//     for (var i = 0; i < BookGenre.values.length; i++) {
//       // for (var v in BookGenre.values) {
//       // logger.i('listGenre() v:${v.name}');
//       result.add(
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.grey.shade500,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//           onPressed: () {
//             logger.i('list books. number:$i --- genre ${BookGenre.values[i].name} --- ${BookGenre.values[i].runtimeType}');
//             ListRegisteredBooksRoute(genreID: BookGenre.values[i].index).go(context);
//           },
//           // child: Text(v.name, style: TextStyle(color: Colors.black)),
//           child: Text(BookGenre.values[i].name, style: TextStyle(color: Colors.black)),
//         ),
//       );
//     }
//     return result;
//   }
// }
