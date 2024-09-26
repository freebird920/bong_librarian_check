import 'package:flutter/material.dart';

void openAlertDialogStringMsg({
  required BuildContext context,
  required String message,
  String? title,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogStringMsg(
        message: message,
        title: title,
      );
    },
  );
}

class AlertDialogStringMsg extends StatelessWidget {
  const AlertDialogStringMsg({
    super.key,
    required this.message,
    this.title,
  });

  final String message;
  final String? title;
  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title ?? ""),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("닫기"),
        )
      ],
    );
  }
}
