import 'package:flutter/material.dart';

class TimeUtils {
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }
}

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) return true;
    if (hour > other.hour) return false;
    if (minute < other.minute) return true;
    return false;
  }

  int getMinutes() {
    return hour * 60 + minute;
  }

  TimeOfDay getClosest() {
    int total = hour * 60 + minute;
    int closestTotal = (total ~/ 10 + 1) * 10;
    return TimeOfDay(hour: closestTotal ~/ 60, minute: closestTotal % 60);
  }

  String formatTime() {
    return '${hour.toString().padLeft(2, '0')}'
        ':${minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay addMinutes(int minutes) {
    int total = hour * 60 + minute + minutes;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  TimeOfDay subtractMinutes(int minutes) {
    int total = hour * 60 + minute - minutes;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }
}