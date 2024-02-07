import 'brands.dart';


enum CarType {
  /*
Body types of car objects
 */

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
  /*
Tags for car objects.
Used to specify attributes of the cars.
 */

  classic(name: "Classic"),
  tuner(name: "Tuner"),
  muscle(name: "Muscle"),
  premium(name: "Premium"),
  luxury(name: "Luxury"),
  gt(name: "Grand tourer"),
  superLuxury(name: "Super Luxury"),
  kei(name: "Kei car"),
  race(name: "Race"),
  utility(name: "Utility");

  final String name;
  const CarTag({required this.name});
}


enum Continent {
  /*
Continents for the countries.
 */

  asia,
  europe,
  northAmerica
}


enum Country {
  /*
Possible countries for the car objects.
 */

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
/*
Types of drivetrains for the cars.
 */

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
  /*
Types of engines for the cars.
 */

  i3(name: "I3"),
  i4(name: "I4"),
  i5(name: "I5"),
  i6(name: "I6"),
  v6(name: "V6"),
  v8(name: "V8"),
  v10(name: "V10"),
  v12(name: "V12"),
  v16(name: "V16"),
  b4(name: "B4"),
  b6(name: "B6");

  final String name;
  const EngineType({required this.name});
}


enum EngineAspiration {
  /*
Types of engine aspiration for the car engines.
 */

  na(name: "Naturally Aspirated"),
  turbo(name: "Turbocharged"),
  sc(name: "Supercharged");

  final String name;
  const EngineAspiration({required this.name});
}


enum CargoSpace {
  /*
Cargo space rating for the cars.
Used for mission requirements.
 */

  xs(name: "XS", size: 1),
  s(name: "S", size: 2),
  m(name: "M", size: 3),
  l(name: "L", size: 4),
  xl(name: "XL", size: 5),
  xxl(name: "XL", size: 6);

  final String name;
  final int size;
  const CargoSpace({required this.name, required this.size});
}


enum ComponentDamage {
  /*
  Damage levels for the individual components
  With varying levels of repair cost
   */
  none(name: "None", level: 0, coef: 0),
  light(name: "Light", level: 1, coef: 0.1),
  medium(name: "Medium", level: 2, coef: 0.3),
  severe(name: "Severe", level: 3, coef: 0.6),
  broken(name: "Broken", level: 4, coef: 1);

  final String name;
  final int level;

  // coefficient for the repair cost relative to the component price
  final double coef;

  const ComponentDamage({required this.name, required this.coef, required this.level});
}


class Component {
  /*
  Individual components for the cars
  Used for the repairing and damaging system
  Possibly used for the upgrading system
   */

  final ComponentDamage damage;
  final String name;

  // Price of component relative to new price of car
  final double ratio;

  // TODO: Implement component link to performance
  const Component({required this.name, required this.damage, required this.ratio});
}



class CarModel {
  /*
  Car object that represents a car in the game.
  This is a basic representation, and the cars that the player would obtain is in the subclass Car.
   */

  /*
  TODO: Fuel economy vals
   */

  Brand brand;
  String name;
  int year;
  int newPrice;
  CarType type;
  List<CarTag> tags;
  Country country;
  DrivetrainType drivetrainType;
  EngineType engineType;
  EngineAspiration aspirationType;
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

  /*
  Coefficient for the depreciation calculation
   */
  int depCurve;

  /*
  Max and min possible mileage for when the car appears in a used dealership
   */
  int maxMileage;
  int minMileage;

  /*
  Stats for the car, calculated through calculation function
  You can find the calculations on the car list spreadsheet
  Values are out of 10 and represent the general performance of the car in various aspects
   */

  late double launchStat;
  late double accelStat;
  late double speedStat;
  late double handlingStat;
  late double brakingStat;

  late int performancePoint;

  int get pwRatio => ((power / weight) * 1000).toInt();

  //String d;

  /*
  Various components for the car
   */
  Component engine = const Component(
      name: "Engine",
      damage: ComponentDamage.none,
      ratio: 0.3
  );

  Component drivetrain = const Component(
      name: "Drivetrain",
      damage: ComponentDamage.none,
      ratio: 0.2
  );

  Component suspension = const Component(
      name: "Suspension",
      damage: ComponentDamage.none,
      ratio: 0.15
  );

  Component bodywork = const Component(
      name: "Bodywork",
      damage: ComponentDamage.none,
      ratio: 0.15
  );

  Component interior = const Component(
      name: "Interior",
      damage: ComponentDamage.none,
      ratio: 0.08
  );

  Component wheelsTires = const Component(
      name: "Wheels and Tires",
      damage: ComponentDamage.none,
      ratio: 0.12
  );

  String designer;


  CarModel(
      this.name,
      this.brand,
      this.year,
      this.newPrice,
      this.type,
      this.tags,
      this.country,
      this.drivetrainType,
      this.engineType,
      this.aspirationType,
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
      this.depCurve,
      this.maxMileage,
      this.minMileage,
      this.performancePoint,
      this.designer
      ){
        updatePerfStats();
      }


  void updatePerfStats() {
    /*
    Update stat values
     */
    launchStat = 18 / accel;
    accelStat = 38.5 / (qmile - 4) - 1;
    speedStat = (vmax - 60) / 44;
    handlingStat = 1.666 * (handling0 + handling1);
    brakingStat = 200 / (braking - 6.6) - 3;
  }


  void updatePerfPoint({
    // Default weightings for each stat
    double launchWeight = 0.15,
    double accelWeight = 0.25,
    double speedWeight = 0.2,
    double handlingWeight = 0.25,
    double brakingWeight = 0.15
  }) {
    performancePoint =
    (
        launchStat * launchWeight +
        accelStat * accelWeight +
        speedStat * speedWeight +
        handlingStat * handlingWeight +
        brakingStat * brakingWeight
    ) as int;
  }

}




class Car extends CarModel {
  /*
  The actual car object with parameters to account for usage
   */

  int currPrice;
  int mileage; // in km


  Car(
      // Super constructors
      super.name,
      super.brand,
      super.year,
      super.newPrice,
      super.type,
      super.tags,
      super.country,
      super.drivetrainType,
      super.engineType,
      super.aspirationType,
      super.space,
      super.power,
      super.weight,
      super.seatCount,
      super.accel,
      super.qmile,
      super.vmax,
      super.handling0,
      super.handling1,
      super.braking,
      super.depCurve,
      super.maxMileage,
      super.minMileage,
      super.performancePoint,
      super.designer,
      this.currPrice,
      this.mileage
      );

}

