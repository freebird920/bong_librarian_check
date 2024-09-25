import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/providers/provider_timestamp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openMultiAttend(
    {required BuildContext context, required Librarian thisLibrarian}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogMultiAttend(
        thisLibrarian: thisLibrarian,
      );
    },
  );
}

class AlertDialogMultiAttend extends StatelessWidget {
  const AlertDialogMultiAttend({
    super.key,
    required this.thisLibrarian,
  });
  final Librarian thisLibrarian;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("또 즐근하십니까?"),
      content: Text("${thisLibrarian.name}님오늘 벌써 1회 이상 출근 한 것입니다. 그래도 출가하십니까?"),
      actions: [
        TextButton(
          onPressed: () {
            final ProviderTimestamp timestampProvider =
                Provider.of<ProviderTimestamp>(context, listen: false);
            final LibraryTimestamp newTimestamp = LibraryTimestamp(
              librarianUuid: thisLibrarian.uuid,
              timestamp: DateTime.now(),
            );
            timestampProvider.saveTimestamp(newTimestamp);
            Navigator.of(context).pop();
          },
          child: const Text("도서관을 위해서 기꺼이 .."),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("닫기"),
        ),
      ],
    );
  }
}
