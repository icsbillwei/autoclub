import 'package:autoclub_frontend/components/current_money.dart';
import 'package:autoclub_frontend/components/stat_bar.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatRow extends StatelessWidget {
  final String label;
  final double currentStat;
  final double newStat;
  final double? improveStat;

  StatRow({
    required this.label,
    required this.currentStat,
    required this.newStat,
    this.improveStat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Expanded(
          child: StatBar(
            currentStat: currentStat,
            newStat: newStat,
            improveStat: improveStat,
          ),
        ),
        SizedBox(width: 20),
        SizedBox(
          width: 80,
          child: Text(
            '${currentStat.toStringAsFixed(1)}',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class ATAutoRepair extends StatefulWidget {
  Car car;
  Car? updatedCar;
  Component? selectedComponent;
  int repairCost = 0;
  int money;

  Function updateMoney;
  Function updateUserCar;
  Function updateCurrentCar;

  ATAutoRepair(
      {required this.car,
      required this.money,
      required this.updateMoney,
      required this.updateUserCar,
      required this.updateCurrentCar});

  @override
  _ATAutoRepairState createState() => _ATAutoRepairState();
}

class _ATAutoRepairState extends State<ATAutoRepair> {
  @override
  void initState() {
    super.initState();
  }

  void onSelectComponent(Component component) {
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
    Component clonedComponent = Component.clone(
        clonedCar.componentList.firstWhere((c) => c.name == component.name));

    if (clonedComponent.damage.level > 0) {
      clonedComponent.damage =
          ComponentDamage.values[clonedComponent.damage.level - 1];
    } else {
      print(
          'Component ${clonedComponent.name} is already at minimum damage level');
    }

    int originalIndex =
        clonedCar.componentList.indexWhere((c) => c.name == component.name);
    clonedCar.componentList.removeAt(originalIndex);
    clonedCar.componentList.insert(originalIndex, clonedComponent);

    clonedCar.updateUsedPerformance();
    return clonedCar;
  }

  void resetRepair() {
    widget.selectedComponent = null;
    widget.updatedCar = null;
    widget.repairCost = 0;
    setState(() {});
  }

  void onRepairComponent(int cost) {
    widget.updateMoney(widget.money - cost);
    widget.money -= cost;
    widget.updateUserCar(widget.updatedCar);
    widget.car = widget.updatedCar!;
    widget.selectedComponent = null;
    widget.updatedCar = null;
    widget.repairCost = 0;
    widget.updateCurrentCar(widget.car);
    setState(() {});
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
      double stat, int rounding, bool maxOverflow,
      {double? previewStat}) {
    String displayCurrStat;
    double statToDisplay = previewStat ?? currStat;

    if (maxOverflow && statToDisplay >= 98) {
      displayCurrStat = '--';
    } else if (!maxOverflow && statToDisplay == 0) {
      displayCurrStat = '--';
    } else {
      displayCurrStat = statToDisplay.toStringAsFixed(rounding);
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
                      color: (previewStat != null && previewStat != currStat)
                          ? Color.fromARGB(255, 83, 206, 144)
                          : Colors.white,
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
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
                                        onSelectComponent(component);
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
                              Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'images/icons/${widget.selectedComponent!.name.toLowerCase().replaceAll(' ', '')}.svg',
                                                color: getDamageColor(widget
                                                    .selectedComponent!.damage),
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
                                                    ComponentDamage
                                                        .values[widget
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(width: 50),
                                      // Repair Button

                                      Column(
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromARGB(
                                                          150, 255, 153, 0)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (widget.money >=
                                                  widget.repairCost) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Confirm Repair',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: const Text(
                                                        'Are you sure you want to perform this repair?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                              'Cancel'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: const Text(
                                                              'Confirm'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            onRepairComponent(
                                                                widget
                                                                    .repairCost);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Insufficient Funds',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      content: const Text(
                                                        'You do not have enough money to repair this component.',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.all(6),
                                                child: const Text(
                                                  'Repair',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ),
                                          const SizedBox(height: 10),
                                          // Cancel Button
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromARGB(
                                                          120, 97, 129, 145)),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              resetRepair();
                                            },
                                            child: Padding(
                                                padding: EdgeInsets.all(6),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ]),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Performance Index
                            const Icon(
                              Icons.bolt,
                              color: Colors.yellow,
                              size: 28,
                            ),
                            const Text(
                              "Perf. Index",
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 20),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${widget.updatedCar?.currPerformancePoint ?? widget.car.currPerformancePoint} ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: (widget.updatedCar != null &&
                                                  widget.updatedCar
                                                          ?.currPerformancePoint !=
                                                      widget.car
                                                          .currPerformancePoint)
                                              ? Color.fromARGB(
                                                  255, 83, 206, 144)
                                              : Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  TextSpan(
                                    text: " / ${widget.car.performancePoint}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: Colors.orange,
                                          fontSize: 18,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 50),

                        // Performance Bars
                        StatRow(
                          label: "Launch",
                          currentStat: widget.car.currLaunchStat,
                          newStat: widget.car.launchStat,
                          improveStat: widget.updatedCar?.currLaunchStat,
                        ),
                        SizedBox(height: 10),
                        StatRow(
                          label: "Acceleration",
                          currentStat: widget.car.currAccelStat,
                          newStat: widget.car.accelStat,
                          improveStat: widget.updatedCar?.currAccelStat,
                        ),
                        SizedBox(height: 10),
                        StatRow(
                          label: "Speed",
                          currentStat: widget.car.currSpeedStat,
                          newStat: widget.car.speedStat,
                          improveStat: widget.updatedCar?.currSpeedStat,
                        ),
                        SizedBox(height: 10),
                        StatRow(
                          label: "Handling",
                          currentStat: widget.car.currHandlingStat,
                          newStat: widget.car.handlingStat,
                          improveStat: widget.updatedCar?.currHandlingStat,
                        ),
                        SizedBox(height: 10),
                        StatRow(
                          label: "Braking",
                          currentStat: widget.car.currBrakingStat,
                          newStat: widget.car.brakingStat,
                          improveStat: widget.updatedCar?.currBrakingStat,
                        ),

                        // Warning
                        const SizedBox(height: 50),
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

                        // Stat grid
                        GridView.count(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          childAspectRatio: 2,
                          children: [
                            _buildStatColumn(context, '0-100 km/h (s)',
                                widget.car.currAccel, widget.car.accel, 2, true,
                                previewStat: widget.updatedCar?.currAccel),
                            _buildStatColumn(context, '1/4 Mile (s)',
                                widget.car.currQmile, widget.car.qmile, 1, true,
                                previewStat: widget.updatedCar?.currQmile),
                            _buildStatColumn(
                                context,
                                'Top Speed (km/h)',
                                widget.car.currVmax.toDouble(),
                                widget.car.vmax.toDouble(),
                                0,
                                false,
                                previewStat:
                                    (widget.updatedCar?.currVmax)?.toDouble()),
                            _buildStatColumn(
                                context,
                                'Slow Handling (G)',
                                widget.car.currHandling0,
                                widget.car.handling0,
                                2,
                                false,
                                previewStat: widget.updatedCar?.currHandling0),
                            _buildStatColumn(
                                context,
                                'Fast Handling (G)',
                                widget.car.currHandling1,
                                widget.car.handling1,
                                2,
                                false,
                                previewStat: widget.updatedCar?.currHandling1),
                            _buildStatColumn(
                                context,
                                '100-0 Braking (m)',
                                widget.car.currBraking,
                                widget.car.braking,
                                1,
                                true,
                                previewStat: widget.updatedCar?.currBraking),
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
          child: MoneyDisplay(money: widget.money),
        ),
      ),
    ]);
  }
}
