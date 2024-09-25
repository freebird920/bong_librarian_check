import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:excel/excel.dart';

class CustomCell<T> {
  final int columnIndex;
  final int rowIndex;
  final T value;
  CustomCell({
    required this.columnIndex,
    required this.rowIndex,
    required this.value,
  });
}

class ExcelService {
  void jsonToExcel(List<Librarian> jsonData) {
    // 엑셀 파일 생성
    var excel = Excel.createExcel();

    // 첫 번째 시트 선택
    Sheet sheetObject = excel['Sheet1'];

    // 열 헤더 추가
    sheetObject.appendRow([
      TextCellValue('1_Enterance Year'),
      TextCellValue('2_Name'),
      TextCellValue('3_Student ID'),
      TextCellValue('4_Work Days'),
      TextCellValue('5_Description'),
      TextCellValue('9_UUID**절대직접입력수정금지**'),
    ]);

    CellStyle cellStyle = CellStyle(
      leftBorder: Border(borderStyle: BorderStyle.Thin),
      rightBorder: Border(borderStyle: BorderStyle.Thin),
      topBorder: Border(
          borderStyle: BorderStyle.Thin,
          borderColorHex: ExcelColor.fromHexString('FFFF0000')),
      bottomBorder: Border(
          borderStyle: BorderStyle.Medium,
          borderColorHex: ExcelColor.fromHexString('FF0000FF')),
    );
    // JSON 데이터를 행으로 추가
    for (var data in jsonData) {
      sheetObject.appendRow(
        [
          TextCellValue(data.uuid),
          TextCellValue(data.name),
          IntCellValue(data.studentId),
          IntCellValue(data.enteranceYear),
          TextCellValue(
              data.description ?? '') // description이 null일 경우 빈 문자열 처리
        ],
      );
    }

    /// It will put the list-iterables in the 8th index row
    List<CellValue> dataList = [
      TextCellValue('Google'),
      TextCellValue('loves'),
      TextCellValue('Flutter'),
      TextCellValue('and'),
      TextCellValue('Flutter'),
      TextCellValue('loves'),
      TextCellValue('Excel')
    ];

    sheetObject.insertRowIterables(dataList, 8);
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

    var cell = sheetObject
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cell.value = TextCellValue("text");
    cell.cellStyle = CellStyle(
      bold: true,
      italic: true,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
      textWrapping: TextWrapping.WrapText,
      horizontalAlign: HorizontalAlign.Right,
      verticalAlign: VerticalAlign.Bottom,
      rotation: 90,
    );
    // 엑셀 데이터를 Uint8List로 변환
    final excelData = excel.encode();
    if (excelData == null) {
      return;
    }
    FilePickerService().pickPathAndSave(
        data: excelData, fileName: "shit", fileExtention: "xlsx");
  }
}
