import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDialogErrorGoHome extends StatelessWidget {
  const AlertDialogErrorGoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text("Error"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          child: const Text("Go Home"),
        ),
      ],
    );
  }
}
