//extension for text style

import 'dart:ui';

import 'package:ecommerce_user/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

extension Style on TextStyle {

  TextStyle get regular => const TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  TextStyle get semiBold => const TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  TextStyle get bold => const TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  TextStyle get extraBold => const TextStyle(
    fontFamily: AppConstants.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );



}