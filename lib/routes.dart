// dart run build_runner watch --delete-conflicting-outputs
import 'package:bookmgr/book.dart';
import 'package:bookmgr/main.dart';
import 'package:bookmgr/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'loggerdef.dart';

part 'routes.g.dart';

@TypedGoRoute<ListGenre>(path: '/listgenre')
class ListGenre extends GoRouteData {
  const ListGenre({this.choice = "0"});

  final String choice;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.i('ListGenreScreen() called choice:$choice');
    return ListGenreScreen(choice: choice);
  }
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => MyApp();
}

@TypedGoRoute<SqlWorkRoute>(path: '/sqlwork')
class SqlWorkRoute extends GoRouteData {
  const SqlWorkRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => SqlWorkScreen();
}

// DONE: list books
@TypedGoRoute<ListRegisteredBooksByGenreRoute>(path: '/listregisteredbooks')
class ListRegisteredBooksByGenreRoute extends GoRouteData {
  const ListRegisteredBooksByGenreRoute({required this.genreID, required this.isChecked});
  final int genreID;
  final bool isChecked;
  // final List<Map<dynamic, dynamic>> list;
  @override
  Widget build(BuildContext context, GoRouterState state) => ListRegisteredBooksByGenreScreen(genreID: genreID, isChecked: isChecked);
}

@TypedGoRoute<ListRegisteredBooksByPublisherRoute>(path: '/listregisteredbooksbypublisher')
class ListRegisteredBooksByPublisherRoute extends GoRouteData {
  const ListRegisteredBooksByPublisherRoute({required this.publisherID, required this.isChecked});
  final int publisherID;
  final bool isChecked;
  @override
  Widget build(BuildContext context, GoRouterState state) => ListRegisteredBooksByPublisherScreen(pulisherID: publisherID, isChecked: isChecked);
}

@TypedGoRoute<ListAndChangeRegisteredBookRoute>(path: '/listandchangeregisteredbook')
class ListAndChangeRegisteredBookRoute extends GoRouteData {
  ListAndChangeRegisteredBookRoute(this.$extra);
  final Book $extra;
  @override
  Widget build(BuildContext context, GoRouterState state) => ListAndChangeeRegisteredBook(book: $extra);
}
