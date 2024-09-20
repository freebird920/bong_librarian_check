import 'dart:convert';

class Librarian {
  final String name;
  final int studentId;
  final int enteranceYear;
  int? day;
  String? description;

  Librarian({
    required this.name,
    required this.studentId,
    required this.enteranceYear,
    this.day,
    this.description,
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
