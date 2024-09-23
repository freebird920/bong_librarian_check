import 'dart:convert';
import 'package:uuid/uuid.dart';

class Librarian {
  final String uuid;
  final String name;
  final int studentId;
  final int enteranceYear;
  List<int>? workDays;
  String? description;

  // 생성자
  Librarian({
    String? uuid,
    required this.name,
    required this.studentId,
    required this.enteranceYear,
    List<int>? workDays,
    this.description,
  })  : uuid = uuid ?? const Uuid().v4(),
        workDays = workDays ?? []; // workDays를 직접 설정

  // JSON 데이터를 Librarian 객체로 변환하는 메서드
  factory Librarian.fromJson(Map<String, dynamic> json) {
    return Librarian(
      uuid: json['uuid'],
      name: json['name'],
      studentId: json['studentId'],
      enteranceYear: json['enteranceYear'],
      workDays:
          json['workDays'] != null ? List<int>.from(json['workDays']) : null,
      description: json['description'],
    );
  }

  // 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> get toJson {
    return {
      'uuid': uuid,
      'name': name,
      'studentId': studentId,
      'enteranceYear': enteranceYear,
      'workDays': workDays,
      'description': description,
    };
  }

  // 객체를 JSON 문자열로 변환하는 메서드
  String get toJsonString {
    return jsonEncode(toJson);
  }
}
