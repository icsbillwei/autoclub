import 'dart:math';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/job_requirements.dart';

import 'location.dart'; // Assuming location.dart is in the same directory

class JobType {
  final String name;
  final String company;
  final String companyLogo;
  final List<CarRequirement> requirements;
  final double rewardMultiplierRangeStart;
  final double rewardMultiplierRangeEnd;
  final double baseReward;
  final String defaultDescription;

  JobType({
    required this.name,
    required this.company,
    required this.companyLogo,
    required this.requirements,
    this.rewardMultiplierRangeStart = 0.8,
    this.rewardMultiplierRangeEnd = 1.2,
    required this.baseReward,
    this.defaultDescription = "",
  });

  double generateRewardMultiplier() {
    final random = Random();
    return rewardMultiplierRangeStart +
        random.nextDouble() *
            (rewardMultiplierRangeEnd - rewardMultiplierRangeStart);
  }
}

class TempJob {
  final String title;
  final String description;
  final List<CarRequirement> requirements;
  final int reward;
  final SelectedLocation startLocation;
  final SelectedLocation endLocation;
  final String company;
  final String companyLogo;
  final int distance;
  final int extraDistance;
  final String endLocationName;

  TempJob({
    required this.title,
    required this.description,
    required this.requirements,
    required this.reward,
    required this.startLocation,
    required this.endLocation,
    required this.company,
    required this.companyLogo,
    this.distance = 0,
    this.extraDistance = 0,
    this.endLocationName = "",
  });

  // Factory constructor for randomizing job from JobType
  factory TempJob.randomizeJobFromType({
    required JobType jobType,
    required SelectedLocation startLocation,
    required List<SelectedLocation> possibleEndLocations,
  }) {
    final random = Random();
    final endLocation =
        possibleEndLocations[random.nextInt(possibleEndLocations.length)];
    final distance = getDistance(startLocation, endLocation);
    final rewardMultiplier = jobType.generateRewardMultiplier();
    final reward = (jobType.baseReward * distance * rewardMultiplier).toInt();

    return TempJob(
      title: "${jobType.name} - to ${endLocation.name}",
      description: jobType.defaultDescription,
      requirements: jobType.requirements,
      reward: reward,
      startLocation: startLocation,
      endLocation: endLocation,
      company: jobType.company,
      companyLogo: jobType.companyLogo,
      distance: distance,
      endLocationName: endLocation.name,
    );
  }

  // Factory constructor for generic random job creation
  factory TempJob.randomizeJob({
    required SelectedLocation startLocation,
    required List<SelectedLocation> possibleEndLocations,
    required String title,
    required String description,
    required List<CarRequirement> requirements,
    required double baseReward,
    required String company,
    required String companyLogo,
    int extraDistance = 0,
    double minMultiplier = 0.8,
    double maxMultiplier = 1.2,
  }) {
    final random = Random();
    final endLocation =
        possibleEndLocations[random.nextInt(possibleEndLocations.length)];
    final distance = getDistance(startLocation, endLocation) + extraDistance;
    final rewardMultiplier =
        minMultiplier + random.nextDouble() * (maxMultiplier - minMultiplier);
    final reward = (baseReward * distance * rewardMultiplier).toInt();

    return TempJob(
      title: title,
      description: description,
      requirements: requirements,
      reward: reward,
      startLocation: startLocation,
      endLocation: endLocation,
      company: company,
      companyLogo: companyLogo,
      distance: distance,
    );
  }

  bool checkAllRequirements(Car car) {
    for (var requirement in requirements) {
      if (!requirement.check(car)) {
        return false;
      }
    }
    return true;
  }

  int getTravelTime(double averageSpeed) {
    const double timeMultiplier = 2;
    return ((distance / averageSpeed) * 60 * timeMultiplier).ceil();
  }

  @override
  String toString() {
    return '''
    Job Details:
      Title: $title
      Description: $description
      Start Location: ${startLocation.name}
      End Location: ${endLocation.name}
      Reward: $reward
      Company: $company
      Company Logo: $companyLogo
    ''';
  }
}
