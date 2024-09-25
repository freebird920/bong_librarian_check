import 'dart:io';

import 'package:bong_librarian_check/components/comp_navbar.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:bong_librarian_check/services/version_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pub_semver/pub_semver.dart';
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
            const ListTileTheme(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Set Librarians"),
              onTap: () => goRouter.push("/settings/set_librarians"),
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
            ListTile(
              leading: const Icon(Icons.festival),
              title: const Text("DeveloperHomePage"),
              onTap: () async {
                const url = "https://blog.naver.com/freebird_han";
                await launchUrl(Uri.parse(url));
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text("Check for Updates"),
              onTap: () async {
                final VersionService versionService = VersionService();
                final currentVersion = await versionService.getCurrentVersion();
                final latestVersion = await versionService.getLatestVersion();
                if (latestVersion.isError) {
                  throw latestVersion.error ?? Exception("Error");
                }
                print("currentVersion: ${currentVersion.toString()}");
                print("latestversion: ${latestVersion.data.toString()}");
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
