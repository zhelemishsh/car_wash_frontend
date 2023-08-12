import 'package:car_wash_frontend/models/car.dart';
import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:flutter/material.dart';

class WashOrder {
  DateTime startTime;
  DateTime endTime;
  Car car;
  List<WashService> services;
  SearchArea searchArea;

  WashOrder(this.startTime, this.endTime, this.car, this.services, this.searchArea);
}

class WashOrderBuilder {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );
  String? washDay;
  Car? car;
  SearchArea? searchArea;
  final List<WashService> _services = [];

  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  Iterable<WashService> get services => _services;

  set startTime(TimeOfDay time) {
    if (washDay == "Today" && _isTimeBefore(time, TimeOfDay.now())) {
      throw Exception("Wrong start time");
    }
    _startTime = time;
    if (_isTimeBefore(_endTime, _startTime)) {
      _endTime = _startTime;
    }
  }

  set endTime(TimeOfDay time) {
    if (_isTimeBefore(time, _startTime)) {
      throw Exception("Wrong end time");
    }
    _endTime = time;
  }

  void addService(WashService service) {
    if (!_services.contains(service)) {
      _services.add(service);
    }
  }

  void deleteService(WashService service) {
    _services.remove(service);
  }

  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour
        || (time1.hour == time2.hour
            && time1.minute < time2.minute);
  }

  WashOrder build() {
    DateTime date = DateTime.now();
    switch (washDay) {
      case "Tomorrow":
        date = date.add(const Duration(days: 1));
        break;
      case "Day about":
        date = date.add(const Duration(days: 2));
    }
    DateTime startDateTime = date.copyWith(
      hour: startTime.hour, minute: startTime.minute,
    );
    DateTime endDateTime = date.copyWith(
      hour: endTime.hour, minute: endTime.minute,
    );
    return WashOrder(
      startDateTime, endDateTime, car!, services.toList(), searchArea!,
    );
  }
}

class SearchArea {
  MapPosition centerPosition;
  double radius;

  SearchArea(this.centerPosition, this.radius);
}

enum WashService {
  interiorDryCleaning, diskCleaning, bodyPolishing, engineCleaning
}

extension ParseToString on WashService {
  String parseToString() {
    switch (this) {
      case WashService.interiorDryCleaning:
        return "Interior dry cleaning";
      case WashService.diskCleaning:
        return "Disk cleaning";
      case WashService.bodyPolishing:
        return "Body polishing";
      case WashService.engineCleaning:
        return "Engine cleaning";
    }
  }
}