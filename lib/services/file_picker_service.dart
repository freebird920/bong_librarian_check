import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerService {
  String get _localSaperator => Platform.pathSeparator;
  Future<void> pickPathAndSave(
      {required List<int> data,
      required String fileName,
      required String fileExtention}) async {
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

      // 파일에 데이터를 작성
      await file.writeAsBytes(data);

      print('파일이 저장되었습니다: $filePath');
    } else {
      print('저장 경로가 선택되지 않았습니다.');
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
