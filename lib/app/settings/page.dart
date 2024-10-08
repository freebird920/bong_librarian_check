import 'dart:io';

import 'package:bong_librarian_check/app/settings/components/list_tile_version_check.dart';
import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
              leading: const Icon(Icons.person),
              title: const Text("Set Librarians"),
              onTap: () => goRouter.push("/settings/set_librarians"),
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text("Set Theme"),
              onTap: () => goRouter.push("/settings/set_theme"),
            ),
            if (Platform.isWindows)
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text("Open Folder"),
                onTap: () async {
                  FileService fileService = FileService();
                  final path = await fileService.localPath;
                  if (path.isError || path.isNull) {
                    throw path.error ?? Exception("Path is null");
                  }
                  await Process.run('explorer', [path.data!]);
                },
              ),
            const ListTileVersionCheck(),
            ListTile(
              leading: const Icon(Icons.festival),
              title: const Text("개발자 블로그"),
              onTap: () async {
                const url = "https://blog.naver.com/freebird_han";
                await launchUrl(Uri.parse(url));
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text("깃허브"),
              onTap: () async {
                const url =
                    "https://github.com/freebird920/bong_librarian_check";
                await launchUrl(Uri.parse(url));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text("카카오톡 문의"),
              onTap: () async {
                const url = "https://open.kakao.com/o/sXKbtVXf";
                await launchUrl(Uri.parse(url));
              },
            ),
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
    super.initState();
    _isDarkMode = false;
  }

  @override
  void dispose() {
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
