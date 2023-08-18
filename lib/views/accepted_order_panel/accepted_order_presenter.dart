import 'package:car_wash_frontend/models/accepted_order.dart';
import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';

class AcceptedOrderPresenter {
  AcceptedOrder order = AcceptedOrder(
    "Помойка",
    "ул. Пушкина 25 75",
    MapPosition(56.632075, 47.869551),
    500,
    DateTime.now(),
    DateTime.now(),
    Car("123", "Mersedes"),
    [WashService.interiorDryCleaning, WashService.diskCleaning,]
  );
}