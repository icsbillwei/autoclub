import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:simple_shadow/simple_shadow.dart';

class CarDisplay extends StatelessWidget {
  final Car? currentCar;

  CarDisplay({required this.currentCar});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      sigma: 8,
      child: Container(
        height: currentCar == null ? 50 : 80,
        width: currentCar == null ? 300 : 450,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: currentCar == null
            ? Center(
                child: Text(
                  "No Car Selected",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 16,
                      ),
                ),
              )
            : Row(
                children: [
                  // Left half with car image
                  Container(
                    width: 120.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(currentCar!.imgLinks),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  // Right half with text
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Current Car",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            currentCar!.fullName(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
