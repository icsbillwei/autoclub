import 'package:autoclub_frontend/models/car.dart';

class JobRequirement {
  final String description;
  final Function(Car) requirement;

  JobRequirement({required this.description, required this.requirement});
}

class TempJob {
  final String title;
  final String description;
  final List<JobRequirement> requirements;
  final int reward;

  final int startHour;
  final int duration;

  TempJob({
    required this.title,
    required this.description,
    required this.requirements,
    required this.reward,
    required this.startHour,
    required this.duration,
  });
}
