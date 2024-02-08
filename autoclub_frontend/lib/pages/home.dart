import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:autoclub_frontend/main.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/models/location.dart';
import 'package:autoclub_frontend/utilities/sideNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../browser/browser_window.dart';
import '../models/car.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewTransformationController = TransformationController();

  // TODO: Add listener to update date time accordingly
  final time = const TimeOfDay(hour: 12, minute: 23);
  final int money = 712931;
  Location location = Location.undefined;

  // Is there a better way to set theme
  final theme = "light";

  /*
  ---------- Temp user data -------------
   */
  List<Car> carlist = [];
  Car? currentCar;


  @override
  void initState() {
    transformView(viewTransformationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(children: <Widget>[
      SizedBox(
          child: GestureDetector(
        child: InteractiveViewer(
            minScale: 0.7,
            maxScale: 0.7,
            interactionEndFrictionCoefficient: 0.02,
            constrained: false,
            transformationController: viewTransformationController,
            child: Stack(children: <Widget>[
              // Background image
              Image.asset("images/game-bg.png"),

              // Items on map
              mapItem(1600, 700, "images/downtown.svg", Location.downtown),
              mapItem(2150, 950, "images/home.svg", Location.home),
              mapItem(2000, 450, "images/hotel.svg", Location.hotel),
              mapItem(2350, 600, "images/showroom.svg", Location.showroom),
              mapItem(2760, 1200, "images/tuning.svg", Location.tuning),
              mapItem(950, 600, "images/wharf.svg", Location.wharf),
            ])),
      )),

      Align(
          alignment: Alignment.centerLeft,
          child: screenWidth > 700 && screenHeight > 600
              ? SideNav(time: time, location: location, money: money)
              : null),

      // Location Entry Prompt
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: locationEntrance())),

      // Browser
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: FloatingActionButton.extended(
            elevation: 5,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const BrowserWidget();
                  });
            },
            label: Text(
              "Browser",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            icon: const Icon(Icons.language_rounded),
          ),
        ),
      )
    ]);
  }

  Widget mapItem(double posX, double posY, String img, Location toggle) {
    bool thisToggled = location == toggle;
    return AnimatedPositioned(
        left: (thisToggled) ? posX - 15 : posX,
        top: (thisToggled) ? posY - 26 : posY,
        duration: const Duration(milliseconds: 450),
        curve: Curves.ease,
        child: GestureDetector(
            onTap: () {
              setState(() {
                location = toggle;
              });
            },
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                width: ((thisToggled) ? 280 : 250) +
                    ((toggle == Location.tuning) ? 30 : 0),
                height: (thisToggled) ? 280 : 250,
                curve: Curves.ease,
                child: SimpleShadow(
                    color: Colors.black,
                    sigma: 8,
                    child: SvgPicture.asset(
                      img,
                      fit: BoxFit.contain,
                    )))));
  }

  Widget locationEntrance() {
    double width = MediaQuery.of(context).size.width;
    final backgroundColour = theme == "dark"
        ? navTheme.primaryColorDark
        : navTheme.primaryColorLight;

    // final textColour = theme == "dark" ? Colors.white : Colors.black;

    Widget child = (location != Location.undefined)
        ? SimpleShadow(
            color: Colors.black,
            sigma: 8,
            child: Container(
              key: ValueKey<Location>(
                  location), // Unique key to trigger animation when toggle changes
              width: (width < 900) ? width * 0.6 : 900 * 0.6,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: backgroundColour,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          setState(() {
                            location = Location.undefined;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              homepageLocation[location.index],
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              homepageDescription[location.index],
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: blue),
                                  onPressed: () {
                                    // TODO: implement actions
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.login_rounded,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Enter",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox(key: ValueKey<int>(-1));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100), // Animation duration
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Fade transition
        return FadeTransition(opacity: animation, child: child);
      },
      child: child, // Child to display
    );
  }
}

void transformView(controller) {
  // Zoom controller
  const zoomFactor = 0.7;
  const xTranslate = 450.0;
  const yTranslate = 200.0;
  controller.value.setEntry(0, 0, zoomFactor);
  controller.value.setEntry(1, 1, zoomFactor);
  controller.value.setEntry(2, 2, zoomFactor);
  controller.value.setEntry(0, 3, -xTranslate);
  controller.value.setEntry(1, 3, -yTranslate);
}
