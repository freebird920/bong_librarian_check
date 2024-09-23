import 'dart:convert';
import 'dart:io';

import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/file_service.dart';

class LibrarianService {
  LibrarianService._privateConstructor();
  static final LibrarianService _instance =
      LibrarianService._privateConstructor();
  factory LibrarianService() {
    return _instance;
  }

  final _fileService = FileService();
  String get _localSaperator => Platform.pathSeparator;

  // 파일에서 Librarians 데이터를 읽어오기
  Future<Result<List<Librarian>>> readLibrarians() async {
    try {
      final path = await _fileService.localPath;
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
      final path = await _fileService.localPath;
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

  Future<Result<List<String>>> getYearDirectories() async {
    try {
      final myLocalPath = await _fileService.localPath;
      if (myLocalPath.error != null) {
        throw myLocalPath.error!;
      }

      final directoryPath = '${myLocalPath.data}${_localSaperator}librarians';
      final directory = Directory(directoryPath);

      // 폴더가 있는지 확인
      if (!directory.existsSync()) {
        return Result(data: []);
      }

      final yearDirectories = await directory
          .list()
          .where((entity) => entity is Directory)
          .map((entity) => entity.path.split(Platform.pathSeparator).last)
          .toList();

      return Result(data: yearDirectories);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
