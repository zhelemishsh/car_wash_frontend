import '../../models/car_type.dart';
import '../../models/car.dart';

class AccountRepository {
  final List<Car> _cars = [
    Car("T113EP178", "Mersedes Benz", CarType.passengerCar),
    Car("S123AS12", "BMW X5", CarType.truck),
    Car("A001BC777", "Lada Kalina", CarType.passengerCar)
  ];

  Future<void> addCar(Car addedCar) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_cars.where((car) => car.number == addedCar.number).isNotEmpty) {
      throw Exception("Car with this number already exists");
    }
    _cars.add(addedCar);
  }

  Future<void> deleteCars(List<String> carNumbers) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cars.removeWhere((car) => carNumbers.contains(car.number));
  }

  Future<void> changeAccountName(String newName) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<List<Car>> getCars() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_cars);
  }
}