import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/models/location.dart';
import 'package:autoclub_frontend/components/side_nav.dart';
import 'package:autoclub_frontend/utilities/sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/components/current_car.dart';

import '../browser/browser_window.dart';
import '../models/car.dart';
import '../utilities/dealer_car_generation.dart';
import 'garage/garage.dart';
import '../pages/at-auto/at_auto_homepage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final viewTransformationController = TransformationController();

  // TODO: Add listener to update date time accordingly
  final time = const TimeOfDay(hour: 12, minute: 23);
  int money = 100000;
  SelectedLocation location = SelectedLocation.undefined;

  final usedDealerCount = 15; // adjust the number of used cars in the dealer

  // Is there a better way to set theme
  final theme = "light";

  List<CarModel> gameCarList = [];
  List<Map<String, dynamic>> usedListings = [];

  /*
  ---------- Temp user data -------------
   */
  Car? currentCar;
  List<Car> userCarList = [];
  // Number to track the id of the user's car
  int currUserCarId = 0;

  /*
 This calls getCarList from sheets.dart, which returns a list of CarModels
  */
  void getGameCarList() async {
    gameCarList = await getCarList();
  }

  void updateMoney(int newMoney) {
    money = newMoney;
    setState(() {});
  }

  void addUserCar(Car newCar, int price) {
    newCar.userCarID = currUserCarId;
    currUserCarId++;
    userCarList.add(newCar);
    money -= price;
    setState(() {});
    print("User car added");
    print("${userCarList.length} cars in userCarList");
    print("User car ID: ${newCar.userCarID}");
    print(userCarList[0].userCarID);
  }

  void updateCurrentCar(Car newCar) {
    currentCar = newCar;
    setState(() {});
  }

  void replaceUserCar(Car newCar) {
    int index =
        userCarList.indexWhere((car) => car.userCarID == newCar.userCarID);
    if (index != -1) {
      setState(() {
        userCarList[index] = newCar;
      });
      print("Car replaced in gameCarList");
    } else {
      print("Target car not found in gameCarList");
    }
  }

  /*
    for handling location entries
  */
  void handleEnterPress() {
    switch (location) {
      case SelectedLocation.downtown:
        // Action for downtown
        print('Downtown selected');
        break;
      case SelectedLocation.home:
        // Go into homepage with animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => GaragePage(
              userCarList: userCarList,
              money: money,
              updateCurrentCar: updateCurrentCar,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration:
                const Duration(seconds: 1), // Adjust the duration as needed
          ),
        );
        print('Home selected');
        break;
      case SelectedLocation.hotel:
        // Action for hotel
        print('Hotel selected');
        break;
      case SelectedLocation.showroom:
        // Action for showroom
        print('Showroom selected');
        break;
      case SelectedLocation.tuning:
        // Action for tuning
        // Go into homepage with animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ATAutoPage(
              currentCar: currentCar,
              money: money,
              updateMoney: updateMoney,
              updateUserCar: replaceUserCar,
              updateCurrentCar: updateCurrentCar,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration:
                const Duration(seconds: 1), // Adjust the duration as needed
          ),
        );
        print('Tuning selected');
        break;
      case SelectedLocation.wharf:
        // Action for wharf
        print('Wharf selected');
        break;
      default:
        // Default action
        print('No location selected');
    }
  }

  @override
  void initState() {
    transformView(viewTransformationController);
    super.initState();
    getGameCarList();
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
              mapItem(
                  1600, 700, "images/downtown.svg", SelectedLocation.downtown),
              mapItem(2150, 950, "images/home.svg", SelectedLocation.home),
              mapItem(2000, 450, "images/hotel.svg", SelectedLocation.hotel),
              mapItem(
                  2350, 600, "images/showroom.svg", SelectedLocation.showroom),
              mapItem(2760, 1200, "images/tuning.svg", SelectedLocation.tuning),
              mapItem(950, 600, "images/wharf.svg", SelectedLocation.wharf),
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

      // add top right here
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: CarDisplay(
            currentCar: currentCar,
          ),
        ),
      ),

      // Browser
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            width: 180,
            height: 60,
            child: FloatingActionButton.extended(
              elevation: 5,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (usedListings != [] && gameCarList != []) {
                        usedListings = generateUsedCarListings(
                            usedDealerCount, gameCarList);
                        return BrowserWidget(
                          gameCarList: gameCarList,
                          usedListings: usedListings,
                          addUserCar: addUserCar,
                          money: money,
                        );
                      } else {
                        print("!!!!");
                        return const SizedBox();
                      }
                    });
              },
              label: Text(
                "Browser",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 20),
              ),
              icon: const Icon(
                Icons.language_rounded,
                size: 24,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget mapItem(
      double posX, double posY, String img, SelectedLocation toggle) {
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
                    ((toggle == SelectedLocation.tuning) ? 30 : 0),
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

    Widget child = (location != SelectedLocation.undefined)
        ? SimpleShadow(
            color: Colors.black,
            sigma: 8,
            child: Container(
              key: ValueKey<SelectedLocation>(
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
                            location = SelectedLocation.undefined;
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
                                    handleEnterPress();
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
  const zoomFactor = 1;
  const xTranslate = 450.0;
  const yTranslate = 200.0;
  controller.value.setEntry(0, 0, zoomFactor);
  controller.value.setEntry(1, 1, zoomFactor);
  controller.value.setEntry(2, 2, zoomFactor);
  controller.value.setEntry(0, 3, -xTranslate);
  controller.value.setEntry(1, 3, -yTranslate);
}
