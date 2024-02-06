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


enum DrivetrainType {
  ff(name: "Front engine, front wheel drive", acronym: "FF"),
  fr(name: "Front engine, rear wheel drive", acronym: "FR"),
  mr(name: "Mid engine, rear wheel drive", acronym: "MR"),
  rr(name: "Rear engine, rear wheel drive", acronym: "RR"),
  fourwd(name: "Four wheel drive", acronym: "4WD"),
  fawd(name: "Front engine, all wheel drive", acronym: "F-AWD"),
  mawd(name: "Mid engine, all wheel drive", acronym: "M-AWD");

  final String name;
  final String acronym;
  const DrivetrainType({required this.name, required this.acronym});
}


enum EngineType {
  i3(acronym: "I3"),
  i4(acronym: "I4"),
  i5(acronym: "I5"),
  i6(acronym: "I6"),
  v6(acronym: "V6"),
  v8(acronym: "V8"),
  v10(acronym: "V10"),
  v12(acronym: "V12"),
  v16(acronym: "V16"),
  b4(acronym: "B4"),
  b6(acronym: "B6");

  final String acronym;
  const EngineType({required this.acronym});
}


enum EngineAspiration {
  na(name: "Naturally Aspirated"),
  turbo(name: "Turbocharged"),
  sc(name: "Supercharged");

  final String name;
  const EngineAspiration({required this.name});
}


enum CargoSpace {
  xs(acronym: "XS", size: 1),
  s(acronym: "S", size: 2),
  m(acronym: "M", size: 3),
  l(acronym: "L", size: 4),
  xl(acronym: "XL", size: 5),
  xxl(acronym: "XL", size: 6);

  final String acronym;
  final int size;
  const CargoSpace({required this.acronym, required this.size});
}


class CarModel {
  /*
  Car object that represents a car in the game.
   */
  Brand brand;
  String name;
  int year;
  int newPrice;
  CarType type;
  List<CarTag> tags;
  Country country;
  DrivetrainType drivetrain;
  EngineType engine;
  EngineAspiration aspiration;
  CargoSpace space;

  int power;
  int weight;
  int seatCount;

  /*
  Acceleration, in 0-100 km/h time in seconds
  less is better
   */
  int accel;

  /*
  Acceleration, in 0-400m distance time in seconds
  less is better
   */
  int qmile;

  /*
  Top speed, in km/h
  more is better
   */
  int vmax;

  /*
  Short radius (20m) cornering handling, in G value
  more is better
   */
  int handling0;

  /*
  Long radius (200m) cornering handling, in G value
  more is better
   */
  int handling1;

  /*
  Braking distance from 100 - 0 km/h, in m
  less is better
   */
  int braking;

  String designer;


  CarModel(
      this.name,
      this.brand,
      this.year,
      this.newPrice,
      this.type,
      this.tags,
      this.country,
      this.drivetrain,
      this.engine,
      this.aspiration,
      this.space,
      this.power,
      this.weight,
      this.seatCount,
      this.accel,
      this.qmile,
      this.vmax,
      this.handling0,
      this.handling1,
      this.braking,
      this.designer
      );
}