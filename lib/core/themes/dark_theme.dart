import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: Colors.blueGrey,
      cardColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      brightness: Brightness.dark,
    );
  }
}