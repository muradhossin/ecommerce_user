import 'package:flutter/material.dart';

extension Context on BuildContext {

  NavigatorState get navigator => Navigator.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  Size get size => MediaQuery.of(this).size;
  double get height => size.height;
  double get width => size.width;

  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get statusBarWidth => MediaQuery.of(this).padding.left;
  double get statusBarBottom => MediaQuery.of(this).padding.bottom;
  double get statusBarRight => MediaQuery.of(this).padding.right;

}
