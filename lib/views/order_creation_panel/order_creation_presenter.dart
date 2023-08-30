import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/order_creation_panel/order_creation_contract.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';
import '../../models/wash_order.dart';

class OrderCreationPresenter {
  final OrderCreationContract _view;
  final WashOrderBuilder orderBuilder = WashOrderBuilder(
    TimeOfDay.now().getClosest(),
    TimeOfDay.now().getClosest().addMinutes(20),
    WashDay.today,
  );
  final List<Car> cars = [
    Car("1", "Mercedes-Benz A", CarType.passengerCar), Car("2", "BMW X7 M60i", CarType.truck),
  ];

  OrderCreationPresenter(this._view);

  void makeOrder() async {
    print("Order created!");
  }
}