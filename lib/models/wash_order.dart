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
  TimeOfDay startTime;
  TimeOfDay endTime;
  WashDay washDay;
  Car? car;
  SearchArea? searchArea;
  final List<WashService> _services = [];

  WashOrderBuilder(this.startTime, this.endTime, this.washDay);

  Iterable<WashService> get services => _services;

  void addService(WashService service) {
    if (!_services.contains(service)) {
      _services.add(service);
    }
  }

  void deleteService(WashService service) {
    _services.remove(service);
  }

  WashOrder build() {
    DateTime date = DateTime.now();
    date = switch (washDay) {
      WashDay.today => date,
      WashDay.tomorrow => date.add(const Duration(days: 1)),
      WashDay.dayAfter => date.add(const Duration(days: 2)),
    };
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

extension ServiceParseToString on WashService {
  String parseToString() {
    switch (this) {
      case WashService.interiorDryCleaning:
        return "Химчистка салона";
      case WashService.diskCleaning:
        return "Чистка дисков";
      case WashService.bodyPolishing:
        return "Полировка кузова";
      case WashService.engineCleaning:
        return "Мойка двигателя";
    }
  }
}