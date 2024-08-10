import 'dart:math';

import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';

List<Car> pickRandomCars(List<CarModel> list, int count) {
  List<CarModel> temp = List<CarModel>.from(list);
  temp.shuffle(Random());
  List<CarModel> carModelList = temp.take(count).toList();

  return carModelList.map((model) {
    // Create a Car object from the CarModel object
    final car = Car.fromModel(
      model: model,
    );
    return car;
  }).toList();
}

String titleDescription(Car car) {
  String aspiration = "";
  if (car.aspirationType != EngineAspiration.ev) {
    aspiration = "${car.aspirationType.name} ";
  }
  String engine = car.engineType.fullName;

  String engineLocation = "";
  if (car.drivetrainType == DrivetrainType.mawd ||
      car.drivetrainType == DrivetrainType.mr) {
    engineLocation = "mid-engined ";
  } else if (car.drivetrainType == DrivetrainType.rr) {
    engineLocation = "rear-engined ";
  }

  String drivetrain = "";
  if (car.drivetrainType == DrivetrainType.fawd) {
    drivetrain = "all-wheel drive";
  } else if (car.drivetrainType == DrivetrainType.fourwd) {
    drivetrain = "4X4";
  }

  return "$aspiration$engine $engineLocation$drivetrain";
}

List<Map<String, dynamic>> generateUsedCarListings(
  int length,
  List<CarModel> gameCarList,
) {
  List<Car> usedCarList = pickRandomCars(gameCarList, length);

  List<Map<String, dynamic>> usedCarListings = usedCarList.map((car) {
    int randomRange = (car.currPrice * 0.03).toInt();
    int randomSalePrice = car.currPrice + rangeRandom(0, randomRange);
    randomSalePrice = randomSalePrice ~/ 10 * 10; // rounds it to 10th place
    String thumbnailImg = (car.imgLinks != "none")
        ? car.imgLinks
        : "https://i.imgur.com/ak0gS4U.png";
    return {
      "carObject": car,
      "titleDescription": titleDescription(car),
      "thumbnailLink": thumbnailImg, // todo: replace this
      "salePrice": randomSalePrice
    };
  }).toList();

  /*
  for (final uc in usedCarListings) {
    print(uc["carObject"]);
    print("saleprice: ${uc["salePrice"]}");
    print("title desc: ${uc["titleDescription"]}");
    print("\n\n\n");
  }
   */
  return usedCarListings;
}
