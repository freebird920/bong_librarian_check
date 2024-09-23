import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/helper/day_of_week_parser.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openSetDayOfWeekDialog(
    {required BuildContext context, required Librarian librarian}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogSetDayOfWeek(
        librarian: librarian,
      );
    },
  );
}

class AlertDialogSetDayOfWeek extends StatelessWidget {
  final Librarian librarian;
  const AlertDialogSetDayOfWeek({super.key, required this.librarian});
  @override
  Widget build(BuildContext context) {
    final List<int> dayOfWeek = [1, 2, 3, 4, 5];
    return AlertDialog(
      title: const Text("요일설정"),
      content: Text("${librarian.name}의 요일을 설정하십시오."),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...dayOfWeek.map((e) {
              return SetDayOfWeek(
                intDayOfWeek: e,
                librarian: librarian,
              );
            }),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
      ],
    );
  }
}

class SetDayOfWeek extends StatelessWidget {
  final int intDayOfWeek;
  final Librarian librarian;
  const SetDayOfWeek({
    required this.intDayOfWeek,
    super.key,
    required this.librarian,
  });

  @override
  Widget build(BuildContext context) {
    void setDayOfWeek({
      required Librarian librarian,
      required int intDayOfWeek,
    }) {
      final librarianProvider =
          Provider.of<ProviderLibrarian>(context, listen: false);
      Librarian newLibrarian = librarian;
      newLibrarian.dayOfWeek = intDayOfWeek;
      librarianProvider.updateLibrarian(newLibrarian);
    }

    return TextButton(
      onPressed: () {
        setDayOfWeek(librarian: librarian, intDayOfWeek: intDayOfWeek);
        Navigator.pop(context);
      },
      child: Text("${dayOfWeekParser(intDayOfWeek).data}"),
    );
  }
}
