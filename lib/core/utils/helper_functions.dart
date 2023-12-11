import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));

getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
    DateFormat(pattern).format(dt);

Future<bool> isConnectedToInternet() async{
  var result = await(Connectivity().checkConnectivity());
  return result == ConnectivityResult.wifi || result == ConnectivityResult.mobile;
}

String getPriceAfterDiscount(num price, num discount){
  final discountAmount = (price * discount) / 100;
  return (price - discountAmount).toStringAsFixed(0);
}

String get generateOrderId => 'PB_${getFormattedDate(DateTime.now(), pattern: 'yyyyMMdd_HH:mm:ss')}';