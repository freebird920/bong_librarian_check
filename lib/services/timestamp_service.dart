import 'dart:convert';
import 'dart:io';

import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/file_service.dart';

class TimestampService {
  TimestampService._privateConstructor();
  static final TimestampService _instance =
      TimestampService._privateConstructor();
  factory TimestampService() {
    return _instance;
  }

  final _fileService = FileService();
  String get _localSaperator => Platform.pathSeparator;

  Future<List<String>> getMonthFiles(int year) async {
    final myLocalPath = await _fileService.localPath;
    if (myLocalPath.isError) {
      throw myLocalPath.error!;
    }
    final directoryPath =
        '${myLocalPath.data}${_localSaperator}timestamps$_localSaperator$year';
    final directory = Directory(directoryPath);

    // 폴더가 있는지 확인
    if (!directory.existsSync()) {
      return [];
    }

    // 해당 연도의 월 파일 리스트 가져오기
    final List<String> monthFiles = [];
    await for (var entity in directory.list()) {
      if (entity is File) {
        final fileName = entity.path.split(_localSaperator).last; // 파일명만 추출
        monthFiles.add(fileName);
      }
    }

    return monthFiles;
  }

  Future<List<String>> getYearDirectories() async {
    final myLocalPath = await _fileService.localPath;
    if (myLocalPath.error != null) {
      throw myLocalPath.error!;
    }

    final directoryPath = '${myLocalPath.data}${_localSaperator}timestamps';
    final directory = Directory(directoryPath);

    // 폴더가 있는지 확인
    if (!directory.existsSync()) {
      return [];
    }

    final yearDirectories = await directory
        .list()
        .where((entity) => entity is Directory)
        .map((entity) => entity.path.split(Platform.pathSeparator).last)
        .toList();

    return yearDirectories;
  }

  Future<List<LibraryTimestamp>> loadAllTimestamps() async {
    final List<LibraryTimestamp> allTimestamps = [];
    final myLocalPath = await _fileService.localPath;
    if (myLocalPath.isError) {
      throw myLocalPath.error!;
    }
    // 연도 디렉토리 리스트 가져오기
    final yearDirectories = await getYearDirectories();
    for (var year in yearDirectories) {
      // 월별 파일 리스트 가져오기
      final monthFiles = await getMonthFiles(int.parse(year));
      for (var monthFile in monthFiles) {
        final filePath =
            '${myLocalPath.data}${_localSaperator}timestamps$_localSaperator$year$_localSaperator$_localSaperator$monthFile';
        final file = File(filePath);
        if (file.existsSync()) {
          final fileContent = await file.readAsString();
          final List<dynamic> jsonList = jsonDecode(fileContent);
          final timestamps =
              jsonList.map((json) => LibraryTimestamp.fromJson(json)).toList();
          allTimestamps.addAll(timestamps);
        }
      }
    }

    return allTimestamps;
  }

  Future<void> saveTimestamp(LibraryTimestamp timestamp) async {
    final myLocalPath = await _fileService.localPath;

    final yearString = timestamp.timestamp.year;
    final monthString =
        timestamp.timestamp.month.toString().padLeft(2, '0'); // 01, 02 등

    final directoryPath =
        '${myLocalPath.data}${_localSaperator}timestamps$_localSaperator$yearString';
    final filePath =
        '$directoryPath$_localSaperator$yearString$monthString.json';
    // 디렉토리 확인 및 생성
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final file = File(filePath);

    // 기존 파일에서 데이터를 읽어오고 추가
    List<Map<String, dynamic>> existingTimestamps = [];
    if (file.existsSync()) {
      final fileContent = await file.readAsString();
      existingTimestamps =
          List<Map<String, dynamic>>.from(jsonDecode(fileContent));
    }

    // 새 타임스탬프 추가
    existingTimestamps.add(timestamp.toJson());

    // 파일에 다시 저장
    await file.writeAsString(jsonEncode(existingTimestamps),
        mode: FileMode.write);
  }

  Future<Result<LibraryTimestamp>> getTimestampByUuid(
      String timesampUuid) async {
    try {
      final allTimestamps = await loadAllTimestamps();
      final timestamp =
          allTimestamps.firstWhere((element) => element.uuid == timesampUuid);
      return Result(data: timestamp);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<LibraryTimestamp>> updateTimestamp({
    required String timestampUuid,
    required LibraryTimestamp newTimestamp,
  }) async {
    try {
      final myLocalPath = await _fileService.localPath;

      final yearString = newTimestamp.timestamp.year;
      final monthString =
          newTimestamp.timestamp.month.toString().padLeft(2, '0'); // 01, 02 등

      final directoryPath =
          '${myLocalPath.data}${_localSaperator}timestamps$_localSaperator$yearString';
      final filePath =
          '$directoryPath$_localSaperator$yearString$monthString.json';
      // 디렉토리 확인 및 생성
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final file = File(filePath);

      // 기존 파일에서 데이터를 읽어오고 추가
      List<Map<String, dynamic>> existingTimestamps = [];
      if (file.existsSync()) {
        final fileContent = await file.readAsString();
        existingTimestamps =
            List<Map<String, dynamic>>.from(jsonDecode(fileContent));
      }

      // 기존 타임스탬프 제거
      existingTimestamps
          .removeWhere((element) => element['uuid'] == timestampUuid);

      // 새 타임스탬프 추가
      existingTimestamps.add(newTimestamp.toJson());

      // 파일에 다시 저장
      await file.writeAsString(jsonEncode(existingTimestamps),
          mode: FileMode.write);
      return Result(data: newTimestamp);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
