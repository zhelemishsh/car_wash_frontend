import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_contract.dart';

import '../../models/car_wash_offer.dart';
import '../../repository/wash_offers_repository.dart';

class OfferSelectionPresenter {
  final OfferSelectionContract _view;
  final _washOffersRepository = WashOffersRepository();
  final List<CarWashOffer> offers = [];

  OfferSelectionPresenter(this._view);

  void loadWashOffers() async {
    await _executeOffersLoadingCycle();
  }

  Future<void> _executeOffersLoadingCycle() async {
    for (int i = 0; i < 10; ++i) {
      List<CarWashOffer> newOffers = await _washOffersRepository.getOffers();
      for (CarWashOffer newOffer in newOffers) {
        if (offers.indexWhere(
                (existingOffer) => existingOffer.id == newOffer.id) == -1) {
          offers.add(newOffer);
          _view.updateOffers();
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }
}