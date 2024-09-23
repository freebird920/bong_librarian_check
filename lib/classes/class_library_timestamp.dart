class LibraryTimestamp {
  final String librarianUuid;
  final DateTime timestamp;

  const LibraryTimestamp({
    required this.timestamp,
    required this.librarianUuid,
  });

  // JSON으로 변환하기 위한 메서드
  Map<String, dynamic> toJson() {
    return {
      'librarianUuid': librarianUuid,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // JSON에서 LibrarianTimestamp 객체로 변환하기 위한 메서드
  factory LibraryTimestamp.fromJson(Map<String, dynamic> json) {
    return LibraryTimestamp(
      librarianUuid: json['librarianUuid'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
