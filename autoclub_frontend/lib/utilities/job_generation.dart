import 'dart:math';

import 'package:autoclub_frontend/models/job.dart';
import 'package:autoclub_frontend/models/location.dart';
import 'package:autoclub_frontend/utilities/job_requirements.dart';

const double _globalRewardMultiplier = 2.0;

final uberJobs = [
  youberDriver,
  youberXLDriver,
];

final taxiJobs = [
  privateTaxi,
  privateTaxiFamily,
];

final courierJobs = [
  courierFurnitureSmall,
  courierFurnitureLarge,
  courierGardenSupplies,
  courierElectronics,
  courierTuningParts,
];

final hotelJobs = [
  hotelVIPShuttle,
  hotelVIPShuttleXL,
];

final allJobs = [
  ...uberJobs,
  ...taxiJobs,
  ...courierJobs,
  ...hotelJobs,
];

JobType youberDriver = JobType(
    name: "Youber Standard",
    company: "Youber",
    companyLogo: "images/company-logos/youber.png",
    requirements: [hasCar, noBrokenComponents, smallCargoSpace],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1,
    baseReward: 1 * _globalRewardMultiplier,
    defaultDescription:
        "The most basic youber service that goes from A to B. Show up with a working car and you should be fine.");

JobType youberXLDriver = JobType(
    name: "Youber XL",
    company: "Youber",
    companyLogo: "images/company-logos/youber.png",
    requirements: [hasCar, noBrokenComponents, largeCargoSpace, fiveSeats],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1,
    baseReward: 1.4 * _globalRewardMultiplier,
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
      noMediumInteriorDamage
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.2,
    baseReward: 2.5 * _globalRewardMultiplier,
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
    baseReward: 2.8 * _globalRewardMultiplier,
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
    baseReward: 1.5 * _globalRewardMultiplier,
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
    baseReward: 2 * _globalRewardMultiplier,
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
    baseReward: 2 * _globalRewardMultiplier,
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
    baseReward: 1.5 * _globalRewardMultiplier,
    defaultDescription:
        "Courier service for computer parts. You will need a car with at least XL cargo space.");

JobType courierTuningParts = JobType(
    name: "Courier (Tuning Parts)",
    company: "AT Auto",
    companyLogo: "images/at-auto/at-auto-white.png",
    requirements: [
      hasCar,
      noSevereComponents,
      noMediumBodyDamage,
      xxlCargoSpace
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.1,
    baseReward: 2.2 * _globalRewardMultiplier,
    defaultDescription:
        "Courier service for car tuning parts. You will need a car with at least XXL cargo space.");

JobType hotelVIPShuttle = JobType(
    name: "Hotel VIP Shuttle (Personal)",
    company: "Stilton Hotel",
    companyLogo: "images/company-logos/hotel.png",
    requirements: [
      hasCar,
      noDamage,
      fourSeats,
      largeCargoSpace,
      isLuxuryTaxi,
      noInteriorDamage
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.2,
    baseReward: 4 * _globalRewardMultiplier,
    defaultDescription:
        "Shuttle service for VIP guests. You will need a prestigious and luxurious car in immaculate condition.");

JobType hotelVIPShuttleXL = JobType(
    name: "Hotel VIP Shuttle (Business)",
    company: "Stilton Hotel",
    companyLogo: "images/company-logos/hotel.png",
    requirements: [
      hasCar,
      noDamage,
      sixSeats,
      extraLargeCargoSpace,
      isLuxuryTaxi,
      noInteriorDamage
    ],
    rewardMultiplierRangeStart: 1,
    rewardMultiplierRangeEnd: 1.2,
    baseReward: 5 * _globalRewardMultiplier,
    defaultDescription:
        "Shuttle service for a group of VIP guests. The only possible kind of car for this job is a large and luxurious minivan.");

// ####################### Job Generation #######################

List<TempJob> generateDowntownJobs() {
  final random = Random();
  List<TempJob> jobs = [];

  // Ensure at least 2 regular uberJobs
  for (int i = 0; i < 2; i++) {
    final jobType = uberJobs[0];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.downtown,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.downtown &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  // Generate 1 more random job from uberJobs
  for (int i = 0; i < 1; i++) {
    final jobType = uberJobs[random.nextInt(uberJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.downtown,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.downtown &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  // Generate 3 random jobs from taxiJobs
  for (int i = 0; i < 3; i++) {
    final jobType = taxiJobs[random.nextInt(taxiJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.downtown,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.downtown &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  // Generate 2 random jobs from courierJobs
  for (int i = 0; i < 2; i++) {
    final jobType = courierJobs[random.nextInt(courierJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.downtown,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.downtown &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  return jobs;
}

List<TempJob> generateHotelJobs() {
  final random = Random();
  List<TempJob> jobs = [];

  // Add 1 guaranteed standard youber job
  jobs.add(TempJob.randomizeJobFromType(
    jobType: youberDriver,
    startLocation: SelectedLocation.hotel,
    possibleEndLocations: SelectedLocation.values
        .where((loc) =>
            loc != SelectedLocation.hotel &&
            loc != SelectedLocation.undefined &&
            loc != SelectedLocation.home)
        .toList(),
  ));

  // Add 2 random jobs from the youber list
  for (int i = 0; i < 2; i++) {
    final jobType = uberJobs[random.nextInt(uberJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.hotel,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.hotel &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  // Add 3 random jobs from the taxiJobs list
  for (int i = 0; i < 3; i++) {
    final jobType = taxiJobs[random.nextInt(taxiJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.hotel,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.hotel &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  // Add 4 random jobs from the hotelJobs list
  for (int i = 0; i < 4; i++) {
    final jobType = hotelJobs[random.nextInt(hotelJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: jobType,
      startLocation: SelectedLocation.hotel,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.hotel &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  return jobs;
}

List<TempJob> generateWharfJobs() {
  final random = Random();
  List<TempJob> jobs = [];

  // Add 1 guaranteed standard youber job
  jobs.add(TempJob.randomizeJobFromType(
    jobType: youberDriver,
    startLocation: SelectedLocation.wharf,
    possibleEndLocations: SelectedLocation.values
        .where((loc) =>
            loc != SelectedLocation.wharf &&
            loc != SelectedLocation.undefined &&
            loc != SelectedLocation.home)
        .toList(),
  ));

  // Add 1 random job from the youber list
  final youberJobType = uberJobs[random.nextInt(uberJobs.length)];
  jobs.add(TempJob.randomizeJobFromType(
    jobType: youberJobType,
    startLocation: SelectedLocation.wharf,
    possibleEndLocations: SelectedLocation.values
        .where((loc) =>
            loc != SelectedLocation.wharf &&
            loc != SelectedLocation.undefined &&
            loc != SelectedLocation.home)
        .toList(),
  ));

  // Add 1 random job from the taxiJobs list
  final taxiJobType = taxiJobs[random.nextInt(taxiJobs.length)];
  jobs.add(TempJob.randomizeJobFromType(
    jobType: taxiJobType,
    startLocation: SelectedLocation.wharf,
    possibleEndLocations: SelectedLocation.values
        .where((loc) =>
            loc != SelectedLocation.wharf &&
            loc != SelectedLocation.undefined &&
            loc != SelectedLocation.home)
        .toList(),
  ));

  // Add 6 random jobs from the courierJobs list
  for (int i = 0; i < 6; i++) {
    final courierJobType = courierJobs[random.nextInt(courierJobs.length)];
    jobs.add(TempJob.randomizeJobFromType(
      jobType: courierJobType,
      startLocation: SelectedLocation.wharf,
      possibleEndLocations: SelectedLocation.values
          .where((loc) =>
              loc != SelectedLocation.wharf &&
              loc != SelectedLocation.undefined &&
              loc != SelectedLocation.home)
          .toList(),
    ));
  }

  return jobs;
}
