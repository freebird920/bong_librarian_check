import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/librarian_service.dart';
import 'package:flutter/material.dart';

class ProviderLibrarian with ChangeNotifier {
  final LibrarianService _librarianService = LibrarianService();
  List<Librarian> _librarians = [];
  bool _isLoading = false;
  String? _errorMessage;

  ProviderLibrarian() {
    loadLibrarians();
  }

  // Getters
  List<Librarian> get data => _librarians;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 초기화 및 Librarian 데이터 로드
  Future<void> loadLibrarians() async {
    _isLoading = true;
    notifyListeners(); // UI 갱신

    try {
      final result = await _librarianService.getAllYearLibrarians();
      if (result.isSuccess && result.data != null) {
        _librarians = result.data!;
      } else if (result.isError) {
        throw result.error.toString();
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 종료 후 UI 갱신
    }
  }

  Result<Librarian> getLibrarian(String uuid) {
    final results = _librarians.where((librarian) => librarian.uuid == uuid);
    if (results.isNotEmpty) {
      return Result(data: results.first);
    }
    return Result(error: Exception("Librarian not found"));
  }

  // Librarian 추가
  /// # addLibrarian(Librarian librarian)
  /// - Librarian 객체를 받아서 해당 객체를 List에 추가
  /// ## Return Result<String>
  /// - 추가된 Librarian의 uuid를 반환
  Future<Result<String>> addLibrarian(Librarian librarian) async {
    try {
      _librarians.add(librarian);
      await _saveLibrarians(); // 저장 후 갱신
      return Result(data: librarian.uuid);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  // Librarian 삭제
  Future<void> removeLibrarian(String uuid) async {
    _librarians.removeWhere((librarian) => librarian.uuid == uuid);
    await _saveLibrarians(); // 저장 후 갱신
  }

  // Librarian 수정
  /// 수정할 Librarian 객체를 받아서 해당 객체의 uuid를 찾아서 수정
  /// Return
  Future<Result<String>> updateLibrarian(Librarian librarian) async {
    try {
      final index = _librarians.indexWhere((lib) => lib.uuid == librarian.uuid);
      if (index == -1) {
        throw Exception("Librarian not found");
      }
      _librarians[index] = librarian;

      await _saveLibrarians();

      return Result(data: librarian.uuid); // 저장 후 갱신
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  // Librarian 목록을 파일에 저장
  Future<Result<bool>> _saveLibrarians() async {
    try {
      await _librarianService.writeLibrarians(_librarians);
      loadLibrarians();
      return Result(data: true); // 저장 후 다시 로드
    } catch (e) {
      notifyListeners();
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
