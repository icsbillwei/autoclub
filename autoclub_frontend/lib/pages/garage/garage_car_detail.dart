import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GarageCarDetail extends StatelessWidget {
  final Car car;

  GarageCarDetail({required this.car});

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.width * 0.8
        : MediaQuery.of(context).size.width * 0.9;

    double containerHeight = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.height * 0.8
        : MediaQuery.of(context).size.height * 0.9;

    double detailPadding = MediaQuery.of(context).size.height > 1000 ? 150 : 50;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Car Detail',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                  )),
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
                padding: EdgeInsets.all(detailPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    getFlagAssetPath(car.country),
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    car.brandName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                car.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${car.mileage} km',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 22,
                                ),
                              ),
                              SizedBox(height: 25),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Car Type    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '${car.type.name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Car Tags    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${car.tags.map((tag) => tag.name).join(', ')}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              RichText(
                                // Engine
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Engine    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${car.displacement.toStringAsFixed(1)}L ${car.engineType.name} ${car.aspirationType.name}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                // Power / Weight
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Power / Weight (when new)    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${car.power} HP / ${car.weight} Kg',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Drivetrain    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '${car.drivetrainType.acronym}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              RichText(
                                // Designer
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Designer    ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '${car.designer}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: containerWidth / 2.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          car.imgLinks,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
