import 'package:car_wash_frontend/user_client/utils/time_utils.dart';
import 'package:flutter/material.dart';

import '../../../models/car_type.dart';
import '../../models/car.dart';
import '../../models/wash_order.dart';
import 'order_creation_contract.dart';

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