import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<void> saveExcelFile(Uint8List excelData) async {
  // 사용자가 저장할 경로를 선택하도록 함
  String? directoryPath = await FilePicker.platform.getDirectoryPath();

  if (directoryPath != null) {
    // 파일 이름과 경로를 지정하여 파일을 저장
    String filePath = '$directoryPath/my_excel_file.xlsx';
    File file = File(filePath);

    // 파일에 데이터를 작성
    await file.writeAsBytes(excelData);

    print('파일이 저장되었습니다: $filePath');
  } else {
    print('저장 경로가 선택되지 않았습니다.');
  }
}
