import 'package:bong_librarian_check/classes/class_librarian.dart';
import 'package:bong_librarian_check/services/file_picker_service.dart';
import 'package:excel/excel.dart';
import 'package:uuid/uuid.dart';

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

    // JSON 데이터를 행으로 추가
    for (var data in jsonData) {
      sheetObject.appendRow(
        [
          TextCellValue(data.uuid),
          TextCellValue(data.name),
          TextCellValue(data.studentId),
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
        data: excelData,
        fileName: "librarians${DateTime.now().toIso8601String()}",
        fileExtention: "xlsx");
  }

  /// 엑셀 파일을 읽어서 List<Map<String, dynamic>> 형태로 변환
  Future<List<Librarian>> excelToJson() async {
    // 엑셀 파일을 선택
    final fileData = await FilePickerService().pickAndReadExcelFile();

    if (fileData == null) {
      return [];
    }

    // 엑셀 파일을 읽기
    final excel = Excel.decodeBytes(fileData);
    final Sheet? sheet = excel.sheets[excel.sheets.keys.first];

    // 데이터 파싱
    List<Map<String, dynamic>> dataFromFile = [];

    if (sheet != null) {
      // 첫 행은 헤더이므로 스킵
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.row(rowIndex);

        // 각 셀의 값을 가져와 필드 매핑
        if (row.length >= 3) {
          final enterenceYear = row[0]?.value?.toString();
          final studentId = row[1]?.value?.toString();
          final name = row[2]?.value?.toString();

          // 맵에 추가
          dataFromFile.add({
            'name': name,
            'studentId': studentId,
            'enterenceYear': enterenceYear,
          });
        }
      }
    }
    List<Librarian> librarians = dataFromFile
        .map((data) => Librarian(
              uuid: const Uuid().v4(),
              name: data['name'] ?? '',
              studentId: data['studentId'] ?? '',
              enteranceYear: int.tryParse(data['enterenceYear'] ?? '') ?? 0,
            ))
        .toList();
    return librarians;
  }
}
