import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/services/file_service.dart';
import 'package:flutter/material.dart';

class ProviderLibrarian with ChangeNotifier {
  final FileService _fileService = FileService();
  List<Librarian> _librarians = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Librarian> get data => _librarians;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 초기화 및 Librarian 데이터 로드
  Future<void> loadLibrarians() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // UI 갱신

    try {
      final result = await _fileService.readLibrarians();
      if (result.isSuccess && result.data != null) {
        _librarians = result.data!;
        print(_librarians);
      } else {
        _errorMessage = result.error?.toString();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 종료 후 UI 갱신
    }
  }

  // Librarian 추가
  Future<void> addLibrarian(Librarian librarian) async {
    _librarians.add(librarian);
    await _saveLibrarians(); // 저장 후 갱신
  }

  // Librarian 삭제
  Future<void> removeLibrarian(String uuid) async {
    _librarians.removeWhere((librarian) => librarian.uuid == uuid);
    await _saveLibrarians(); // 저장 후 갱신
  }

  // Librarian 목록을 파일에 저장
  Future<void> _saveLibrarians() async {
    try {
      await _fileService.writeLibrarians(_librarians);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
