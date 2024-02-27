import 'package:ecommerce_user/core/utils/helper_functions.dart';
import 'package:flutter/material.dart';

void showSingleTextFieldInputDialog({
  required BuildContext context,
  required String title,
  String? body,
  String positiveButton = 'OK',
  String negativeButton = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final txtController = TextEditingController(text: body);
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: txtController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Enter $title",
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(negativeButton),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (txtController.text.isEmpty) {
                    if(context.mounted) {
                      showMsg(context, 'Please enter $title', isError: true);
                    }
                    return;
                  }
                  onSubmit(txtController.text);
                },
                child: Text(positiveButton),
              ),
            ],
          ));
}

showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String positiveButtonText = 'OK',
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CLOSE'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            onPressed();
          },
          child: Text(positiveButtonText),
        ),
      ],
    ),
  );
}
