import 'package:car_wash_frontend/models/car.dart';
import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/models/wash_order.dart';

class AcceptedOrder {
  String carWashName;
  String carWashAddress;
  String carWashNumber;
  MapPosition carWashPosition;
  int price;
  DateTime startTime;
  DateTime endTime;
  Car car;
  List<WashService> services;

  AcceptedOrder(
      this.carWashName,
      this.carWashAddress,
      this.carWashNumber,
      this.carWashPosition,
      this.price,
      this.startTime,
      this.endTime,
      this.car,
      this.services,);
}