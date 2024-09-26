import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/version_service.dart';
import 'package:flutter/material.dart';
import 'package:pub_semver/pub_semver.dart';

class ProviderVersion with ChangeNotifier {
  ProviderVersion() {
    _getVersion();
    _getLatestVersion();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Version? _currentVersion;
  Version? get currentVersion => _currentVersion;
  Version? _latestVersion;
  Version? get latestVersion => _latestVersion;

  final VersionService _versionService = VersionService();
  Future<Version> _getVersion() async {
    Version currentVersion = await _versionService.getCurrentVersion();
    _currentVersion = currentVersion;
    notifyListeners();
    return currentVersion;
  }

  Future<Result<Version>> _getLatestVersion() async {
    final latestVersion = await _versionService.getLatestVersion();
    if (latestVersion.isSuccess && latestVersion.data != null) {
      _latestVersion = latestVersion.data;
    }
    _isLoading = false;
    notifyListeners();
    return latestVersion;
  }
}
