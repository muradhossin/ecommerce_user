
import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:ecommerce_user/core/themes/light_theme.dart';
import 'package:flutter/material.dart';

extension Style on TextStyle {

  TextStyle get regular => TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: LightTheme.theme.textTheme.bodyLarge!.color,
  );

  TextStyle get semiBold => TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: LightTheme.theme.textTheme.bodyLarge!.color,
  );

  TextStyle get bold => TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: LightTheme.theme.textTheme.bodyLarge!.color,
  );

  TextStyle get extraBold => TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: LightTheme.theme.textTheme.bodyLarge!.color,
  );



}

