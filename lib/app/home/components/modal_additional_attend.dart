import 'package:bong_librarian_check/app/home/components/list_tile_librarian.dart';
import 'package:bong_librarian_check/enums/enum_list_view_librarians_segment.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void openAdditionalAttend({
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const ModalAdditionalAttend(),
  );
}

class ModalAdditionalAttend extends StatelessWidget {
  const ModalAdditionalAttend({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderLibrarian librarianProvider =
        Provider.of<ProviderLibrarian>(context);
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: [
          const Text("전체 목록"),
          Expanded(
            child: ListViewLibrarians(
                librarians: librarianProvider.data,
                selectedViewSegment: ListViewLibrariansSegment.all),
          ),
        ],
      ),
    );
  }
}
