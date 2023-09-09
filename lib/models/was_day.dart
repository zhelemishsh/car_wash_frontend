enum WashDay {
  today, tomorrow, dayAfter,
}

extension DayParseToString on WashDay {
  String parseToString() {
    switch (this) {
      case WashDay.today:
        return "Сегодня";
      case WashDay.tomorrow:
        return "Завтра";
      case WashDay.dayAfter:
        return "Послезавтра";
    }
  }
}