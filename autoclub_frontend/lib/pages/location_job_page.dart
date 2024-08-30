import 'package:autoclub_frontend/components/job_card.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/job.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'dart:math';

class LocationJobPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final List<TempJob> jobs;
  final Car userCar;
  final Function handleJobAcceptance;

  LocationJobPage({
    required this.name,
    required this.imagePath,
    required this.jobs,
    required this.userCar,
    required this.handleJobAcceptance,
  });

  @override
  _LocationJobPageState createState() => _LocationJobPageState();
}

class _LocationJobPageState extends State<LocationJobPage> {
  double getRandomSpeed() {
    final random = Random();
    final chance = random.nextInt(100); // Generates a number between 0 and 99

    return 1; // Default speed
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor:
          Colors.transparent, // Ensuring dialog background is transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              20.0), // Rounded corners for the whole dialog
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Left half with image and overlaid title
            Container(
              width: screenWidth * 0.8 * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(30.0),
                child: SimpleShadow(
                  sigma: 10,
                  opacity: 1,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Right half with black background and exit button
            Container(
              width: screenWidth * 0.8 * 0.7,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        SizedBox(height: 40), // Space for the exit button
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListView.builder(
                              itemCount: widget.jobs.length,
                              itemBuilder: (context, index) {
                                final job = widget.jobs[index];
                                final speed = getRandomSpeed();
                                return JobCard(
                                  job: job,
                                  car: widget.userCar,
                                  handleJobAcceptance:
                                      widget.handleJobAcceptance,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
