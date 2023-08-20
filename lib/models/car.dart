import 'package:flutter/material.dart';

class Car {
  String number;
  String name;
  CarType type;

  Car(this.number, this.name, this.type);
}

enum CarType {
  passengerCar, truck, motorbike;
}

extension CarTypeExtention on CarType {
  IconData carIcon() {
    switch (this) {
      case CarType.passengerCar:
        return Icons.drive_eta_rounded;
      case CarType.truck:
        return Icons.local_shipping_rounded;
      case CarType.motorbike:
        return Icons.two_wheeler_rounded;
    }
  }

  String parseToString() {
    switch (this) {
      case CarType.passengerCar:
        return "Легковая машина";
      case CarType.truck:
        return "Грузовая машина";
      case CarType.motorbike:
        return "Мотоцикл";
    }
  }
}