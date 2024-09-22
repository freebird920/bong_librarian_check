String? studentIdValidator(String? value) {
  if (value == null) {
    return '학번을 입력해주세요.';
  }
  if (value.length != 5) {
    return '학번은 5자리로 입력해주세요.';
  }
  var intValue = int.tryParse(value);
  if (intValue != null && (intValue < 10000 || intValue > 99999)) {
    return '학번은 10000부터 99999까지 입력해주세요.';
  }
  return null;
}
