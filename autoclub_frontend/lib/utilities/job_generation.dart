import 'package:autoclub_frontend/models/job.dart';
import 'package:autoclub_frontend/utilities/job_requirements.dart';

JobType youberDriver = JobType(
    name: "Youber Standard",
    company: "Youber",
    companyLogo: "images/company-logos/youber.png",
    requirements: [hasCar, noBrokenComponents, smallCargoSpace],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1,
    baseReward: 1,
    defaultDescription:
        "The most basic youber service that goes from A to B. Show up with a working car and you should be fine.");

JobType youberXLDriver = JobType(
    name: "Youber XL",
    company: "Youber",
    companyLogo: "images/company-logos/youber.png",
    requirements: [hasCar, noBrokenComponents, largeCargoSpace, fiveSeats],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1,
    baseReward: 1.4,
    defaultDescription:
        "Youber XL is a service for larger groups of people. You need a car with at least 5 seats and a large cargo space.");

JobType privateTaxi = JobType(
    name: "Private Taxi",
    company: "Bay Area Private Taxi",
    companyLogo: "images/company-logos/private-taxi.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      medCargoSpace,
      fourSeats,
      isComfortTaxi,
      noMediumBodyDamage
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.2,
    baseReward: 2.5,
    defaultDescription:
        "Private Taxi for people who wants a comfortable ride. You will need a comfortable car in decent condition.");

JobType privateTaxiFamily = JobType(
    name: "Private Taxi (Family)",
    company: "Bay Area Private Taxi",
    companyLogo: "images/company-logos/private-taxi.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      largeCargoSpace,
      sixSeats,
      isComfortTaxi,
      noMediumInteriorDamage
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.2,
    baseReward: 2.8,
    defaultDescription:
        "Private Taxi for families who wants a comfortable ride. You will need a comfortable car in decent condition with adequate space.");

JobType courierFurnitureSmall = JobType(
    name: "Courier (Furniture)",
    company: "Courierdash",
    companyLogo: "images/company-logos/courier.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      extraLargeCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 1.5,
    defaultDescription:
        "Courier service for small number of furniture pieces. You will need a car with at least XL cargo space.");

JobType courierFurnitureLarge = JobType(
    name: "Moving Service",
    company: "Courierdash",
    companyLogo: "images/company-logos/courier.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      xxlCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 2,
    defaultDescription:
        "Courier service for moving many furnitures. You will need a car with at least XXL cargo space.");

JobType courierGardenSupplies = JobType(
    name: "Courier (Garden Supplies)",
    company: "Courierdash",
    companyLogo: "images/company-logos/courier.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      xxlCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 2,
    defaultDescription:
        "Courier service for garden supplies. You will need a car with at least XXL cargo space.");

JobType courierElectronics = JobType(
    name: "Courier (Electronics)",
    company: "Courierdash",
    companyLogo: "images/company-logos/courier.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      extraLargeCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 1.5,
    defaultDescription:
        "Courier service for computer parts. You will need a car with at least XL cargo space.");

JobType courierTuningParts = JobType(
    name: "Courier (Tuning Parts)",
    company: "AT Auto",
    companyLogo: "images/at-auto/at-atuo-white.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      xxlCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 2.2,
    defaultDescription:
        "Courier service for car tuning parts. You will need a car with at least XXL cargo space.");
