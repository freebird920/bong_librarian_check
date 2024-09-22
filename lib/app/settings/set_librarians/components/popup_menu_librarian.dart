import 'package:bong_librarian_check/app/settings/set_librarians/components/modal_edit_librarian.dart';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibrarianPopupMenu extends StatelessWidget {
  final Librarian librarian;
  const LibrarianPopupMenu({
    super.key,
    required this.librarian,
  });

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);

    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: "edit",
            child: const Text("Edit"),
            onTap: () =>
                openEditLibrarian(context: context, librarian: librarian),
          ),
          PopupMenuItem(
            value: "delete",
            child: const Text("Delete"),
            onTap: () {
              librarianProvider.removeLibrarian(librarian.uuid);
            },
          ),
        ];
      },
    );
  }
}
