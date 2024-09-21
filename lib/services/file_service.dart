import 'dart:convert';
import 'dart:io';
import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  // 애플리케이션 디렉터리 경로 가져오기
  Future<Result<String>> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      // bong_librarian_check 폴더 경로 설정
      final customDirPath = "${directory.path}/bong_librarian_check";
      // 디렉터리가 없으면 생성
      final customDir = Directory(customDirPath);
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true); // 하위 폴더까지 생성
      }
      return Result(data: "${directory.path}/bong_librarian_check");
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
      final path = await _localPath;
      final result = File('$path/$filePath');
      return Result(data: result);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e),
      );
    }
  }

  // 파일에서 Librarians 데이터를 읽어오기
  Future<Result<List<Librarian>>> readLibrarians() async {
    try {
      final path = await _localPath;
      final file = File('${path.data}/librarians.json');

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
      final path = await _localPath;
      final jsonString =
          jsonEncode(librarians.map((lib) => lib.toJson).toList());
      final file = File('${path.data}/librarians.json');

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
