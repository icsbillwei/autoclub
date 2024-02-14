import 'dart:math';

import 'brands.dart';
import 'car_utilities.dart';



int rangeRandom(min, max) {
  final random = Random();
  return min + random.nextInt(max - min);
}


class CarModel {
  /*
  Car object that represents a car in the game.
  This is a basic representation, and the cars that the player would obtain is in the subclass Car.
   */

  /*
  TODO: Fuel economy vals
   */

  int id;
  // Brand brand; TODO: implement brand system
  String brandName;
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
  double handling0;

  /*
  Long radius (200m) cornering handling, in G value
  more is better
   */
  double handling1;

  /*
  Braking distance from 100 - 0 km/h, in m
  less is better
   */
  double braking;

  /*
  Coefficient for the depreciation calculation
   */
  double depCurve;

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

  List<String>? dealerDescription;

  /*
  Various components for the car2
   */
  Component engine = Component(
      name: "Engine",
      damage: ComponentDamage.none,
      ratio: 0.3
  );

  Component drivetrain = Component(
      name: "Drivetrain",
      damage: ComponentDamage.none,
      ratio: 0.2
  );

  Component suspension = Component(
      name: "Suspension",
      damage: ComponentDamage.none,
      ratio: 0.15
  );

  Component bodywork = Component(
      name: "Bodywork",
      damage: ComponentDamage.none,
      ratio: 0.15
  );

  Component interior = Component(
      name: "Interior",
      damage: ComponentDamage.none,
      ratio: 0.08
  );

  Component wheelsTires = Component(
      name: "Wheels and Tires",
      damage: ComponentDamage.none,
      ratio: 0.12
  );

  late List<Component> componentList;

  String designer;


  CarModel({
    required this.id,
    required this.name,
    // required this.brand,
    required this.brandName,
    required this.year,
    required this.newPrice,
    required this.type,
    required this.tags,
    required this.country,
    required this.drivetrainType,
    required this.engineType,
    required this.aspirationType,
    required this.space,
    required this.power,
    required this.weight,
    required this.seatCount,
    required this.accel,
    required this.qmile,
    required this.vmax,
    required this.handling0,
    required this.handling1,
    required this.braking,
    required this.depCurve,
    required this.maxMileage,
    required this.minMileage,
    required this.designer
  }){
    updatePerfStats();
    componentList = [engine, drivetrain, suspension, bodywork, interior, wheelsTires];
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
  This will be the car class that is sold in dealerships and the player would use
  Includes functionalities and additional params
   */

  int currPrice;
  int mileage; // in km

  /*
  Hidden stat, indicates the general quality level of the car
  Used for used dealer generation
  Used dealer description is also based on stat
  Scale is 1-6 with 6 being brand new
   */
  int qualityStar;


  Car({
    required int id,
    required String name,
    // required Brand brand,
    required String brandName,
    required int year,
    required int newPrice,
    required CarType type,
    required List<CarTag> tags,
    required Country country,
    required DrivetrainType drivetrainType,
    required EngineType engineType,
    required EngineAspiration aspirationType,
    required CargoSpace space,
    required int power,
    required int weight,
    required int seatCount,
    required int accel,
    required int qmile,
    required int vmax,
    required double handling0,
    required double handling1,
    required double braking,
    required double depCurve,
    required int maxMileage,
    required int minMileage,
    required int performancePoint,
    required String designer,
    required this.currPrice,
    required this.mileage,
    required this.qualityStar
  }) : super(
    id: id,
    name: name,
    // brand: brand,
    brandName: brandName,
    year: year,
    newPrice: newPrice,
    type: type,
    tags: tags,
    country: country,
    drivetrainType: drivetrainType,
    engineType: engineType,
    aspirationType: aspirationType,
    space: space,
    power: power,
    weight: weight,
    seatCount: seatCount,
    accel: accel,
    qmile: qmile,
    vmax: vmax,
    handling0: handling0,
    handling1: handling1,
    braking: braking,
    depCurve: depCurve,
    maxMileage: maxMileage,
    minMileage: minMileage,
    designer: designer,
  );


  Car.fromModel({
    /*
    Constructor for generating Car object from CarModel object
     */
    required CarModel model,
    required this.currPrice,
    required this.mileage,
    required this.qualityStar,
  }) : super(
    id: model.id,
    name: model.name,
    // brand: model.brand,
    brandName: model.brandName,
    year: model.year,
    newPrice: model.newPrice,
    type: model.type,
    tags: model.tags,
    country: model.country,
    drivetrainType: model.drivetrainType,
    engineType: model.engineType,
    aspirationType: model.aspirationType,
    space: model.space,
    power: model.power,
    weight: model.weight,
    seatCount: model.seatCount,
    accel: model.accel,
    qmile: model.qmile,
    vmax: model.vmax,
    handling0: model.handling0,
    handling1: model.handling1,
    braking: model.braking,
    depCurve: model.depCurve,
    maxMileage: model.maxMileage,
    minMileage: model.minMileage,
    designer: model.designer,
  );


  void initRandomUsed() {
    final random = Random();
    // generates a mileage count based on given min and max values for specific car
    mileage = rangeRandom(minMileage, maxMileage);

    /*
    Generate a quality rating realistically based on the mileage
    Higher mileage cars are more likely to have more things broken, hence lower star rating
     */
    bool cointoss = random.nextBool();
    switch (mileage) {

      case (<= 5000):
        qualityStar = 6;

      case (> 5000 && <= 15000):
        qualityStar = (cointoss) ? 6 : 5;

      case (> 15000 && <= 50000):
        qualityStar = (cointoss) ? 5 : 4;

      case (> 50000 && <= 100000):
        qualityStar = (cointoss) ? 4 : 3;

      case (> 100000 && <= 150000):
        qualityStar = (cointoss) ? 3 : 2;

      case (> 150000 && <= 250000):
        qualityStar = (cointoss) ? 2 : 1;

      case (> 250000):
        qualityStar = 1;
    }
    initRandomDamage(qualityStar);
    valuation();
  }


  void initRandomDamage(int star) {
    /*
    Damage rates are as following for each slot:
    6 star - 3% light
    97% no damage

    5 star - 20% light, 5% medium
    75% no damage

    4 star - 40% light, 10% medium, 3% heavy,
    46% no damage

    3 star - 30% light, 30% medium, 15% heavy, 1% broken
    24% no damage

    2 star - 20% light, 40% medium, 25% heavy, 5% broken
    5% no damage

    1 star - 10% light, 30% medium, 50% heavy, 10% broken
    0% no damage
     */

    for (Component c in componentList) {
      int rng = rangeRandom(1, 100);
      switch (star) {
        case 6:
          if (rng <= 3){
            c.damage = ComponentDamage.light;
          }

        case 5:
          if (rng <= 5) {
            c.damage = ComponentDamage.medium;
          }
          else if (rng <= 25) {
            c.damage = ComponentDamage.light;
          }

        case 4:
          if (rng <= 3) {
            c.damage = ComponentDamage.severe;
          }
          else if (rng <= 13) {
            c.damage = ComponentDamage.medium;
          }
          else if (rng <= 53) {
            c.damage = ComponentDamage.light;
          }

        case 3:
          if (rng <= 1){
            c.damage = ComponentDamage.broken;
          }
          else if (rng <= 16) {
            c.damage = ComponentDamage.severe;
          }
          else if (rng <= 46) {
            c.damage = ComponentDamage.medium;
          }
          else if (rng <= 76) {
            c.damage = ComponentDamage.light;
          }

        case 2:
          if (rng <= 5){
            c.damage = ComponentDamage.broken;
          }
          else if (rng <= 30) {
            c.damage = ComponentDamage.severe;
          }
          else if (rng <= 70) {
            c.damage = ComponentDamage.medium;
          }
          else if (rng <= 90) {
            c.damage = ComponentDamage.light;
          }

        case 1:
          if (rng <= 10){
            c.damage = ComponentDamage.broken;
          }
          else if (rng <= 60) {
            c.damage = ComponentDamage.severe;
          }
          else if (rng <= 90) {
            c.damage = ComponentDamage.medium;
          }
          else if (rng <= 100) {
            c.damage = ComponentDamage.light;
          }
      }
    }
  }


  void valuation() {
    int newCurrPrice = newPrice;
    for (Component comp in componentList) {
      newCurrPrice -= (newPrice * comp.ratio * comp.damage.coef) as int;
    }
    currPrice = newCurrPrice;
  }

}

