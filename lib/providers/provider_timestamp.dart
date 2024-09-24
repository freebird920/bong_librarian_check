import 'package:flutter/material.dart';

// import class
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/classes/class_result.dart';

// import helper
import 'package:bong_librarian_check/helper/helper_daytime.dart';

// import service
import 'package:bong_librarian_check/services/timestamp_service.dart';

class ProviderTimestamp with ChangeNotifier {
  final TimestampService _timestampService = TimestampService();
  List<LibraryTimestamp> _timestamps = [];
  String? _errorMessage;
  bool _isLoading = false;
  List<LibraryTimestamp> get data => _timestamps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProviderTimestamp() {
    loadTimestamps();
  }

  Future<void> loadTimestamps() async {
    _isLoading = true;
    notifyListeners(); // 로딩 상태 시작 알림

    try {
      final result = await _timestampService.loadAllTimestamps();
      _timestamps = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // 로딩 상태 종료 알림
    }
  }

  /// # getTimestampByDayLuuid
  /// - 특정 날짜와 이용자의 uuid를 통해 해당 날짜의 timestamp를 필터링하여 반환
  /// ## @params
  /// - DateTime thisDay
  /// - String librarianUuid
  /// ## Usages
  /// ```dart
  /// // timestamps 필터링
  /// final timestamps = await getTimestampsByDayLuuid(thisDay,uuid);
  /// if(timestamps.isError) { throw timestamp.error; }
  /// final LibraryTimestamp latestTimestamp = timestamps.data!.last
  /// ```
  Result<List<LibraryTimestamp>> getTimestampsByDayLibrarianUuid({
    required DateTime thisDay,
    required String librarianUuid,
  }) {
    try {
      // 1. 최초 로드 확인 -> 로드 되지 않았으면 로드

      // 2. 필터링
      final filteredTimestamps = _timestamps
          .where(
              (LibraryTimestamp e) => isSameDay(thisDay, e.timestamp)) // 날짜 필터링
          .where((LibraryTimestamp e) =>
              e.librarianUuid == librarianUuid) // librarian uuid 필터링
          .toList();

      // 3. 결과 값 리턴
      return Result(data: filteredTimestamps);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Result<bool> checkTodayStamp(String librarianUuid) {
    try {
      final allTimestamps = _timestamps;
      final today = DateTime.now();
      final todayTimestamp = allTimestamps
          .where(
            (timestamp) => isSameDay(today, timestamp.timestamp),
          )
          .where(
            (element) => element.librarianUuid == librarianUuid,
          )
          .toList();
      final checkTimeStamp = todayTimestamp.isNotEmpty;
      return Result(data: checkTimeStamp);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Result<String> getTodayTimeStampbyLibrarianUuid(String librarianUuid) {
    try {
      final allTimestamps = _timestamps;
      final today = DateTime.now();
      final myTodayTimestamp = allTimestamps
          .where(
            (timestamp) =>
                isSameDay(today, timestamp.timestamp) &&
                timestamp.librarianUuid == librarianUuid,
          )
          .toList();
      if (myTodayTimestamp.isEmpty) {
        return Result(data: null);
      }
      return Result(data: myTodayTimestamp.first.uuid);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<void> saveTimestamp(LibraryTimestamp myTimestamp) async {
    await _timestampService.saveTimestamp(myTimestamp);
    loadTimestamps();
  }

  Future<Result<LibraryTimestamp>> getTimestampByUuid(
      String timestampUuid) async {
    final result = await _timestampService.getTimestampByUuid(timestampUuid);
    return result;
  }

  Future<void> updateTimestamp({
    required LibraryTimestamp newTimestamp,
  }) async {
    await _timestampService.updateTimestamp(
      timestampUuid: newTimestamp.uuid,
      newTimestamp: newTimestamp,
    );
    loadTimestamps();
  }
}
