import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/components/current_car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ATAutoRepair extends StatefulWidget {
  Car car;
  Car? updatedCar;
  Component? selectedComponent;
  int repairCost = 0;

  ATAutoRepair({required this.car});

  @override
  _ATAutoRepairState createState() => _ATAutoRepairState();
}

class _ATAutoRepairState extends State<ATAutoRepair> {
  @override
  void initState() {
    super.initState();
  }

  void selectComponent(Component component) {
    setState(() {
      widget.selectedComponent = component;
      widget.updatedCar = cloneCarWithReducedDamage(widget.car, component);
    });
    widget.repairCost = (widget.selectedComponent!.damage.coef *
            widget.selectedComponent!.ratio *
            widget.car.currPrice)
        .toInt();
  }

  Car cloneCarWithReducedDamage(Car car, Component component) {
    // Create a clone of the car with one less damage level on the selected component
    Car clonedCar = Car.clone(car);
    Component clonedComponent =
        clonedCar.componentList.firstWhere((c) => c.name == component.name);
    // Adjust the damage level of the cloned component
    if (clonedComponent.damage.level > 0) {
      clonedComponent.damage =
          ComponentDamage.values[clonedComponent.damage.level - 1];
    }
    // Update the car's stats based on the new damage level
    clonedCar.updateUsedPerformance();
    return clonedCar;
  }

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
    double componentPadding =
        MediaQuery.of(context).size.width > 1600 ? 250 : 40;

    return Stack(children: [
      Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 100,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.transparent,
                ],
              ),
            ),
          ),
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
                            SizedBox(
                              height: 200,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  getFlagAssetPath(widget.car.country),
                                  width: 24,
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  widget.car.brandName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.car.name,
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
                              childAspectRatio: 1.2,
                              crossAxisCount: 3,
                              mainAxisSpacing: 25,
                              crossAxisSpacing: 40,
                              shrinkWrap: true,
                              children: [
                                for (var component in widget.car.componentList)
                                  GestureDetector(
                                    onTap: () {
                                      if (component.damage.level == 0) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Component in already in Excellent Condition'),
                                              actions: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        selectComponent(component);
                                        print(
                                            'Component ${component.name} selected');
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color:
                                              widget.selectedComponent?.name ==
                                                      component.name
                                                  ? Colors.orange
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Tooltip(
                                            message: component.description,
                                            child: SvgPicture.asset(
                                              'images/icons/${component.name.toLowerCase().replaceAll(' ', '')}.svg',
                                              color: getDamageColor(
                                                  component.damage),
                                              width: 50,
                                              height: 50,
                                            ),
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
                              ],
                            ),

                            const SizedBox(height: 50),

                            // ################## Repair Menu
                            if (widget.selectedComponent != null &&
                                widget.updatedCar != null)
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'images/icons/${widget.selectedComponent!.name.toLowerCase().replaceAll(' ', '')}.svg',
                                        color: getDamageColor(
                                            widget.selectedComponent!.damage),
                                        width: 60,
                                        height: 60,
                                      ),
                                      SizedBox(width: 20),
                                      Icon(
                                        Icons.double_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(width: 20),
                                      SvgPicture.asset(
                                        'images/icons/${widget.selectedComponent!.name.toLowerCase().replaceAll(' ', '')}.svg',
                                        color: getDamageColor(
                                            ComponentDamage.values[widget
                                                    .selectedComponent!
                                                    .damage
                                                    .level -
                                                1]),
                                        width: 60,
                                        height: 60,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Repair ${widget.selectedComponent!.name} by 1 level",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Cost of repair: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "\$${widget.repairCost.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(height: 50),

                            const SizedBox(height: 100),
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
                        if (widget.car.currVmax <= 1)
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
                            _buildStatColumn(
                                context,
                                '0-100 km/h (s)',
                                widget.car.currAccel,
                                widget.car.accel,
                                2,
                                true),
                            _buildStatColumn(
                                context,
                                '1/4 Mile (s)',
                                widget.car.currQmile,
                                widget.car.qmile,
                                1,
                                true),
                            _buildStatColumn(
                                context,
                                'Top Speed (km/h)',
                                widget.car.currVmax.toDouble(),
                                widget.car.vmax.toDouble(),
                                0,
                                false),
                            _buildStatColumn(
                                context,
                                'Slow Handling (G)',
                                widget.car.currHandling0,
                                widget.car.handling0,
                                2,
                                false),
                            _buildStatColumn(
                                context,
                                'Fast Handling (G)',
                                widget.car.currHandling1,
                                widget.car.handling1,
                                2,
                                false),
                            _buildStatColumn(
                                context,
                                '100-0 Braking (m)',
                                widget.car.currBraking,
                                widget.car.braking,
                                1,
                                true),
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
            currentCar: widget.car,
          ),
        ),
      ),
    ]);
  }
}
