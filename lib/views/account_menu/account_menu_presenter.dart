import '../../models/car.dart';

class AccountMenuPresenter {
  final List<Car> cars = [
    Car("T113EP178", "Mersedes Benz"),
    Car("S123AS12", "BMW X5"),
    Car("A001BC777", "Lada Kalina")
  ];
  final List<Car> selectedCars = [];
}