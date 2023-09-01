import 'package:car_wash_frontend/utils/route_utils.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_contract.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../repository/wash_offers_repository.dart';

class OfferSelectionPresenter {
  final OfferSelectionContract _view;
  final _washOffersRepository = WashOffersRepository();
  final List<CarWashOffer> offers = [];
  final MapPosition startPosition;

  OfferSelectionPresenter(this._view, this.startPosition);

  void loadWashOffers() async {
    await _executeOffersLoadingCycle();
  }

  Future<void> _executeOffersLoadingCycle() async {
    for (int i = 0; i < 10; ++i) {
      List<CarWashOffer> newOffers = await _washOffersRepository.getOffers();
      for (CarWashOffer newOffer in newOffers) {
        if (offers.indexWhere(
                (existingOffer) => existingOffer.id == newOffer.id) == -1) {
          newOffer.route = await RouteUtils.makeRoute(startPosition, newOffer.position);
          offers.add(newOffer);
          _view.updateOffers();
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  void stopSearch() async {
    print("Search stopped!");
  }
}