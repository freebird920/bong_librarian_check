import 'package:bong_librarian_check/classes/class_result.dart';

Result<String> dayOfWeekParser(int? intDayOfWeek) {
  try {
    String result;
    switch (intDayOfWeek) {
      case 1:
        result = "월";
      case 2:
        result = "화";
      case 3:
        result = "수";
      case 4:
        result = "목";
      case 5:
        result = "금";
      default:
        throw Exception("요일을 변환할 수 없습니다.");
    }
    return Result(data: result);
  } catch (e) {
    return Result(error: e is Exception ? e : Exception(e.toString()));
  }
}
