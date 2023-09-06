import 'package:flutter/material.dart';

import '../../models/car_type.dart';

class Car {
  String number;
  String name;
  CarType type;

  Car(this.number, this.name, this.type);
}
