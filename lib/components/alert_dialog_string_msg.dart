import 'package:flutter/material.dart';

void openAlertDialogStringMsg({
  required BuildContext context,
  required String message,
  String? title,
  List<Widget>? actions,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogStringMsg(
        message: message,
        title: title,
        actions: actions,
      );
    },
  );
}

class AlertDialogStringMsg extends StatelessWidget {
  const AlertDialogStringMsg({
    super.key,
    required this.message,
    this.title,
    this.actions,
  });

  final String message;
  final String? title;
  final List<Widget>? actions;
  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title ?? ""),
      content: Text(message),
      actions: actions ??
          [
            const TextButtonCancel(),
          ],
    );
  }
}

class TextButtonCancel extends StatelessWidget {
  const TextButtonCancel({
    super.key,
    this.labelText,
  });
  final String? labelText;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(labelText ?? "닫기"),
    );
  }
}
