import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._privateConstructor();
  // 싱글톤 인스턴스
  static final PreferenceService _instance =
      PreferenceService._privateConstructor();

  // 인스턴스에 접근하는 방법
  factory PreferenceService() {
    return _instance;
  }
  SharedPreferences? _prefs;
  bool get isInitialized => _prefs != null;
  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Result<bool>> setPrefBool(
      {required String key, required bool value}) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }

      final result = await _prefs?.setBool(key, value);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<bool>> setPrefString(
      {required String key, required String value}) async {
    try {
      if (_prefs == null) {
        await initPrefs();
      }
      final result = await _prefs?.setString(key, value);
      return Result(data: result ?? false);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  String? getPrefString(String key) {
    if (_prefs == null) {
      return null;
    }
    return _prefs?.getString(key);
  }

  bool? getPrefBool(String key) {
    if (_prefs == null) {
      return null;
    }
    return _prefs?.getBool(key);
  }
}
