import 'package:car_wash_frontend/models/wash_service.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';
import '../../models/was_day.dart';

class ClientOrder {
  String clientName;
  Car clientCar;
  double clientRating;
  double price;
  double bestPrice;
  double duration;
  double bestDuration;
  List<WashService> services;
  WashDay day;
  TimeOfDay startTime;
  TimeOfDay endTime;

  ClientOrder({
    required this.clientName,
    required this.clientCar,
    required this.clientRating,
    required this.price,
    required this.bestPrice,
    required this.duration,
    required this.bestDuration,
    required this.services,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}