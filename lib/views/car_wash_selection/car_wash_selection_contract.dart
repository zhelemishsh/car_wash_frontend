import 'package:car_wash_frontend/models/wash_order.dart';

import '../../models/car_wash_offer.dart';

abstract class CarWashSelectionContract {
  void updatePage();
  Future<SearchArea> getSearchArea();
  void showBottomPanel();
  void updateWashOffers();
  void hideBottomPanel();
}