import 'package:flutter/material.dart';

class CarWashOffer {
  CarWashOffer(
      this.id,
      this.position,
      this.name,
      this.price,
      this.address,
      this.rating,
      this.startTime,
      this.endTime);

  int id;
  MapPosition position;
  String name;
  int price;
  String address;
  double rating;
  TimeOfDay startTime;
  TimeOfDay endTime;
}

class MapPosition {
  double latitude, longitude;

  MapPosition(this.latitude, this.longitude);
}