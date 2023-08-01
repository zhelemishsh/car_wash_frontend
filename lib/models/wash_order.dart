import 'package:car_wash_frontend/models/car.dart';
import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:flutter/material.dart';

class WashOrder {

}

class WashOrderBuilder {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );
  String? _washDay;
  Car? _car;
  final List<WashService> _services = [];

  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;
  String? get washDay => _washDay;
  Car? get car => _car;
  Iterable<WashService> get services => _services;

  set startTime(TimeOfDay time) {
    if (_washDay == "Today" && _isTimeBefore(time, TimeOfDay.now())) {
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

  set washDay(String? day) => _washDay = day;
  set car(Car? car) => _car = car;

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
}

class SearchArea {
  MapPosition position;
  double radius;

  SearchArea(this.position, this.radius);
}

enum WashService {
  interiorDryCleaning, diskCleaning, bodyPolishing, engineCleaning,
}