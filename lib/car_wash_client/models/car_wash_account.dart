import 'package:car_wash_frontend/models/car_type.dart';
import 'package:car_wash_frontend/models/wash_service.dart';

class CarWashAccount {
  Map<WashService, Map<CarType, ServiceData>> servicesData = {};

  CarWashAccount() {
    for (var service in WashService.values) {
      servicesData[service] = {};
      for (var carType in CarType.values) {
        servicesData[service]![carType] = ServiceData(const Duration(minutes: 20), 400);
      }
    }
  }
}

class ServiceData {
  Duration? duration;
  double? price;

  ServiceData(this.duration, this.price);
}