import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
  DrivingRoute? route;
}

class MapPosition {
  double latitude, longitude;

  MapPosition(this.latitude, this.longitude);
}

extension PointToMapPosition on Point {
  MapPosition toMapPosition() {
    return MapPosition(latitude, longitude);
  }
}

extension MapPositionToPoint on MapPosition {
  Point toPoint() {
    return Point(latitude: latitude, longitude: longitude);
  }
}