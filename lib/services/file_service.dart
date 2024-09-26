import 'dart:convert';
import 'dart:io';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_library_timestamp.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  // 1. private 생성자
  FileService._privateConstructor();

  // 2. static 변수로 유일한 인스턴스 생성
  static final FileService _instance = FileService._privateConstructor();

  // 3. 외부에서 접근할 수 있는 인스턴스 제공자
  factory FileService() {
    return _instance;
  }

  String get _localSaperator => Platform.pathSeparator;
  // 애플리케이션 디렉터리 경로 가져오기
  Future<Result<String>> get localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      // bong_librarian_check 폴더 경로 설정
      final customDirPath =
          "${directory.path}${_localSaperator}bong_librarian_check";
      // 디렉터리가 없으면 생성
      final customDir = Directory(customDirPath);
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true); // 하위 폴더까지 생성
      }
      return Result(
          data: "${directory.path}${_localSaperator}bong_librarian_check");
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  // 특정 파일에 대한 경로 가져오기

  /// - filePath: 파일 경로
  /// - 파일경로: "${directory.path}/bong_librarian_check"
  Future<Result<File>> localFile(String filePath) async {
    try {
      final path = await localPath;
      final result = File('${path.data}$_localSaperator$filePath');
      return Result(data: result);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e),
      );
    }
  }

  Future<List<String>> getMonthFiles(int year) async {
    final myLocalPath = await localPath;
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
    final myLocalPath = await localPath;
    if (myLocalPath.error != null) {
      throw myLocalPath.error!;
    }

    final directoryPath = '${myLocalPath.data}${_localSaperator}timestamps';
    final directory = Directory(directoryPath);

    // 폴더가 있는지 확인
    if (!directory.existsSync()) {
      return [];
    }

    // 폴더 내의 디렉토리 리스트 가져오기
    final List<String> yearDirectories = [];
    await for (var entity in directory.list()) {
      if (entity is Directory) {
        final dirName =
            entity.path.split(Platform.pathSeparator).last; // 마지막 부분만 가져오기
        yearDirectories.add(dirName);
      }
    }

    return yearDirectories;
  }

  Future<List<LibraryTimestamp>> loadAllTimestamps() async {
    final List<LibraryTimestamp> allTimestamps = [];
    final myLocalPath = await localPath;
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
    final myLocalPath = await localPath;

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

  // 파일에서 Librarians 데이터를 읽어오기
  Future<Result<List<Librarian>>> readLibrarians() async {
    try {
      final path = await localPath;
      final file = File('${path.data}${_localSaperator}librarians.json');

      if (!(await file.exists())) {
        return Result(data: []); // 파일이 없으면 빈 리스트 반환
      }

      // 파일 읽기
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);

      // Librarian 리스트로 변환
      final librarians = jsonData.map((data) {
        return Librarian.fromJson(data);
      }).toList();

      return Result(data: librarians);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  // Write the list of librarians to a JSON file
  /// - librarians: List<Librarian>
  Future<Result<File>> writeLibrarians(List<Librarian> librarians) async {
    try {
      final path = await localPath;
      final jsonString =
          jsonEncode(librarians.map((lib) => lib.toJson).toList());
      final file = File('${path.data}${_localSaperator}librarians.json');

      final result = Result(
        data: await file.writeAsString(
          jsonString,
          encoding: utf8,
          mode: FileMode.write,
        ),
      );

      return result;
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e),
      );
    }
  }
}
