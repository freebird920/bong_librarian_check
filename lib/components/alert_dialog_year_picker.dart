import 'package:flutter/material.dart';

Future<int?> showYearPicker({
  required BuildContext context,
  required DateTime now,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return YearPickAlertDialog(now: now);
    },
  );
}

class YearPickAlertDialog extends StatelessWidget {
  final DateTime now;
  const YearPickAlertDialog({
    super.key,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('입학연도'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: YearPicker(
          firstDate: DateTime(now.year - 6),
          lastDate: DateTime(now.year + 1),
          selectedDate: now,
          onChanged: (DateTime pickedDateTime) {
            Navigator.pop(context, pickedDateTime.year);
          },
        ),
      ),
    );
  }
}
