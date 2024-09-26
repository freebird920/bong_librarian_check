import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:flutter/services.dart';

class AssetFileService {
  Future<void> copyAssetToLocal(
      {required String assetPath, required String fileName}) async {
    try {
      // 앱의 로컬 디렉토리 가져오기

      // asset에서 파일 읽기
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;

      // 로컬 파일로 저장
      final FilePickerService filePickerService = FilePickerService();
      await filePickerService.pickPathAndSave(
          data: buffer.asUint8List(),
          fileName: fileName,
          fileExtention: "xlsx");
    } catch (e) {}
  }
}
