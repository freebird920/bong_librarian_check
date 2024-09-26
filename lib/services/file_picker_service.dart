import 'dart:typed_data';

import 'package:bong_librarian_check/classes/class_result.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerService {
  String get _localSaperator => Platform.pathSeparator;

  /// # pickPathAndSave()
  /// - 사용자가 저장할 경로를 선택하도록 함
  /// @Params
  /// - data: 저장할 데이터
  /// - fileName: 저장할 파일 이름
  /// - fileExtention: 저장할 파일 확장자
  /// @Return
  /// - Result<String>: 성공 시 파일 경로 String, 실패 시 Exception
  Future<Result<String>> pickPathAndSave({
    required List<int> data,
    required String fileName,
    required String fileExtention,
  }) async {
    try {
      // 사용자가 저장할 경로를 선택하도록 함
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        // 파일 이름과 경로를 지정하여 파일을 저장
        String filePath =
            '$directoryPath$_localSaperator$fileName.$fileExtention';
        File file = File(filePath);

        // 파일이 이미 존재하는지 확인
        int count = 1;
        while (await file.exists()) {
          // 파일 이름에 숫자를 붙여 고유한 이름 생성
          String newFileName = '${fileName}_$count.$fileExtention';
          filePath = '$directoryPath$_localSaperator$newFileName';
          file = File(filePath);
          count++;
        }

        // 파일에 데이터를 작성 (저장)
        await file.writeAsBytes(data);

        return Result(data: filePath);
      } else {
        throw Exception('파일 경로를 선택하지 않았습니다.');
      }
    } catch (e) {
      return Result(error: e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Uint8List?> pickAndReadExcelFile() async {
    // 파일 선택 (엑셀 파일만)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      // 선택한 파일 경로 가져오기
      final filePath = result.files.single.path;

      if (filePath != null) {
        // 파일 읽기
        final file = File(filePath);
        return await file.readAsBytes();
      }
    }

    // 파일을 선택하지 않았거나 읽을 수 없으면 null 반환
    return null;
  }
}
