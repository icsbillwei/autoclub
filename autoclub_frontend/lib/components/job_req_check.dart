import 'package:autoclub_frontend/utilities/job_requirements.dart';
import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';

class RequirementsPopup extends StatelessWidget {
  final Car car;
  final List<CarRequirement> requirements;

  RequirementsPopup({required this.car, required this.requirements});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.all(20),
      insetPadding:
          EdgeInsets.symmetric(horizontal: 80.0), // Make the dialog wider
      title: Text(
        'Job Requirements',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: requirements.map((requirement) {
            bool isSatisfied = requirement.check(car);
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 4.0), // Add spacing between items
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      requirement.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: 100),
                  Icon(
                    isSatisfied ? Icons.check_circle : Icons.cancel,
                    color: isSatisfied ? Colors.green : Colors.red,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
