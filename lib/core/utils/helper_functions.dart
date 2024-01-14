import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

showMsg(BuildContext context, String msg, {bool isError = false}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(msg),
    ));

String getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
    DateFormat(pattern).format(dt);

Future<bool> isConnectedToInternet() async{
  var result = await(Connectivity().checkConnectivity());
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}

String getPriceAfterDiscount(num price, num discount){
  final discountAmount = (price * discount) / 100;
  return (price - discountAmount).toStringAsFixed(0);
}

String get generateOrderId => '${getFormattedDate(DateTime.now(), pattern: 'yyyyMMdd-HHmmss')}${Random().nextInt(10)}';

DateTime getDateTimeFromTimeStampString(String timestamp) {
  RegExp regExp = RegExp(r'seconds=(\d+), nanoseconds=(\d+)');
  RegExpMatch? match = regExp.firstMatch(timestamp);
  DateTime dateTime = DateTime.now();

  if (match != null && match.groupCount == 2) {
    int seconds = int.parse(match.group(1)!);
    int nanoseconds = int.parse(match.group(2)!);

    // Converting to DateTime
    int milliseconds = seconds * 1000 + (nanoseconds / 1000000).round();
    dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Output: 2023-02-10 09:29:59.780
    print(dateTime);
  } else {
    print("Invalid timestamp string format");
  }
  return dateTime;
}