import 'package:bong_librarian_check/app/settings/set_librarians/modal_edit_librarian.dart';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/components/modal_add_librarian.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/providers/provider_librarian.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetLibrarinasPage extends StatefulWidget {
  const SetLibrarinasPage({super.key});

  @override
  State<SetLibrarinasPage> createState() => _SetLibrarinasPageState();
}

class _SetLibrarinasPageState extends State<SetLibrarinasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderLibrarian>(context, listen: false).loadLibrarians();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Librarians"),
        actions: [
          IconButton(
            onPressed: () {
              for (var librarian in librarianProvider.data) {
                print(librarian.toJsonString);
              }
            },
            icon: const Icon(Icons.ac_unit_rounded),
          ),
          IconButton(
              onPressed: () => openAddLibrarian(context),
              icon: const Icon(Icons.add))
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: Center(
        child: librarianProvider.isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: librarianProvider.data.length,
                itemBuilder: (context, index) {
                  return LibrarianListTile(
                    index: index,
                    // librarian: librarianProvider.data[index],
                  );
                },
              ),
      ),
    );
  }
}

/// # LibrarianListTile
/// - Librarian 객체를 받아서 ListTile로 표현
/// - index: 순서
/// - librarian: Librarian 객체
/// - ListTile: 순서, 이름, 학번, PopupMenuButton으로 구성
class LibrarianListTile extends StatelessWidget {
  final int index;
  const LibrarianListTile({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final librarianProvider = Provider.of<ProviderLibrarian>(context);
    final librarian = librarianProvider.data[index];
    return ListTile(
      key: ValueKey(librarian.uuid),
      leading: Text((index + 1).toString()),
      title: Text(librarian.name),
      subtitle: Text(librarian.studentId.toString()),
      trailing: LibrarianPopupMenu(librarian: librarian),
    );
  }
}

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
