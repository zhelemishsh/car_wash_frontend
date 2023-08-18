import '../../models/car.dart';

class AccountMenuPresenter {
  final List<Car> cars = [
    Car("T113EP178", "Mersedes Benz", CarType.passengerCar),
    Car("S123AS12", "BMW X5", CarType.truck),
    Car("A001BC777", "Lada Kalina", CarType.passengerCar)
  ];
  final List<Car> selectedCars = [];
}