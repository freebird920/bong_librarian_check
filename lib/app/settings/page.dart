import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final goRouter = GoRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings Page"),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Set Librarians"),
              onTap: () => goRouter.push("/settings/set_librarians"),
            )
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
