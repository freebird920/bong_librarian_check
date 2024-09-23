import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';
import 'package:provider/provider.dart';

void openSetDayOfWeekDialog({
  required BuildContext context,
  required Librarian librarian,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogSetDayOfWeek(
        librarian: librarian,
      );
    },
  );
}

class AlertDialogSetDayOfWeek extends StatefulWidget {
  final Librarian librarian;
  const AlertDialogSetDayOfWeek({super.key, required this.librarian});

  @override
  State<AlertDialogSetDayOfWeek> createState() =>
      _AlertDialogSetDayOfWeekState();
}

class _AlertDialogSetDayOfWeekState extends State<AlertDialogSetDayOfWeek> {
  Map<int, bool> checkedDayOfWeek = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
  };

  @override
  void initState() {
    widget.librarian.workDays?.forEach(
      (element) {
        checkedDayOfWeek[element] = true;
      },
    );
    super.initState();
  }

  List<int> getSelectedWrokDays() {
    List<int> selectedWorkDays = checkedDayOfWeek.keys
        .where((key) => checkedDayOfWeek[key] == true)
        .toList();
    return selectedWorkDays;
  }

  @override
  Widget build(BuildContext context) {
    final ProviderLibrarian librarianProvider =
        Provider.of<ProviderLibrarian>(context, listen: false);
    return AlertDialog(
      title: const Text("요일설정"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: checkedDayOfWeek.keys.map(
            (int e) {
              return CheckboxListTile(
                title: Text("${dayOfWeekParser(e).data ?? "ERR"}요일"),
                value: checkedDayOfWeek[e],
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      checkedDayOfWeek[e] = value;
                    });
                  }
                },
              );
            },
          ).toList(),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
        OutlinedButton(
          onPressed: () {
            List<int> selectedWorkDays = getSelectedWrokDays();
            Librarian newLibrarian = widget.librarian;
            newLibrarian.workDays = selectedWorkDays;
            librarianProvider.updateLibrarian(newLibrarian);
            Navigator.pop(context);
          },
          child: const Text("확인"),
        ),
      ],
    );
  }
}
