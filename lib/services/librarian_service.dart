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
  Future<Result<String>> get _librarianPath async {
    try {
      Result<String> localPath = await _fileService.localPath;
      if (localPath.isError) {
        throw localPath.error ??
            Exception("_librarianPath: Cannot get local path");
      }
      if (localPath.isSuccess) {
        final String customPath =
            "${localPath.data}${Platform.pathSeparator}librarians";
        final customDir = Directory(customPath);
        if (!(await customDir.exists())) {
          await customDir.create(recursive: true);
        }
        return Result(
            data: "${localPath.data}${Platform.pathSeparator}librarians");
      }
      throw Exception("_librarianPath: unknown error");
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

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
      final path = await _librarianPath;
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

  Future<Result<List<String>>> getFileStringListByYear() async {
    try {
      final myLocalPath = await _librarianPath;
      if (myLocalPath.isError || myLocalPath.isNull) {
        throw myLocalPath.error ??
            Exception("getFileListByYear: Cannot get local path");
      }
      final directory = Directory(myLocalPath.data!);

      // 폴더가 있는지 확인
      if (!directory.existsSync()) {
        return Result(data: []);
      }

      final yearDirectories = await directory
          .list()
          .where((entity) => entity is File)
          .map((entity) => entity.path.split(Platform.pathSeparator).last)
          .toList();

      return Result(data: yearDirectories);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<List<Librarian>>> getAllYearLibrarians() async {
    try {
      final files = await getFilesListByYear();
      if (files.isError || files.isNull) {
        throw files.error ??
            Exception("getAllYearLibrarians: Cannot get files");
      }
      final result = await Future.wait(files.data!.map(
        (File e) async => await readLibrariansFile(e),
      ));
      // 각 Result에서 data를 추출하고 병합
      final allLibrarians = result
          .where(
            (result) => result.isSuccess && !result.isNull && !result.isError,
          ) // 성공한 결과만 필터링
          .expand((result) => result.data!) // Librarian 리스트들을 1차원 배열로 확장
          .toList();
      return Result(data: allLibrarians);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Result<List<File>>> getFilesListByYear() async {
    try {
      final myLocalPath = await _librarianPath;
      if (myLocalPath.isError || myLocalPath.isNull) {
        throw myLocalPath.error ??
            Exception("getFileListByYear: Cannot get local path");
      }
      final directory = Directory(myLocalPath.data!);

      // 폴더가 있는지 확인
      if (!directory.existsSync()) {
        return Result(data: []);
      }

      final files = await directory
          .list()
          .where((entity) => entity is File)
          .cast<File>()
          // .map((entity) => File(entity.uri.path))
          .toList();
      return Result(data: files);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  // 파일에서 Librarians 데이터를 읽어오기
  Future<Result<List<Librarian>>> readLibrariansFile(File file) async {
    try {
      // 파일 읽기
      final jsonString = await file.readAsString();
      late List<dynamic> jsonData;
      try {
        jsonData = jsonDecode(jsonString);
      } catch (e) {
        return Result(
            error: e is Exception ? e : FormatException(e.toString()));
      }

      // Librarian 리스트로 변환
      final librarians = jsonData.map((data) {
        return Librarian.fromJson(data);
      }).toList();

      return Result(data: librarians);
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
