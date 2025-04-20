// dart run build_runner watch --delete-conflicting-outputs
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

// TODO: list books
@TypedGoRoute<ListRegisteredBooksRoute>(path: '/listregisteredbooks')
class ListRegisteredBooksRoute extends GoRouteData {
  const ListRegisteredBooksRoute({required this.genreID});
  final int genreID;
  @override
  Widget build(BuildContext context, GoRouterState state) => ListRegisteredBooksByGenreScreen(genreID: genreID);
}

@TypedGoRoute<ListRegisteredBooksByPublisherRoute>(path: '/listregisteredbooksbypublisher')
class ListRegisteredBooksByPublisherRoute extends GoRouteData {
  const ListRegisteredBooksByPublisherRoute({required this.publisherID});
  final int publisherID;
  @override
  Widget build(BuildContext context, GoRouterState state) => ListRegisteredBooksByPublisherScreen(pulisherID: publisherID);
}
