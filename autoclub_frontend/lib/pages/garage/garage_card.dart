import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart'; // Ensure the path matches your project structure

class GarageCard extends StatelessWidget {
  final Car car;

  GarageCard({required this.car});

  @override
  Widget build(BuildContext context) {
    double imageHeight = 150; // Example fixed height for image

    return Row(
      children: [
        SizedBox(
          height: imageHeight,
          child: Image.network(
            car.imgLinks,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  car.fullName(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 5),
                Text(
                  "${car.mileage} km",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
