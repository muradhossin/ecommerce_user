import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: Colors.cyan,
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.cyan,
        elevation: 0,
      ),


    );
  }
}