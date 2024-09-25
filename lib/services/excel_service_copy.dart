import 'package:excel/excel.dart' as excel_package;

class CellHeader {
  CellHeader();
  Map<int, String> get toMap => {
        1: 'Enterance Year',
        2: 'Name',
        3: 'Student ID',
        4: 'Work Days',
        5: 'Description',
        6: 'UUID**절대직접입력수정금지**',
      };
}

class CustomCell<T> {
  final int columnIndex;
  final int rowIndex;
  final T value;
  final excel_package.CellStyle style;
  CustomCell({
    required this.columnIndex,
    required this.rowIndex,
    required this.value,
    excel_package.CellStyle? style,
  }) : style = style ?? excel_package.CellStyle();

  excel_package.CellIndex get cellIndex {
    return excel_package.CellIndex.indexByColumnRow(
      columnIndex: columnIndex,
      rowIndex: rowIndex,
    );
  }

  excel_package.CellValue get cellValue {
    if (value is String) {
      return excel_package.TextCellValue(value as String);
    } else if (value is int) {
      return excel_package.IntCellValue(value as int);
    } else {
      throw Exception("Invalid type");
    }
  }
}

class ExcelService {
  excel_package.Excel _excel() => excel_package.Excel.createExcel();

  void createAndSaveExcelFile(List<CustomCell> cells) {
    final excel_package.Excel excel = _excel();
    final sheet = excel['Sheet1'];

    void addRows() {
      for (final cell in cells) {
        sheet.cell(cell.cellIndex).value = cell.cellValue;
        sheet.cell(cell.cellIndex).cellStyle = cell.style;
      }
    }

    for (final cell in cells) {
      sheet.cell(cell.cellIndex).value = cell.cellValue;
      sheet.cell(cell.cellIndex).cellStyle = cell.style;
    }
  }
}
