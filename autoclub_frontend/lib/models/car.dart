import 'brands.dart';

enum CarType {
  sedan(name: "Sedan"),
  hatchback(name: "Hatchback"),
  wagon(name: "Wagon"),
  suv(name: "SUV"),
  coupe(name: "Coupe"),
  convertible(name: "Convertible"),
  microcar(name: "Microcar"),
  minivan(name: "Minivan"),
  van(name: "Box van"),
  pickup(name: "Pickup"),
  supercar(name: "Supercar"),
  hypercar(name: "Hypercar"),

  // For cars that do not fall under any of the above categories
  special(name:"Special");

  final String name;
  // possible todo: add icons
  const CarType({required this.name});
}

enum CarTag {
  classic(name: "Classic"),
  tuner(name: "Tuner"),
  muscle(name: "Muscle"),
  premium(name: "Premium"),
  luxury(name: "Luxury"),
  gt(name: "Grand tourer"),
  superLuxury(name: "Super Luxury");

  final String name;
  const CarTag({required this.name});
}

enum Continent {
  asia,
  europe,
  northAmerica
}

enum Country {
  uk(cont: Continent.europe, name: "United Kingdom"),
  japan(cont: Continent.asia, name: "Japan"),
  italy(cont: Continent.europe, name: "Italy"),
  indonesia(cont: Continent.asia, name: "Indonesia"),
  germany(cont: Continent.europe, name: "Germany"),
  finland(cont: Continent.europe, name: "Finland"),
  estonia(cont: Continent.europe, name: "Estonia"),
  poland(cont: Continent.europe, name: "Poland"),
  us(cont: Continent.northAmerica, name: "United States");

  final Continent cont;
  final String name;
  const Country({required this.cont, required this.name});
}


class CarModel {
  /*
  Car object that represents a car in the game.
   */
  Brand brand;
  String name;
  int year;
  int newPrice;


  CarModel(this.name, this.brand);
}