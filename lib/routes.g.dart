// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $listGenre,
  $homeRoute,
  $sqlWorkRoute,
  $listRegisteredBooksByGenreRoute,
  $listRegisteredBooksByPublisherRoute,
  $listAndChangeRegisteredBookRoute,
  $listPurchasedBookByPublisherRoute,
  $listBookByGenreRoute,
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

RouteBase get $listRegisteredBooksByGenreRoute => GoRouteData.$route(
  path: '/listregisteredbooks',

  factory: $ListRegisteredBooksByGenreRouteExtension._fromState,
);

extension $ListRegisteredBooksByGenreRouteExtension
    on ListRegisteredBooksByGenreRoute {
  static ListRegisteredBooksByGenreRoute _fromState(GoRouterState state) =>
      ListRegisteredBooksByGenreRoute(
        genreID: int.parse(state.uri.queryParameters['genre-i-d']!)!,
        isChecked: _$boolConverter(state.uri.queryParameters['is-checked']!)!,
      );

  String get location => GoRouteData.$location(
    '/listregisteredbooks',
    queryParams: {
      'genre-i-d': genreID.toString(),
      'is-checked': isChecked.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
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
        isChecked: _$boolConverter(state.uri.queryParameters['is-checked']!)!,
      );

  String get location => GoRouteData.$location(
    '/listregisteredbooksbypublisher',
    queryParams: {
      'publisher-i-d': publisherID.toString(),
      'is-checked': isChecked.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $listAndChangeRegisteredBookRoute => GoRouteData.$route(
  path: '/listandchangeregisteredbook',

  factory: $ListAndChangeRegisteredBookRouteExtension._fromState,
);

extension $ListAndChangeRegisteredBookRouteExtension
    on ListAndChangeRegisteredBookRoute {
  static ListAndChangeRegisteredBookRoute _fromState(GoRouterState state) =>
      ListAndChangeRegisteredBookRoute(state.extra as Book);

  String get location => GoRouteData.$location('/listandchangeregisteredbook');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $listPurchasedBookByPublisherRoute => GoRouteData.$route(
  path: '/listpurchaseddbook',

  factory: $ListPurchasedBookByPublisherRouteExtension._fromState,
);

extension $ListPurchasedBookByPublisherRouteExtension
    on ListPurchasedBookByPublisherRoute {
  static ListPurchasedBookByPublisherRoute _fromState(GoRouterState state) =>
      ListPurchasedBookByPublisherRoute(
        publisherID: int.parse(state.uri.queryParameters['publisher-i-d']!)!,
        isChecked: _$boolConverter(state.uri.queryParameters['is-checked']!)!,
      );

  String get location => GoRouteData.$location(
    '/listpurchaseddbook',
    queryParams: {
      'publisher-i-d': publisherID.toString(),
      'is-checked': isChecked.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $listBookByGenreRoute => GoRouteData.$route(
  path: '/listbooksbygenre',

  factory: $ListBookByGenreRouteExtension._fromState,
);

extension $ListBookByGenreRouteExtension on ListBookByGenreRoute {
  static ListBookByGenreRoute _fromState(GoRouterState state) =>
      ListBookByGenreRoute(
        genre: state.uri.queryParameters['genre']!,
        isChecked: _$boolConverter(state.uri.queryParameters['is-checked']!)!,
      );

  String get location => GoRouteData.$location(
    '/listbooksbygenre',
    queryParams: {'genre': genre, 'is-checked': isChecked.toString()},
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
