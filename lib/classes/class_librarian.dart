import 'dart:convert';

class Librarian {
  final String name;
  final int day;
  final int studentId;
  String? description;

  Librarian({
    required this.name,
    required this.day,
    required this.studentId,
    this.description,
  });

  // 객체를 Map으로 변환하는 toJson 메서드
  Map<String, dynamic> _toJson() {
    return {
      'name': name,
      'day': day,
      'studentId': studentId,
      'description': description,
    };
  }

  // Map을 JSON 문자열로 변환하는 toJsonString 메서드
  String toJsonString() {
    return jsonEncode(_toJson());
  }
}
