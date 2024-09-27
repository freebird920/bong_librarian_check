import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/providers/provider_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetThemePage extends StatelessWidget {
  const SetThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProviderPreference providerPreference =
        Provider.of<ProviderPreference>(context);
    void showSnackbar(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Theme"),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("dark mode"),
              onTap: () async {
                final result = await providerPreference.setPrefBool(
                    key: "dark_mode", value: true);
                if (result.isError) {
                  showSnackbar(result.error.toString());
                }
                if (result.isSuccess && result.data == true) {
                  showSnackbar("dark mode is set");
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text("light mode"),
              onTap: () async {
                final result = await providerPreference.setPrefBool(
                    key: "dark_mode", value: false);
                if (result.isError) {
                  showSnackbar(result.error.toString());
                }
                if (result.isSuccess && result.data == true) {
                  showSnackbar("light mode is set");
                }
              },
            ),
            const ListTile(
              leading: Icon(Icons.colorize_rounded),
              title: Text("color set"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
