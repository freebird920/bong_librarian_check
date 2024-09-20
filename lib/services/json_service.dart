import 'dart:convert';

class JsonService {}

class Librarian {
  final String name;
  final int studentId;
  final int enteranceYear;
  int? day;

  Librarian({
    required this.name,
    required this.studentId,
    required this.enteranceYear,
    this.day,
  });

  Map<String, dynamic> get toJson {
    return {
      'name': name,
      'studentId': studentId,
      'enteranceYear': enteranceYear,
      'day': day,
    };
  }

  String get toJsonString {
    return jsonEncode(toJson);
  }
}
