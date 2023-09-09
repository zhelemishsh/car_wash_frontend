import 'package:flutter/material.dart';

import '../../models/was_day.dart';
import '../../models/wash_service.dart';
import '../../models/car.dart';
import 'car_wash_offer.dart';

class WashOrder {
  DateTime startTime;
  DateTime endTime;
  Car car;
  List<WashService> services;
  MapPosition startPosition;

  WashOrder(this.startTime, this.endTime, this.car, this.services, this.startPosition);
}

class WashOrderBuilder {
  TimeOfDay startTime;
  TimeOfDay endTime;
  WashDay washDay;
  Car? car;
  MapPosition? startPosition;
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
      startDateTime, endDateTime, car!, services.toList(), startPosition!,
    );
  }
}