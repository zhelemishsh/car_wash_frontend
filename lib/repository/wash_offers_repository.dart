import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:flutter/material.dart';

class WashOffersRepository {
  static final WashOffersRepository _repository = WashOffersRepository._internal();

  factory WashOffersRepository() {
    return _repository;
  }

  WashOffersRepository._internal();

  final List<CarWashOffer> _offers = [
    CarWashOffer(1, MapPosition(56.632075, 47.869551), "Pomoika", 500, "Pushkin street 25 75", 5.00, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(2, MapPosition(56.639453, 47.823855), "Auto wash", 300, "Lenin street 43 24", 2.99, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(3, MapPosition(56.642757, 47.913773), "Carcarich", 456, "Red Army street 54 32", 4.04, TimeOfDay.now(), TimeOfDay.now()),
    CarWashOffer(4, MapPosition(56.621488, 47.872083), "Skin Bumper", 423, "Maksim street 14 88", 4.88, TimeOfDay.now(), TimeOfDay.now()),
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