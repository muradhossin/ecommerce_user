import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String msg;
  final bool isError;
  const CustomSnackBar({super.key, required this.msg, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(msg),
      duration: const Duration(seconds: 1),
    );
  }
}
