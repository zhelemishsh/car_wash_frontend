import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RouteUtils {
  static Future<DrivingRoute> makeRoute(
      MapPosition startPosition, MapPosition endPosition) async {
    DrivingSessionResult sessionResult = await YandexDriving.requestRoutes(
      drivingOptions: const DrivingOptions(
        avoidPoorConditions: true,
        avoidUnpaved: true,
      ),
      points: [
        RequestPoint(
          requestPointType: RequestPointType.wayPoint,
          point: startPosition.toPoint(),
        ),
        RequestPoint(
          requestPointType: RequestPointType.wayPoint,
          point: endPosition.toPoint(),
        ),
      ],
    ).result;
    return sessionResult.routes![0];
  }
}