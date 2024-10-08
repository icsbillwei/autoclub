import 'dart:math';
import '../utilities/car_utilities.dart';

double usedCarDamagePriceRatio = 1.0;

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
  double displacement;
  EngineAspiration aspirationType;
  CargoSpace space;

  int power;
  int weight;
  int seatCount;

  /*
  Acceleration, in 0-100 km/h time in seconds
  less is better
   */
  double accel;

  /*
  Acceleration, in 0-400m distance time in seconds
  less is better
   */
  double qmile;

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
      ratio: 0.3,
      description:
          "Engine component\nMajorly affects acceleration and speed\nIt is a critical component");

  Component drivetrain = Component(
      name: "Drivetrain",
      damage: ComponentDamage.none,
      ratio: 0.2,
      description:
          "Drivetrain component\nAffects acceleration and slightly affects speed\nIt is a critical component");

  Component suspension = Component(
      name: "Suspension",
      damage: ComponentDamage.none,
      ratio: 0.15,
      description:
          "Suspension component\nAffects handling and slightly affects braking\nIt is a critical component");

  Component bodywork = Component(
      name: "Bodywork",
      damage: ComponentDamage.none,
      ratio: 0.15,
      description:
          "Bodywork component\nSomewhat affects speed and fast handling\nJobs might have body condition requirements");

  Component interior = Component(
      name: "Interior",
      damage: ComponentDamage.none,
      ratio: 0.08,
      description:
          "Interior of the car\nDoes not affect performance\nJobs might have interior condition requirements");

  Component wheelsTires = Component(
      name: "Wheels and Tires",
      damage: ComponentDamage.none,
      ratio: 0.12,
      description:
          "Wheels and Tires component\nAffects everything\nIt is a critical component");

  String imgLinks;
  late List<Component> componentList;

  String designer;

  CarModel(
      {required this.id,
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
      required this.displacement,
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
      required this.imgLinks,
      required this.designer}) {
    updatePerfStats();
    updatePerfPoint();
    componentList = [
      engine,
      drivetrain,
      suspension,
      bodywork,
      interior,
      wheelsTires
    ];
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

  void updatePerfPoint(
      {
      // Default weightings for each stat
      double launchWeight = 0.15,
      double accelWeight = 0.3,
      double speedWeight = 0.2,
      double handlingWeight = 0.25,
      double brakingWeight = 0.10}) {
    performancePoint = ((launchStat * launchWeight +
                accelStat * accelWeight +
                speedStat * speedWeight +
                handlingStat * handlingWeight +
                brakingStat * brakingWeight) *
            100)
        .toInt();
  }

  String fullName() {
    return "$year $brandName $name";
  }

  @override
  String toString() {
    final componentsString =
        componentList.map((component) => component.name).join(', ');
    final tagsString = tags.map((tag) => tag.name).join(', ');

    return '''
        CarModel Details:
          ID: $id
          Name: $name
          Brand Name: $brandName
          Year: $year
          New Price: $newPrice
          Type: ${type.name}
          Tags: $tagsString
          Country: ${country.name}
          Drivetrain Type: ${drivetrainType.acronym}
          Engine Type: ${engineType.name}
          Aspiration Type: ${aspirationType.name}
          Space: ${space.name}
          Power: $power
          Weight: $weight
          Seat Count: $seatCount
          Acceleration (0-100 km/h): $accel s
          Quarter Mile Time: $qmile s
          Top Speed: $vmax km/h
          Short Radius Handling: $handling0 G
          Long Radius Handling: $handling1 G
          Braking Distance: $braking m
          Depreciation Curve: $depCurve
          Max Mileage: $maxMileage
          Min Mileage: $minMileage
          Performance Point: $performancePoint
          Power-to-Weight Ratio: ${pwRatio.toString()}
          Designer: $designer
          Components: $componentsString
            ''';
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

  /*
  Adjusted performance of the car based on damages
   */
  late double currAccel;
  late double currQmile;
  late int currVmax;
  late double currHandling0;
  late double currHandling1;
  late double currBraking;

  late double currLaunchStat;
  late double currAccelStat;
  late double currSpeedStat;
  late double currHandlingStat;
  late double currBrakingStat;

  late int currPerformancePoint;

  late int userCarID;

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
    required double displacement,
    required EngineAspiration aspirationType,
    required CargoSpace space,
    required int power,
    required int weight,
    required int seatCount,
    required double accel,
    required double qmile,
    required int vmax,
    required double handling0,
    required double handling1,
    required double braking,
    required double depCurve,
    required int maxMileage,
    required int minMileage,
    required int performancePoint,
    required String imgLinks,
    required String designer,
    required this.currPrice,
    required this.mileage,
    required this.qualityStar,
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
          displacement: displacement,
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
          imgLinks: imgLinks,
          designer: designer,
        ) {
    initRandomUsed();
  }

  Car.fromModel({
    /*
    Constructor for generating Car object from CarModel object
     */
    required CarModel model,
    this.currPrice = 0,
    this.mileage = 0,
    this.qualityStar = 0,
    this.currAccel = 0,
    this.currQmile = 0,
    this.currVmax = 0,
    this.currHandling0 = 0,
    this.currHandling1 = 0,
    this.currBraking = 0,
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
          displacement: model.displacement,
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
          imgLinks: model.imgLinks,
          designer: model.designer,
        ) {
    initRandomUsed();
  }

  /*
  Copy constructor
   */
  Car.clone(Car car)
      : currPrice = car.currPrice,
        mileage = car.mileage,
        qualityStar = car.qualityStar,
        currAccel = car.currAccel,
        currQmile = car.currQmile,
        currVmax = car.currVmax,
        currHandling0 = car.currHandling0,
        currHandling1 = car.currHandling1,
        currBraking = car.currBraking,
        currLaunchStat = car.currLaunchStat,
        currAccelStat = car.currAccelStat,
        currSpeedStat = car.currSpeedStat,
        currHandlingStat = car.currHandlingStat,
        currBrakingStat = car.currBrakingStat,
        currPerformancePoint = car.currPerformancePoint,
        userCarID = car.userCarID,
        super(
          id: car.id,
          name: car.name,
          brandName: car.brandName,
          year: car.year,
          newPrice: car.newPrice,
          type: car.type,
          tags: car.tags,
          country: car.country,
          drivetrainType: car.drivetrainType,
          engineType: car.engineType,
          displacement: car.displacement,
          aspirationType: car.aspirationType,
          space: car.space,
          power: car.power,
          weight: car.weight,
          seatCount: car.seatCount,
          accel: car.accel,
          qmile: car.qmile,
          vmax: car.vmax,
          handling0: car.handling0,
          handling1: car.handling1,
          braking: car.braking,
          depCurve: car.depCurve,
          maxMileage: car.maxMileage,
          minMileage: car.minMileage,
          imgLinks: car.imgLinks,
          designer: car.designer,
        ) {
    componentList = List.from(car.componentList);
    // print("cloned car: $name");
    print(toString());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brandName': brandName,
      'year': year,
      'newPrice': newPrice,
      'type': type.name,
      'tags': tags.map((tag) => tag.name).toList(),
      'country': country.name,
      'drivetrainType': drivetrainType.acronym,
      'engineType': engineType.name,
      'displacement': displacement,
      'aspirationType': aspirationType.name,
      'space': space.name,
      'power': power,
      'weight': weight,
      'seatCount': seatCount,
      'accel': accel,
      'qmile': qmile,
      'vmax': vmax,
      'handling0': handling0,
      'handling1': handling1,
      'braking': braking,
      'depCurve': depCurve,
      'maxMileage': maxMileage,
      'minMileage': minMileage,
      'performancePoint': performancePoint,
      'imgLinks': imgLinks,
      'designer': designer,
      'currPrice': currPrice,
      'mileage': mileage,
      'qualityStar': qualityStar,
      'currAccel': currAccel,
      'currQmile': currQmile,
      'currVmax': currVmax,
      'currHandling0': currHandling0,
      'currHandling1': currHandling1,
      'currBraking': currBraking,
      'currLaunchStat': currLaunchStat,
      'currAccelStat': currAccelStat,
      'currSpeedStat': currSpeedStat,
      'currHandlingStat': currHandlingStat,
      'currBrakingStat': currBrakingStat,
      'currPerformancePoint': currPerformancePoint,
      'userCarID': userCarID,
      'components':
          componentList.map((component) => component.toMap()).toList(),
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      name: map['name'],
      brandName: map['brandName'],
      year: map['year'],
      newPrice: map['newPrice'],
      type: CarType.values.firstWhere((e) => e.name == map['type']),
      tags: List<CarTag>.from(map['tags']
          .map((tag) => CarTag.values.firstWhere((e) => e.name == tag))),
      country: Country.values.firstWhere((e) => e.name == map['country']),
      drivetrainType: DrivetrainType.values
          .firstWhere((e) => e.acronym == map['drivetrainType']),
      engineType:
          EngineType.values.firstWhere((e) => e.name == map['engineType']),
      displacement: map['displacement'],
      aspirationType: EngineAspiration.values
          .firstWhere((e) => e.name == map['aspirationType']),
      space: CargoSpace.values.firstWhere((e) => e.name == map['space']),
      power: map['power'],
      weight: map['weight'],
      seatCount: map['seatCount'],
      accel: map['accel'],
      qmile: map['qmile'],
      vmax: map['vmax'],
      handling0: map['handling0'],
      handling1: map['handling1'],
      braking: map['braking'],
      depCurve: map['depCurve'],
      maxMileage: map['maxMileage'],
      minMileage: map['minMileage'],
      performancePoint: map['performancePoint'],
      imgLinks: map['imgLinks'],
      designer: map['designer'],
      currPrice: map['currPrice'],
      mileage: map['mileage'],
      qualityStar: map['qualityStar'],
    )
      ..currAccel = map['currAccel']
      ..currQmile = map['currQmile']
      ..currVmax = map['currVmax']
      ..currHandling0 = map['currHandling0']
      ..currHandling1 = map['currHandling1']
      ..currBraking = map['currBraking']
      ..currLaunchStat = map['currLaunchStat']
      ..currAccelStat = map['currAccelStat']
      ..currSpeedStat = map['currSpeedStat']
      ..currHandlingStat = map['currHandlingStat']
      ..currBrakingStat = map['currBrakingStat']
      ..currPerformancePoint = map['currPerformancePoint']
      ..userCarID = map['userCarID']
      ..componentList = List<Component>.from(
          map['components'].map((component) => Component.fromMap(component)));
  }

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

      case (> 15000 && <= 100000):
        qualityStar = (cointoss) ? 5 : 4;

      case (> 100000 && <= 150000):
        qualityStar = (cointoss) ? 4 : 3;

      case (> 150000 && <= 220000):
        qualityStar = (cointoss) ? 3 : 2;

      case (> 220000 && <= 300000):
        qualityStar = (cointoss) ? 2 : 1;

      case (> 300000):
        qualityStar = 1;
    }
    initRandomDamage(qualityStar);
    valuation();
    updateUsedPerformance();
  }

  void initRandomDamage(int star) {
    /*
    Damage rates are as following for each slot:
    6 star - 3% light
    97% no damage

    5 star - 15% light, 3% medium
    75% no damage

    4 star - 30% light, 10% medium, 3% heavy,
    56% no damage

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
          if (rng <= 3) {
            c.damage = ComponentDamage.light;
          }

        case 5:
          if (rng <= 3) {
            c.damage = ComponentDamage.medium;
          } else if (rng <= 18) {
            c.damage = ComponentDamage.light;
          }

        case 4:
          if (rng <= 3) {
            c.damage = ComponentDamage.severe;
          } else if (rng <= 13) {
            c.damage = ComponentDamage.medium;
          } else if (rng <= 43) {
            c.damage = ComponentDamage.light;
          }

        case 3:
          if (rng <= 1) {
            c.damage = ComponentDamage.broken;
          } else if (rng <= 16) {
            c.damage = ComponentDamage.severe;
          } else if (rng <= 46) {
            c.damage = ComponentDamage.medium;
          } else if (rng <= 76) {
            c.damage = ComponentDamage.light;
          }

        case 2:
          if (rng <= 5) {
            c.damage = ComponentDamage.broken;
          } else if (rng <= 30) {
            c.damage = ComponentDamage.severe;
          } else if (rng <= 70) {
            c.damage = ComponentDamage.medium;
          } else if (rng <= 90) {
            c.damage = ComponentDamage.light;
          }

        case 1:
          if (rng <= 10) {
            c.damage = ComponentDamage.broken;
          } else if (rng <= 60) {
            c.damage = ComponentDamage.severe;
          } else if (rng <= 90) {
            c.damage = ComponentDamage.medium;
          } else if (rng <= 100) {
            c.damage = ComponentDamage.light;
          }
      }
    }
  }

  void valuation() {
    int newCurrPrice =
        (newPrice * (1 / (0.000001 * depCurve * mileage + 1))).toInt();
    // print("$name:  $newCurrPrice");
    int tempCurrPrice = newCurrPrice;
    for (Component comp in componentList) {
      newCurrPrice -= (tempCurrPrice *
              comp.ratio *
              comp.damage.coef *
              usedCarDamagePriceRatio)
          .toInt();
    }
    // print("$name new:  $newCurrPrice");
    currPrice = newCurrPrice;
  }

  void updateUsedPerformance() {
    Map<String, List<List<double>>> damageRatioMatrix = {
      // ratio of perf. for each stat for each damage level
      //      0-100, qmile, spd, hdl, brk
      "Engine": [
        // None Light Medium Severe Broken
        [1, 1.05, 1.2, 1.6, 999], // 0-100
        [1, 1.04, 1.12, 1.3, 999], // qmile
        [1, 0.97, 0.9, 0.75, 0], // speed
        [1, 1, 1, 1, 0], // handling0
        [1, 1, 1, 1, 0], // handling1
        [1, 1, 1, 1, 999] // braking
      ],
      "Drivetrain": [
        [1, 1.05, 1.2, 1.4, 999], // 0-100
        [1, 1.02, 1.08, 1.2, 999], // qmile
        [1, 0.99, 0.97, 0.95, 0], // speed
        [1, 1, 1, 1, 0], // handling0
        [1, 1, 1, 1, 0], // handling1
        [1, 1, 1, 1, 999] // braking
      ],
      "Suspension": [
        [1, 1.01, 1.05, 1.15, 999], // 0-100
        [1, 1, 1, 1, 999], // qmile
        [1, 1, 1, 1, 0], // speed
        [1, 0.95, 0.85, 0.6, 0], // handling0
        [1, 0.95, 0.85, 0.6, 0], // handling1
        [1, 1.01, 1.04, 1.1, 999] // braking
      ],
      "Bodywork": [
        [1, 1, 1, 1, 1], // 0-100
        [1, 1, 1, 1, 1], // qmile
        [1, 1, 0.99, 0.95, 0.9], // speed
        [1, 1, 1, 1, 1], // handling0
        [1, 1, 0.98, 0.96, 0.9], // handling1
        [1, 1, 1, 1, 1] // braking
      ],
      "Interior": [
        [1, 1, 1, 1, 1], // 0-100
        [1, 1, 1, 1, 1], // qmile
        [1, 1, 1, 1, 1], // speed
        [1, 1, 1, 1, 1], // handling0
        [1, 1, 1, 1, 1], // handling1
        [1, 1, 1, 1, 1] // braking
      ],
      "Wheels and Tires": [
        [1, 1.05, 1.15, 1.5, 999], // 0-100
        [1, 1.01, 1.05, 1.2, 999], // qmile
        [1, 0.92, 0.8, 0.55, 0], // speed
        [1, 0.9, 0.78, 0.62, 0], // handling0
        [1, 0.9, 0.78, 0.62, 0], // handling1
        [1, 1.1, 1.4, 2, 999] // braking
      ],
    };

    // print("prevAccel: $accel");
    // print("prevQmile: $qmile");
    // print("prevVmax: $vmax");
    // print("prevHandling0: $handling0");
    // print("prevHandling1: $handling1");
    // print("prevBraking: $braking");

    currAccel = accel;
    currQmile = qmile;
    currVmax = vmax;
    currHandling0 = handling0;
    currHandling1 = handling1;
    currBraking = braking;

    for (Component c in componentList) {
      // print("name: ${c.name}");
      List<List<double>> damageRatio = damageRatioMatrix[c.name]!;
      // print(damageRatio);
      currAccel = currAccel * damageRatio[0][c.damage.level];
      currQmile = currQmile * damageRatio[1][c.damage.level];
      currVmax = (currVmax * damageRatio[2][c.damage.level]).toInt();
      currHandling0 = currHandling0 * damageRatio[3][c.damage.level];
      currHandling1 = currHandling1 * damageRatio[4][c.damage.level];
      currBraking = currBraking * damageRatio[5][c.damage.level];
    }

    currAccel = currAccel > 99 ? 99 : currAccel;
    currQmile = currQmile > 99 ? 99 : currQmile;
    currVmax = currVmax < 0 ? 0 : currVmax;
    // If top speed less than 100, 0-100 is infinite
    currAccel = currVmax < 100 ? 99.99 : currAccel;
    currHandling0 = currHandling0 < 0 ? 0 : currHandling0;
    currHandling1 = currHandling1 < 0 ? 0 : currHandling1;
    currBraking = currBraking > 99 ? 99 : currBraking;

    updateUsedPerfStats();
    updateUsedPerfPoint();
  }

  void updateUsedPerfStats() {
    /*
    Update stat values
     */
    // print("accel: $currAccel");
    // print("qmile: $currQmile");
    // print("vmax: $currVmax");
    // print("handling0: $currHandling0");
    // print("handling1: $currHandling1");
    // print("braking: $currBraking");

    currLaunchStat = 18 / currAccel;
    currAccelStat = 38.5 / (currQmile - 4) - 1;
    currSpeedStat = (currVmax - 60) / 44;
    currHandlingStat = 1.666 * (currHandling0 + currHandling1);
    currBrakingStat = 200 / (currBraking - 6.6) - 3;

    currLaunchStat = currLaunchStat < 0 ? 0 : currLaunchStat;
    currAccelStat = currAccelStat < 0 ? 0 : currAccelStat;
    currSpeedStat = currSpeedStat < 0 ? 0 : currSpeedStat;
    currHandlingStat = currHandlingStat < 0 ? 0 : currHandlingStat;
    currBrakingStat = currBrakingStat < 0 ? 0 : currBrakingStat;
  }

  void updateUsedPerfPoint(
      {
      // Default weightings for each stat
      double launchWeight = 0.15,
      double accelWeight = 0.3,
      double speedWeight = 0.2,
      double handlingWeight = 0.25,
      double brakingWeight = 0.10}) {
    currPerformancePoint = ((currLaunchStat * launchWeight +
                currAccelStat * accelWeight +
                currSpeedStat * speedWeight +
                currHandlingStat * handlingWeight +
                currBrakingStat * brakingWeight) *
            100)
        .toInt();
    // print("$name: $currPerformancePoint");
    if (currPerformancePoint < 0) {
      currPerformancePoint = 0;
    }
  }

  bool hasBrokenComponents() {
    for (Component component in componentList) {
      if (component.name == "Bodywork" || component.name == "Interior") {
        continue;
      }
      if (component.damage == ComponentDamage.broken) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    final componentsString = componentList.map((component) {
      return '''
      Component: ${component.name}
        Damage: ${component.damage.name}
    ''';
    }).join('\n');

    final tagsString = tags.map((tag) => tag.name).join(', ');

    return '''
    CarModel Details:
      ID: $id
      Name: $name
      Brand Name: $brandName
      Year: $year
      New Price: $newPrice
      Type: ${type.name}
      Tags: $tagsString
      Country: ${country.name}
      Drivetrain Type: ${drivetrainType.acronym}
      Engine Type: ${engineType.name}
      Aspiration Type: ${aspirationType.name}
      Space: ${space.name}
      Power: $power
      Weight: $weight
      Seat Count: $seatCount
      Acceleration (0-100 km/h): $accel s
      Quarter Mile Time: $qmile s
      Top Speed: $vmax km/h
      Short Radius Handling: $handling0 G
      Long Radius Handling: $handling1 G
      Braking Distance: $braking m
      Depreciation Curve: $depCurve
      Max Mileage: $maxMileage
      Min Mileage: $minMileage
      Performance Point: $performancePoint
      Power-to-Weight Ratio: ${pwRatio.toString()}
      Designer: $designer
      currPrice: $currPrice
      Mileage: $mileage
      Quality Star: $qualityStar
      carID: $userCarID
      Components:
        $componentsString
      Current Stats:
        Current Acceleration (0-100 km/h): $currAccel s
        Current Quarter Mile Time: $currQmile s
        Current Top Speed: $currVmax km/h
        Current Short Radius Handling: $currHandling0 G
        Current Long Radius Handling: $currHandling1 G
        Current Braking Distance: $currBraking m
  ''';
  }
}
