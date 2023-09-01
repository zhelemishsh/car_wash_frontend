import 'package:car_wash_frontend/models/accepted_order.dart';
import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';

class AcceptedOrderPresenter {
  AcceptedOrder order = AcceptedOrder(
    "Помойка",
    "ул. Пушкина 25 75",
    MapPosition(59.94473559335115, 30.25908023387789),
    500,
    DateTime.now(),
    DateTime.now(),
    Car("123", "Mersedes", CarType.passengerCar),
    [WashService.interiorDryCleaning, WashService.diskCleaning,]
  );

  void cancelOrder() async {
    print("Order canceled!");
  }
}