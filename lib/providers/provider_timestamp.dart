import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:flutter/material.dart';

class ProviderTimestamp with ChangeNotifier {
  final FileService _fileService = FileService();
  List<LibraryTimestamp> _timestamps = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<LibraryTimestamp> get data => _timestamps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTimestamps() async {
    _isLoading = true;
    notifyListeners(); // 로딩 상태 시작 알림

    try {
      final result = await _fileService.loadAllTimestamps();
      _timestamps = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 상태 종료 알림
    }
  }

  Future<void> saveTimestamp(LibraryTimestamp myTimestamp) async {
    await _fileService.saveTimestamp(myTimestamp);
    loadTimestamps();
  }
}
