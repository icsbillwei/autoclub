import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GarageCarDetail extends StatelessWidget {
  final Car car;

  GarageCarDetail({required this.car});

  Color getDamageColor(ComponentDamage damage) {
    switch (damage) {
      case ComponentDamage.none:
        return Color.fromARGB(255, 204, 249, 255);
      case ComponentDamage.light:
        return Color.fromARGB(255, 130, 233, 147);
      case ComponentDamage.medium:
        return Colors.yellow;
      case ComponentDamage.severe:
        return Colors.orange;
      case ComponentDamage.broken:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Widget _buildStatColumn(BuildContext context, String label, double currStat,
      double stat, int rounding, bool maxOverflow) {
    String displayCurrStat;
    if (maxOverflow && currStat >= 98) {
      displayCurrStat = '--';
    } else if (!maxOverflow && currStat == 0) {
      displayCurrStat = '--';
    } else {
      displayCurrStat = currStat.toStringAsFixed(rounding);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$displayCurrStat ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                text: " / ${stat.toStringAsFixed(rounding)} (new)",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.orange,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.width * 0.8
        : MediaQuery.of(context).size.width * 0.9;

    double containerHeight = MediaQuery.of(context).size.height > 1000
        ? MediaQuery.of(context).size.height * 0.8
        : MediaQuery.of(context).size.height * 0.9;

    double detailPadding = MediaQuery.of(context).size.height > 1000 ? 150 : 50;
    double componentPadding = MediaQuery.of(context).size.width > 1000 ? 10 : 0;
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 100, bottom: 100, right: 100),
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
                                SizedBox(height: 70),

                                Center(
                                  child: Text(
                                    "Component Damages",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),

                                SizedBox(height: 10),

                                // Components
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: componentPadding),
                                    child: GridView.count(
                                      clipBehavior: Clip.none,
                                      padding: EdgeInsets.zero,
                                      childAspectRatio: 1.5,
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                      shrinkWrap: true,
                                      children: [
                                        for (var component in car.componentList)
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'images/icons/${component.name.toLowerCase().replaceAll(' ', '')}.svg',
                                                color: getDamageColor(
                                                    component.damage),
                                                width: 50,
                                                height: 50,
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                component.damage.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                      color: getDamageColor(
                                                          component.damage),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 70),
                                Center(
                                  child: Text(
                                    "Car Performance",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Performance Point
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      color: Colors.yellow,
                                      size: 24,
                                    ),
                                    Text(
                                      "Perf. Index",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(width: 20),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${car.currPerformancePoint} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          TextSpan(
                                            text: " / ${car.performancePoint}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  color: Colors.orange,
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                if (car.currVmax <= 1)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.warning, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text(
                                        "Critical component broken",
                                        style: TextStyle(color: Colors.red),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),

                                GridView.count(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.5,
                                  children: [
                                    _buildStatColumn(context, '0-100 km/h (s)',
                                        car.currAccel, car.accel, 2, true),
                                    _buildStatColumn(context, '1/4 Mile (s)',
                                        car.currQmile, car.qmile, 1, true),
                                    _buildStatColumn(
                                        context,
                                        'Top Speed (km/h)',
                                        car.currVmax.toDouble(),
                                        car.vmax.toDouble(),
                                        0,
                                        false),
                                    _buildStatColumn(
                                        context,
                                        'Slow Handling (G)',
                                        car.currHandling0,
                                        car.handling0,
                                        2,
                                        false),
                                    _buildStatColumn(
                                        context,
                                        'Fast Handling (G)',
                                        car.currHandling1,
                                        car.handling1,
                                        2,
                                        false),
                                    _buildStatColumn(
                                        context,
                                        '100-0 Braking (m)',
                                        car.currBraking,
                                        car.braking,
                                        1,
                                        false),
                                  ],
                                ),
                              ],
                            ),
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
                          fit: BoxFit.cover,
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
