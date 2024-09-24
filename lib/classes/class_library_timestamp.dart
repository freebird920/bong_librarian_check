import 'package:uuid/uuid.dart';

class LibraryTimestamp {
  final String uuid;
  final String librarianUuid;
  final DateTime timestamp;
  DateTime? exitTimestamp;

  LibraryTimestamp({
    String? uuid,
    required this.timestamp,
    required this.librarianUuid,
    this.exitTimestamp,
  }) : uuid = uuid ?? const Uuid().v4();

  // JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'librarianUuid': librarianUuid,
      'timestamp': timestamp.toIso8601String(),
      'exitTimestamp': exitTimestamp?.toIso8601String(),
    };
  }

  // JSON에서 LibrarianTimestamp 객체로 변환하기 위한 메서드
  factory LibraryTimestamp.fromJson(Map<String, dynamic> json) {
    return LibraryTimestamp(
      uuid: json['uuid'],
      librarianUuid: json['librarianUuid'],
      timestamp: DateTime.parse(json['timestamp']),
      exitTimestamp: json['exitTimestamp'] != null
          ? DateTime.parse(json['exitTimestamp'])
          : null,
    );
  }
}
