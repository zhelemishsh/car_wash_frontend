import '../../../models/car_type.dart';
import '../../models/account.dart';
import '../../models/car.dart';
import '../../repository/account_repository.dart';
import 'account_menu_contract.dart';

class AccountMenuPresenter {
  final _accountRepository = AccountRepository();
  final AccountMenuContract _view;
  final account = Account(
    "Goshan",
    "89278756682",
    4.98,
    [
      Car("T113EP178", "Mersedes Benz", CarType.passengerCar),
      Car("S123AS12", "BMW X5", CarType.truck),
      Car("A001BC777", "Lada Kalina", CarType.passengerCar)
    ],
  );
  final List<Car> selectedCars = [];

  AccountMenuPresenter(AccountMenuContract view) : _view = view;

  void addCar(Car car) {
    _accountRepository.addCar(car)
    .then((_) {
      account.cars.add(car);
      _view.update();
    })
    .onError((error, _) {
      _view.showError(error.toString());
    });
  }

  void deleteSelectedCars() {
    List<String> carNumbers = selectedCars.map((car) => car.number).toList();
    _accountRepository.deleteCars(carNumbers)
    .then((_) {
      account.cars.removeWhere((car) => carNumbers.contains(car.number));
      selectedCars.clear();
      _view.update();
    })
    .onError((error, _) {
      _view.showError(error.toString());
    });
  }

  void changeAccountName(String name) {
    _accountRepository.changeAccountName(name)
    .then((_) {
      account.name = name;
      _view.update();
    })
    .onError((error, _) {
      _view.showError(error.toString());
      _view.update();
    });
  }
}