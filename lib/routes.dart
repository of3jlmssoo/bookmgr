// dart run build_runner watch --delete-conflicting-outputs
import 'package:bookmgr/main.dart';
import 'package:bookmgr/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

@TypedGoRoute<ListRegisteredBooksRoute>(path: '/listregisteredbooks')
class ListRegisteredBooksRoute extends GoRouteData {
  const ListRegisteredBooksRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => ListRegisteredBooksScreen();
}
