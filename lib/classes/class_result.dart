class Result<T> {
  final T? data; // 성공했을 때 반환할 데이터
  final Exception? error; // 실패했을 때 반환할 에러 메시지
  Result({this.data, this.error})
      : assert(data != null || error != null,
            'Either data or error must be non-null');

  /// # getSuccesData
  /// - **반드시 isSuccess 확인 후 사용!**
  /// - 성공했을 때 반환할 데이터를 반환합니다.
  T get getSuccessData {
    if (data == null) {
      throw Exception('Data is null');
    } else {
      return data!;
    }
  }

  bool get isSuccess => (error == null && data != null);
  bool get isNull => (error == null && data == null);
  // 실패 여부 확인
  bool get isError => error != null;
}
