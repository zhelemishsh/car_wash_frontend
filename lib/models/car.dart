class Car {
  String number;
  String name;
  CarType type;

  Car(this.number, this.name, this.type);
}

enum CarType {
  passengerCar, truck
}