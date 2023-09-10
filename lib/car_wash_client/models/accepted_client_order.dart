import 'package:car_wash_frontend/models/was_day.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';
import '../../models/wash_service.dart';

class AcceptedClientOrder {
  String clientName;
  Car clientCar;
  String clientPhoneNumber;
  double clientRating;
  double price;
  List<WashService> services;
  WashDay day;
  TimeOfDay startTime;
  TimeOfDay endTime;

  AcceptedClientOrder({
    required this.clientName,
    required this.clientCar,
    required this.clientPhoneNumber,
    required this.clientRating,
    required this.price,
    required this.services,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}