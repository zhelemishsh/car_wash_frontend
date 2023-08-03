import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:car_wash_frontend/repository/wash_offers_repository.dart';
import 'package:car_wash_frontend/views/car_wash_selection/car_wash_selection_contract.dart';
import 'package:flutter/material.dart';

class CarWashSelectionPresenter {
  final CarWashSelectionContract _view;
  final WashOrderBuilder _orderBuilder = WashOrderBuilder();
  SearchState _searchState = SearchState.optionsSelection;
  final WashOffersRepository _washOffersRepository = WashOffersRepository();
  final List<CarWashOffer> _offers = [];
  CarWashOffer? _acceptedOffer;

  CarWashSelectionPresenter(this._view);

  List<CarWashOffer> getOffers() {
    return _offers;
  }

  CarWashOffer? getAcceptedOffer() {
    return _acceptedOffer;
  }

  SearchState getSearchState() {
    return _searchState;
  }

  WashOrderBuilder get orderBuilder => _orderBuilder;

  void loadWashOffers() {
    Future(() async {
      orderBuilder.searchArea = await _view.getSearchArea();
      WashOrder order = orderBuilder.build(); //TODO send to server

      _view.hideBottomPanel();
      await Future.delayed(const Duration(milliseconds: 500));
      _searchState = SearchState.offersShowing;
      _view.showBottomPanel();
      await _executeOffersLoadingCycle();
    }).then((value) => null);
  }

  Future<void> _executeOffersLoadingCycle() async {
    for (int i = 0; i < 10; ++i) {
      List<CarWashOffer> newOffers = await _washOffersRepository.getOffers();
      for (CarWashOffer newOffer in newOffers) {
        if (_offers.indexWhere(
                (existingOffer) => existingOffer.id == newOffer.id) == -1) {
          _offers.add(newOffer);
          _view.updateWashOffers();
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  void sendWashAgreement(CarWashOffer offer) {
    _view.hideBottomPanel();
    _searchState = SearchState.loading;
    Future.delayed(const Duration(seconds: 2)).then((value) {
      _acceptedOffer = offer;
      _searchState = SearchState.offerSelected;
      _view.showBottomPanel();
    });
  }
}

enum SearchState {
  optionsSelection, offersShowing, offerSelected, loading
}