import 'package:flutter/material.dart';

class SnackBarMsg extends StatelessWidget {
  const SnackBarMsg({super.key, required this.msg});
  final String msg;

  void showSnackBarMsg(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(msg),
    );
  }
}
