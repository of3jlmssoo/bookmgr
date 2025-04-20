// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $listGenre,
  $homeRoute,
  $sqlWorkRoute,
  $listRegisteredBooksRoute,
  $listRegisteredBooksByPublisherRoute,
];

RouteBase get $listGenre => GoRouteData.$route(
  path: '/listgenre',

  factory: $ListGenreExtension._fromState,
);

extension $ListGenreExtension on ListGenre {
  static ListGenre _fromState(GoRouterState state) =>
      ListGenre(choice: state.uri.queryParameters['choice'] ?? "0");

  String get location => GoRouteData.$location(
    '/listgenre',
    queryParams: {if (choice != "0") 'choice': choice},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homeRoute =>
    GoRouteData.$route(path: '/', factory: $HomeRouteExtension._fromState);

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location('/');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sqlWorkRoute => GoRouteData.$route(
  path: '/sqlwork',

  factory: $SqlWorkRouteExtension._fromState,
);

extension $SqlWorkRouteExtension on SqlWorkRoute {
  static SqlWorkRoute _fromState(GoRouterState state) => const SqlWorkRoute();

  String get location => GoRouteData.$location('/sqlwork');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $listRegisteredBooksRoute => GoRouteData.$route(
  path: '/listregisteredbooks',

  factory: $ListRegisteredBooksRouteExtension._fromState,
);

extension $ListRegisteredBooksRouteExtension on ListRegisteredBooksRoute {
  static ListRegisteredBooksRoute _fromState(GoRouterState state) =>
      ListRegisteredBooksRoute(
        genreID: int.parse(state.uri.queryParameters['genre-i-d']!)!,
      );

  String get location => GoRouteData.$location(
    '/listregisteredbooks',
    queryParams: {'genre-i-d': genreID.toString()},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $listRegisteredBooksByPublisherRoute => GoRouteData.$route(
  path: '/listregisteredbooksbypublisher',

  factory: $ListRegisteredBooksByPublisherRouteExtension._fromState,
);

extension $ListRegisteredBooksByPublisherRouteExtension
    on ListRegisteredBooksByPublisherRoute {
  static ListRegisteredBooksByPublisherRoute _fromState(GoRouterState state) =>
      ListRegisteredBooksByPublisherRoute(
        publisherID: int.parse(state.uri.queryParameters['publisher-i-d']!)!,
      );

  String get location => GoRouteData.$location(
    '/listregisteredbooksbypublisher',
    queryParams: {'publisher-i-d': publisherID.toString()},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
