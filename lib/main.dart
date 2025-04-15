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

class App extends StatelessWidget {
  const App({super.key});

  static const String title = 'GoRouter Example: Named Routes';

  @override
  Widget build(BuildContext context) =>
      MaterialApp.router(routerConfig: GoRouter(routes: $appRoutes), title: title, debugShowCheckedModeBanner: false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade900,
          brightness: Brightness.dark,
          surface: Colors.blue.shade500,
          onPrimary: Colors.black,
          onPrimaryContainer: Colors.black,
          onPrimaryFixed: Colors.black,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("登録済み書籍確認"),
            Wrap(children: listGenre),
            TextButton(
              onPressed: () {
                logger.i("aaa");
                ListGenre(choice: "0").go(context);
              },
              child: Text('abc'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get listGenre {
    List<Widget> result = [];
    for (var v in BookGenre.values) {
      // logger.i('listGenre() v:${v.name}');
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => {},
          child: Text(v.name, style: TextStyle(color: Colors.black)),
        ),
      );
    }
    return result;
  }
}
