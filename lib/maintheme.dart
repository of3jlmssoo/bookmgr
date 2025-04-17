import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue.shade900,
      inversePrimary: Colors.blue.shade900,
      brightness: Brightness.dark,
      surface: Colors.blue.shade500,
      onPrimary: Colors.black,
      onPrimaryContainer: Colors.black,
      onPrimaryFixed: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue),
        foregroundColor: WidgetStatePropertyAll(Colors.grey.shade800),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        side: WidgetStatePropertyAll(BorderSide(color: Colors.grey.shade700)),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.normal),
      displayMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
    ),
    buttonTheme: ButtonThemeData(
      // buttonColor: Colors.blue,
      // textTheme: ButtonTextTheme.primary,
      // minWidth: 200.0,
      // height: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  );
}
