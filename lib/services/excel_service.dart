import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:excel/excel.dart';

class ExcelService {
  void jsonToExcel(List<Librarian> jsonData) {
    // 엑셀 파일 생성
    var excel = Excel.createExcel();

    // 첫 번째 시트 선택
    Sheet sheetObject = excel['Sheet1'];

    // 열 헤더 추가
    sheetObject.appendRow([
      TextCellValue('UUID'),
      TextCellValue('Name'),
      TextCellValue('Student ID'),
      TextCellValue('Enterance Year'),
      TextCellValue('Work Days'),
      TextCellValue('Description')
    ]);

    // JSON 데이터를 행으로 추가
    for (var data in jsonData) {
      sheetObject.appendRow([
        TextCellValue(data.uuid),
        TextCellValue(data.name),
        TextCellValue(data.studentId.toString()),
        TextCellValue(data.enteranceYear.toString()),
        TextCellValue(data.description ?? '') // description이 null일 경우 빈 문자열 처리
      ]);
    }

    // 파일로 저장
    var excelData = excel.encode();
    if (excelData == null) {
      return;
    }
    FilePickerService().pickPathAndSave(
        data: excelData, fileName: "librarians", fileExtention: "xlsx");
  }

  Future<void> createAndSaveExcelFile() async {
    // 엑셀 파일 생성
    Excel excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    sheetObject.appendRow([TextCellValue("text"), TextCellValue("123")]);

    // 엑셀 데이터를 Uint8List로 변환
    final excelData = excel.encode();
    if (excelData == null) {
      print('엑셀 데이터가 null입니다.');
      return;
    }
    FilePickerService().pickPathAndSave(
        data: excelData, fileName: "shit", fileExtention: "xlsx");
  }
}
