import 'dart:io';
import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  // 애플리케이션 문서 디렉터리 경로 가져오기
  Future<Result<String>> get _localPath async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return Result(data: directory.path);
    } catch (e) {
      return Result(
        error: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  // 특정 파일에 대한 경로 가져오기
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }
}
