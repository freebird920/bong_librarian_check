import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/preference_service.dart';
import 'package:flutter/material.dart';

class ProviderPreference with ChangeNotifier {
  final PreferenceService _preferenceService = PreferenceService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProviderPreference() {
    loadPreferences();
  }

  // 초기화 및 Preference 데이터 로드
  Future<void> loadPreferences() async {
    _isLoading = true;
    await _preferenceService.initPrefs();
    _isLoading = false;
    notifyListeners(); // UI 갱신
  }

  bool? getPrefBool(String key) {
    return _preferenceService.getPrefBool(key);
  }

  Future<Result<bool>> setPrefBool(
      {required String key, required bool value}) async {
    try {
      final result =
          await _preferenceService.setPrefBool(key: key, value: value);
      if (result.isError || result.error != null) throw result.error!;
      if (result.isNull) throw Exception("result is null");
      return Result(data: result.data);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    } finally {
      notifyListeners(); // UI 갱신
    }
  }
}
