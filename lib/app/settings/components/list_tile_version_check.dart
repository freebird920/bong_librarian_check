import 'package:bong_librarian_check/providers/provider_version.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTileVersionCheck extends StatelessWidget {
  const ListTileVersionCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderVersion>(
      builder: (context, versionProvider, child) {
        Version? currentVersion = versionProvider.currentVersion;
        Version? latestVersion = versionProvider.latestVersion;
        bool isLoading = versionProvider.isLoading;
        return ListTile(
          leading: const Icon(Icons.update),
          title: Text(isLoading
              ? "로딩중..."
              : "현재버전: $currentVersion / 최신버전: $latestVersion"),
          subtitle: currentVersion == latestVersion || isLoading
              ? null
              : const Text("업데이트가 필요합니다."),
          onTap: currentVersion == latestVersion || isLoading
              ? null
              : () async {
                  const url =
                      "https://github.com/freebird920/bong_librarian_check/releases/latest";
                  // URL로 이동
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
        );
      },
    );
  }
}
