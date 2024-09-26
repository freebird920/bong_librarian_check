import 'dart:io';
import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AssetFileService {
  Future<void> copyAssetToLocal(
      {required String assetPath, required String fileName}) async {
    try {
      // 앱의 로컬 디렉토리 가져오기
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // asset에서 파일 읽기
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;

      // 로컬 파일로 저장
      final FilePickerService filePickerService = FilePickerService();
      await filePickerService.pickPathAndSave(
          data: buffer.asUint8List(),
          fileName: fileName,
          fileExtention: "xlsx");

      print('파일이 성공적으로 로컬에 저장되었습니다: $filePath');
    } catch (e) {
      print('파일 복사 중 오류 발생: $e');
    }
  }
}
