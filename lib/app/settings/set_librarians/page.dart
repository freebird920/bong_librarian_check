import 'package:bong_librarian_check/components/modal_add_librarian.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:flutter/material.dart';

class SetLibrarinasPage extends StatelessWidget {
  const SetLibrarinasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Librarians"),
        actions: [
          IconButton(
              onPressed: () => openAddLibrarian(context),
              icon: const Icon(Icons.add))
        ],
      ),
      bottomNavigationBar: const CompNavbar(),
      body: const Center(
        child: Column(
          children: [
            Text("Set Librarians"),
          ],
        ),
      ),
    );
  }
}
