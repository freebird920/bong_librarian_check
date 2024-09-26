import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:flutter/services.dart';

class AssetFileService {
  final FilePickerService _filePickerService = FilePickerService();

  Future<Result<String>> copyAssetToLocal({
    required String assetPath,
    required String fileName,
    required String fileExtention,
  }) async {
    try {
      // 앱의 로컬 디렉토리 가져오기
      // asset에서 파일 읽기
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;

      // 로컬 파일로 저장
      Result<String> result = await _filePickerService.pickPathAndSave(
        data: buffer.asUint8List(),
        fileName: fileName,
        fileExtention: fileExtention,
      );
      if (result.isError) throw result.error!;
      if (result.isNull) throw Exception("Failed to copy asset to local");
      if (!result.isSuccess) throw Exception("Failed to copy asset to local");
      return result;
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }
}
