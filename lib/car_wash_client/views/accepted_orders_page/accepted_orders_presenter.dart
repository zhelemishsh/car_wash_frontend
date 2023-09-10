import 'package:car_wash_frontend/car_wash_client/models/accepted_client_order.dart';
import 'package:car_wash_frontend/car_wash_client/views/accepted_orders_page/accepted_orders_contract.dart';
import 'package:car_wash_frontend/models/was_day.dart';
import 'package:flutter/material.dart';

import '../../../models/car.dart';
import '../../../models/car_type.dart';
import '../../../models/wash_service.dart';

class AcceptedOrdersPresenter {
  AcceptedOrdersContract _view;

  List<AcceptedClientOrder> orders = [
    AcceptedClientOrder(
      clientName: "Андрюха Петров",
      clientCar: Car("G123FG777", "Mersedes Benz A2", CarType.passengerCar),
      clientPhoneNumber: "89878743215",
      clientRating: 4.66,
      price: 100,
      services: [WashService.diskCleaning, WashService.bodyPolishing],
      day: WashDay.today,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0),
    ),
    AcceptedClientOrder(
      clientName: "Кирюха Захаров",
      clientCar: Car("A123BC777", "Volga 14", CarType.truck),
      clientPhoneNumber: "89278756682",
      clientRating: 4.88,
      price: 200,
      services: [WashService.interiorDryCleaning, WashService.diskCleaning],
      day: WashDay.tomorrow,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(hour: TimeOfDay.now().hour + 2, minute: 0),
    ),
  ];

  AcceptedOrdersPresenter(this._view);

  void cancelOffer(AcceptedClientOrder order) {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      print("Offer canceled!");
      orders.remove(order);
      _view.updatePage();
    });
  }
}