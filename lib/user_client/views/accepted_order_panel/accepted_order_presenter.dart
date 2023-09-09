import '../../../models/car_type.dart';
import '../../../models/wash_service.dart';
import '../../models/accepted_order.dart';
import '../../../models/car.dart';
import '../../models/car_wash_offer.dart';

class AcceptedOrderPresenter {
  AcceptedOrder order = AcceptedOrder(
    "Помойка",
    "ул. Красноармейская 25 75",
    "89278756682",
    MapPosition(59.94473559335115, 30.25908023387789),
    500,
    DateTime.now(),
    DateTime.now(),
    Car("123", "Mersedes", CarType.passengerCar),
    [WashService.interiorDryCleaning, WashService.diskCleaning,]
  );

  void cancelOrder() async {
    print("Order canceled!");
  }
}