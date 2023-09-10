import 'package:car_wash_frontend/car_wash_client/models/client_order.dart';
import 'package:car_wash_frontend/car_wash_client/views/pending_orders_page/pending_orders_contract.dart';
import 'package:car_wash_frontend/models/car_type.dart';
import 'package:car_wash_frontend/models/was_day.dart';
import 'package:car_wash_frontend/models/wash_service.dart';
import 'package:flutter/material.dart';

import '../../../models/car.dart';

class PendingOrdersPresenter {
  PendingOrdersContract _view;

  List<ClientOrder> orders = [
    ClientOrder(
      clientName: "Андрюха Петров",
      clientCar: Car("G123FG777", "Mersedes Benz A2", CarType.passengerCar),
      clientRating: 4.66,
      price: 100,
      bestPrice: 200,
      duration: 45,
      bestDuration: 30,
      services: [WashService.diskCleaning, WashService.bodyPolishing],
      day: WashDay.today,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0),
    ),
    ClientOrder(
      clientName: "Кирюха Захаров",
      clientCar: Car("A123BC777", "Volga 14", CarType.truck),
      clientRating: 4.88,
      price: 200,
      bestPrice: 100,
      duration: 50,
      bestDuration: 60,
      services: [WashService.interiorDryCleaning, WashService.diskCleaning],
      day: WashDay.tomorrow,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0),
    ),
  ];

  PendingOrdersPresenter(this._view);

  void declineOrder(ClientOrder order) {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      print("Order declined!");
      orders.remove(order);
      _view.updatePage();
    });
  }

  void acceptOrder(ClientOrder order) {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      print("Order accepted!");
      orders.remove(order);
      _view.updatePage();
    });
  }

  void timeoutOrder(ClientOrder order) {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      print("Order time out!");
      orders.remove(order);
      _view.updatePage();
    });
  }
}