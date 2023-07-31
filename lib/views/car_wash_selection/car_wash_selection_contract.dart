import '../../models/car_wash_offer.dart';

abstract class CarWashSelectionContract {
  void updatePage();
  void showBottomPanel();
  void updateWashOffers();
  void hideBottomPanel();
}