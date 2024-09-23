import 'package:bong_librarian_check/app/settings/set_librarians/components/list_tile_librarian.dart';
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
            icon: const Icon(Icons.refresh),
            onPressed: () {
              librarianProvider.loadLibrarians();
            },
          ),
          IconButton(
            onPressed: () => openAddLibrarian(context),
            icon: const Icon(Icons.add),
          ),
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
