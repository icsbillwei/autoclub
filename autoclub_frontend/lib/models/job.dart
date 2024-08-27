import 'dart:math';
import 'location.dart'; // Assuming location.dart is in the same directory
import 'car.dart'; // Assuming car.dart is in the same directory

class JobRequirement {
  final String name;
  final bool Function(Car) check;

  JobRequirement({required this.name, required this.check});
}

class TempJob {
  final String title;
  final String description;
  final List<JobRequirement> requirements;
  final int reward;
  final SelectedLocation startLocation;
  final SelectedLocation endLocation;
  final String company;
  final String companyLogo;
  final int duration; // In minutes
  final int extraDistance;
  final Car playerCar;

  TempJob({
    required this.title,
    required this.description,
    required this.requirements,
    required this.reward,
    required this.startLocation,
    required this.endLocation,
    required this.company,
    required this.companyLogo,
    required this.duration,
    required this.playerCar,
    this.extraDistance = 0,
  });

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
      Duration: $duration minutes
    ''';
  }
}

bool checkRequirements(Car car, List<JobRequirement> requirements) {
  for (var requirement in requirements) {
    if (!requirement.check(car)) {
      return false; // If any requirement is not met, return false
    }
  }
  return true; // All requirements are met
}

TempJob randomizeJob({
  required SelectedLocation startLocation,
  required List<SelectedLocation> possibleEndLocations,
  required String title,
  required String description,
  required List<JobRequirement> requirements,
  required DateTime startTime,
  required int baseReward,
  required String company,
  required String companyLogo,
  required int minDuration,
  required int maxDuration,
  required Car playerCar,
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
  final duration = random.nextInt(maxDuration - minDuration + 1) + minDuration;

  return TempJob(
    title: title,
    description: description,
    requirements: requirements,
    reward: reward,
    startLocation: startLocation,
    endLocation: endLocation,
    company: company,
    companyLogo: companyLogo,
    duration: duration,
    playerCar: playerCar,
  );
}
