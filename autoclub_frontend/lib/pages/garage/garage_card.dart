import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart'; // Ensure the path matches your project structure

class GarageCard extends StatelessWidget {
  final Car car;

  GarageCard({required this.car});

  @override
  Widget build(BuildContext context) {
    double cardWidth = 700;
    double cardHeight = 200;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.only(bottom: 20),
      child: Expanded(
        child: Row(
          children: [
            Image.network(
              car.imgLinks,
              height: cardHeight,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.fullName(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${car.mileage} km",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement navigation to details page
                  },
                ),
                Text('Details', style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(Icons.drive_eta, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement drive functionality
                  },
                ),
                Text('Drive it!', style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
