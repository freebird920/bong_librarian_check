bool isSameDay(DateTime firstDate, DateTime secondDate) {
  return firstDate.year == secondDate.year &&
      firstDate.month == secondDate.month &&
      firstDate.day == secondDate.day;
}

bool isSameWeek(DateTime date1, DateTime date2) {
  // 각 날짜가 속하는 주의 첫 번째 날(월요일)을 계산
  DateTime startOfWeek(DateTime date) {
    int dayOfWeek = date.weekday; // 1 (월요일) ~ 7 (일요일)
    return DateTime(
        date.year, date.month, date.day - (dayOfWeek - 1)); // 그 주의 월요일로 이동
  }

  // 주의 시작일(월요일)이 같은지를 비교
  return startOfWeek(date1) == startOfWeek(date2);
}

bool isSameMonth(DateTime firstDate, DateTime secondDate) {
  return firstDate.year == secondDate.year &&
      firstDate.month == secondDate.month;
}
