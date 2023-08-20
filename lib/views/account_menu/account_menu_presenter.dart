import 'package:car_wash_frontend/repository/account_repository.dart';
import 'package:car_wash_frontend/views/account_menu/account_menu_contract.dart';

import '../../models/car.dart';

class AccountMenuPresenter {
  final _accountRepository = AccountRepository();
  final AccountMenuContract _view;
  final List<Car> cars = [
    Car("T113EP178", "Mersedes Benz", CarType.passengerCar),
    Car("S123AS12", "BMW X5", CarType.truck),
    Car("A001BC777", "Lada Kalina", CarType.passengerCar)
  ];
  final List<Car> selectedCars = [];

  AccountMenuPresenter(AccountMenuContract view) : _view = view;

  void addCar(Car car) {
    _accountRepository.addCar(car)
    .then((_) {
      cars.add(car);
      _view.update();
    })
    .onError((error, _) {
      _view.showError(error.toString());
    });
  }
}