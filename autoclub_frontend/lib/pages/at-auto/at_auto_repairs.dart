import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/components/current_car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ATAutoRepair extends StatelessWidget {
  final Car car;

  ATAutoRepair({required this.car});

  Color getDamageColor(ComponentDamage damage) {
    switch (damage) {
      case ComponentDamage.none:
        return const Color.fromARGB(255, 204, 249, 255);
      case ComponentDamage.light:
        return const Color.fromARGB(255, 130, 233, 147);
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
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double tempAccel = car.currAccel;
    double tempQmile = car.currQmile;
    int tempVmax = car.currVmax;
    double tempHandling0 = car.currHandling0;
    double tempHandling1 = car.currHandling1;
    double tempBraking = car.currBraking;

    double componentPadding =
        MediaQuery.of(context).size.width > 1600 ? 250 : 40;

    return Stack(children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 100,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: const Icon(Icons.close, size: 30, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(100),
            child: Row(
              children: [
                SimpleShadow(
                  sigma: 8,
                  child: Image.asset(
                    'images/at-auto/at-auto-white.png',
                    height: 40,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(
                    width: 20), // Add some space between the image and the text
                const Text(
                  'Services & Repairs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/at-auto/at-auto-shop.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(150, 50, 80, 10),
              child: Row(children: [
                // ################## Left Half
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(right: componentPadding),
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
                                const SizedBox(width: 10),
                                Text(
                                  car.brandName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              car.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 50),
                            const Center(
                              child: Text(
                                "Select a component to repair",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GridView.count(
                              clipBehavior: Clip.none,
                              padding: EdgeInsets.zero,
                              childAspectRatio: 1.5,
                              crossAxisCount: 3,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 25,
                              shrinkWrap: true,
                              children: [
                                for (var component in car.componentList)
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onClick event here
                                      print(
                                          'Component ${component.name} clicked');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Tooltip(
                                        message: component.description,
                                        child: Column(
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
                                            const SizedBox(height: 5),
                                            Text(
                                              component.damage.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                    color: getDamageColor(
                                                        component.damage),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // ################## Right Half
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (car.currVmax <= 1)
                          const Row(
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
                          crossAxisCount: 3,
                          childAspectRatio: 2,
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
                            _buildStatColumn(context, 'Slow Handling (G)',
                                car.currHandling0, car.handling0, 2, false),
                            _buildStatColumn(context, 'Fast Handling (G)',
                                car.currHandling1, car.handling1, 2, false),
                            _buildStatColumn(context, '100-0 Braking (m)',
                                car.currBraking, car.braking, 1, true),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: CarDisplay(
            currentCar: car,
          ),
        ),
      ),
    ]);
  }
}
