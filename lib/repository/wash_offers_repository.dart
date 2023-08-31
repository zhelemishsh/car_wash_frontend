import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:flutter/material.dart';

class WashOffersRepository {
  static final WashOffersRepository _repository = WashOffersRepository._internal();

  factory WashOffersRepository() {
    return _repository;
  }

  WashOffersRepository._internal();

  final List<CarWashOffer> _offers = [
    CarWashOffer(1, MapPosition(59.94473559335115, 30.25908023387789), "Помойка", 500, "ул. Пушкина 25 75", 5.00, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(2, MapPosition(59.95688567196063, 30.33330642887048), "Мойка мойка", 300, "ул. Ленина 43 24", 2.99, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(3, MapPosition(59.936969930067576, 30.357387301406185), "Акватория", 456, "ул. Красноармейская 54 32", 4.04, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(4, MapPosition(59.982920849286714, 30.384228898529784), "Голый бампер", 423, "ул. Горького 14 88", 4.88, TimeOfDay.now(), TimeOfDay.now()),
  ];
  int _currentCount = 0;

  Future<List<CarWashOffer>> getOffers() async {
    Future.delayed(const Duration(milliseconds: 200));
    ++_currentCount;
    if (_currentCount > _offers.length) {
      return _offers.sublist(0, _offers.length);
    }
    else {
      return _offers.sublist(0, _currentCount);
    }
  }
}