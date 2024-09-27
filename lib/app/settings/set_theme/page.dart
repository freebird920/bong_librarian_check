import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/providers/provider_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
            ListTile(
              leading: const Icon(Icons.colorize_rounded),
              title: const Text("color set"),
              onTap: () {
                openMyColorPicker(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}

void openMyColorPicker(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Pick a color!"),
        content: const SingleChildScrollView(
          child: MyPicker(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      );
    },
  );
}

class MyPicker extends StatefulWidget {
  const MyPicker({super.key});

  @override
  State<MyPicker> createState() => _MyPickerState();
}

class _MyPickerState extends State<MyPicker> {
  Color? pickerColor;
  late ProviderPreference providerPreference;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      providerPreference =
          Provider.of<ProviderPreference>(context, listen: false);
      final int themeColor =
          providerPreference.getPrefInt("theme_color") ?? Colors.blue.value;
      setState(() {
        pickerColor = Color(themeColor);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
        pickerColor: pickerColor ?? Colors.blue,
        onColorChanged: (Color picked) {
          setState(() {
            pickerColor = picked;
            providerPreference.setPrefInt(
                key: "theme_color", value: picked.value);
          });
        });
  }
}
