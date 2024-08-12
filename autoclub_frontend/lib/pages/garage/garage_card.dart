import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/pages/garage/garage_car_detail.dart';

class GarageCard extends StatelessWidget {
  final Car car;
  final Function updateCurrentCar;

  GarageCard({required this.car, required this.updateCurrentCar});

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
            filterQuality: FilterQuality.high,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    car.fullName(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "${car.mileage} km",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GarageCarDetail(car: car),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info, color: Colors.white),
                      label: const Text(
                        'Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () {
                        updateCurrentCar(car);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.directions_car, color: Colors.white),
                      label: const Text(
                        'Drive it!',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
