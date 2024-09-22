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
            const ListTileTheme(),
            ListTile(
              leading: const Icon(Icons.person),
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

class ListTileTheme extends StatefulWidget {
  const ListTileTheme({
    super.key,
  });

  @override
  State<ListTileTheme> createState() => _ListTileThemeState();
}

class _ListTileThemeState extends State<ListTileTheme> {
  late bool _isDarkMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isDarkMode = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Theme"),
      leading: const Icon(Icons.palette),
      trailing: Switch(
        value: _isDarkMode,
        onChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
    );
  }
}
