import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/pages/garage/garage_card.dart';

class GaragePage extends StatelessWidget {
  final List<Car> userCarList;
  final int money;
  final Function updateCurrentCar;

  GaragePage(
      {required this.userCarList,
      required this.money,
      required this.updateCurrentCar});

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.width * 0.8
        : MediaQuery.of(context).size.width * 0.9;

    double containerHeight = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.height * 0.8
        : MediaQuery.of(context).size.height * 0.9;

    double containerPadding =
        MediaQuery.of(context).size.height > 1000 ? 30 : 8;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(Icons.close, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.garage, size: 30, color: Colors.white), // Garage icon
              SizedBox(width: 10), // Space between icon and title
              Text('Home',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                      )),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100, // Increased toolbar height
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/garage-bg.png'),
            fit: BoxFit.cover, // Ensures the image covers the full background
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 90, 30, 30),
            child: Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(containerPadding),
                child: userCarList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Image.asset(
                              "images/no_cars.jpg",
                              width: 300,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Nothing to see here if you own no cars...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ])
                    : GridView.extent(
                        childAspectRatio: 3,
                        maxCrossAxisExtent: 800, // Max width for each card
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        padding: const EdgeInsets.all(20),
                        children: userCarList
                            .map((car) => GarageCard(
                                car: car, updateCurrentCar: updateCurrentCar))
                            .toList(),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
