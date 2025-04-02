import 'package:flutter/material.dart';

// Define the dark theme
final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  hintColor: Colors.tealAccent,
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.tealAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueGrey,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);
