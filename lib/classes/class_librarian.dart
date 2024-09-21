import 'dart:convert';
import 'package:uuid/uuid.dart';

class Librarian {
  final String uuid;
  final String name;
  final int studentId;
  final int enteranceYear;
  int? _dayOfWeek;
  String? description;

  // dayOfWeek의 유효성 검사
  set dayOfWeek(int? value) {
    if (value != null && (value < 0 || value > 4)) {
      throw ArgumentError('dayOfWeek must be between 0 (Mon) and 4 (Fri)');
    }
    _dayOfWeek = value;
  }

  int? get dayOfWeek => _dayOfWeek;

  // 생성자
  Librarian({
    String? uuid,
    required this.name,
    required this.studentId,
    required this.enteranceYear,
    int? dayOfWeek,
    this.description,
  }) : uuid = uuid ?? const Uuid().v4() {
    this.dayOfWeek = dayOfWeek; // setter를 사용하여 dayOfWeek 설정
  }

  // JSON 데이터를 Librarian 객체로 변환하는 메서드
  factory Librarian.fromJson(Map<String, dynamic> json) {
    return Librarian(
      uuid: json['uuid'],
      name: json['name'], // JSON에서 'name' 필드를 가져옴
      studentId: json['studentId'], // JSON에서 'studentId' 필드를 가져옴
      enteranceYear: json['enteranceYear'], // JSON에서 'enteranceYear' 필드를 가져옴
      dayOfWeek: json['dayOfWeek'], // JSON에서 'dayOfWeek' 필드를 가져옴 (nullable)
      description:
          json['description'], // JSON에서 'description' 필드를 가져옴 (nullable)
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> get toJson {
    return {
      'uuid': uuid,
      'name': name,
      'studentId': studentId,
      'enteranceYear': enteranceYear,
      'dayOfWeek': dayOfWeek,
      'description': description,
    };
  }

  // 객체를 JSON 문자열로 변환하는 메서드
  String get toJsonString {
    return jsonEncode(toJson);
  }
}
