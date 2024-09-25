import 'dart:convert';

import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionService {
  VersionService();
  Future<Version> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageinfoVersion = packageInfo.version;
    Version version = Version.parse(packageinfoVersion);
    return version;
  }

  Future<Result<Version>> getLatestVersion() async {
    final url = Uri.parse(
        'https://api.github.com/repos/freebird920/bong_librarian_check/releases/latest');
    try {
      final response = await get(url);

      if (response.statusCode == 200) {
        // JSON 파싱
        final Map<String, dynamic> data = jsonDecode(response.body);

        // 최신 버전 정보 가져오기 (예: 'tag_name'이 버전 정보일 경우)
        final latestVersion = data['tag_name'];
        return Result(data: Version.parse(latestVersion));
      } else {
        throw Exception('Failed to load version');
      }
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
