import 'package:car_wash_frontend/views/order_creation_panel/order_creation_contract.dart';
import 'package:car_wash_frontend/views/order_creation_panel/order_creation_panel.dart';

import '../../models/car.dart';
import '../../models/wash_order.dart';

class OrderCreationPresenter {
  final OrderCreationContract _view;
  final WashOrderBuilder orderBuilder = WashOrderBuilder();
  final List<Car> cars = [
    Car("1", "Mercedes-Benz A"), Car("2", "BMW X7 M60i"),
  ];

  OrderCreationPresenter(this._view);

  void makeOrder() async {
    print("Order created!");
  }
}