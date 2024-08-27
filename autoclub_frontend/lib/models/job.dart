import 'dart:math';
import 'location.dart'; // Assuming location.dart is in the same directory

class TempJob {
  final String title;
  final String description;
  final List<String> requirements;
  final int reward;
  final DateTime startTime;
  final SelectedLocation startLocation;
  final SelectedLocation endLocation;
  final String company;
  final String companyLogo;

  TempJob({
    required this.title,
    required this.description,
    required this.requirements,
    required this.reward,
    required this.startTime,
    required this.startLocation,
    required this.endLocation,
    required this.company,
    required this.companyLogo,
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
    ''';
  }
}

TempJob randomizeJob({
  required SelectedLocation startLocation,
  required List<SelectedLocation> possibleEndLocations,
  required String title,
  required String description,
  required List<String> requirements,
  required DateTime startTime,
  required int baseReward,
  required String company,
  required String companyLogo,
  double minMultiplier = 0.8,
  double maxMultiplier = 1.2,
}) {
  final random = Random();
  final endLocation =
      possibleEndLocations[random.nextInt(possibleEndLocations.length)];
  final distance = getDistance(startLocation, endLocation);
  final rewardMultiplier =
      minMultiplier + random.nextDouble() * (maxMultiplier - minMultiplier);
  final reward = (baseReward * distance * rewardMultiplier).toInt();

  return TempJob(
    title: title,
    description: description,
    requirements: requirements,
    reward: reward,
    startTime: startTime,
    startLocation: startLocation,
    endLocation: endLocation,
    company: company,
    companyLogo: companyLogo,
  );
}
