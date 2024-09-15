import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/models/location.dart';
import 'package:autoclub_frontend/components/side_nav.dart';
import 'package:autoclub_frontend/pages/login.dart';
import 'package:autoclub_frontend/utilities/job_generation.dart';
import 'package:autoclub_frontend/utilities/sheets.dart';
import 'package:autoclub_frontend/utilities/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/components/current_car.dart';
import 'package:autoclub_frontend/models/job.dart';
import 'package:autoclub_frontend/pages/location_job_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../browser/browser_window.dart';
import '../models/car.dart';
import '../utilities/dealer_car_generation.dart';
import 'garage/garage.dart';
import '../pages/at-auto/at_auto_homepage.dart';

class MyHomePage extends StatefulWidget {
  final UserData userData;
  final SupabaseClient supabase;
  final String userId;
  const MyHomePage(
      {super.key,
      required this.userData,
      required this.supabase,
      required this.userId});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final viewTransformationController = TransformationController();

  late UserData userData = widget.userData;
  SelectedLocation location = SelectedLocation.home;

  static const usedDealerCount =
      21; // adjust the number of used cars in the dealer
  static const int maxDays = 5; // maximum days available to play before refill
  static const int refillHours = 2; // hours to refill days

  // Is there a better way to set theme
  final theme = "light";

  List<CarModel> gameCarList = [];
  List<Map<String, dynamic>> usedListings = [];

  /*
  ---------- Temp user data -------------
   */

  /*
  Job data
  */
  Map<SelectedLocation, List<TempJob>> jobList = {
    SelectedLocation.downtown: [],
    SelectedLocation.hotel: [],
    SelectedLocation.showroom: [],
    SelectedLocation.tuning: [],
    SelectedLocation.wharf: [],
  };

  Future<void> updateUserData() async {
    try {
      await widget.supabase
          .from('profiles')
          .update(userData.toMap())
          .eq('id', widget.userId);
    } catch (e) {
      print('Failed to update user data: $e');
      return;
    }
    print('User data updated');
  }

  /*
    UserData layout:
    String username;
    TimeOfDay time;
    int currentDay;
    int money;
    Car? currentCar;
    List<Car> userCarList;
    int currUserCarId;
  */

  void _logout() async {
    await widget.supabase.auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void progressTime({int hour = 0, int minute = 0}) {
    setState(() {
      int totalMinutes = userData.time.minute + minute;
      int newHour = userData.time.hour + hour + totalMinutes ~/ 60;
      int newMinute = totalMinutes % 60;
      bool dayPassed = newHour >= 21;

      if (dayPassed) {
        progressDay();
      } else {
        newHour = newHour % 24; // Ensure the hour is within 0-23 range
        userData.time = TimeOfDay(hour: newHour, minute: newMinute);
      }
      updateUserData();
    });
  }

  void progressDay({bool extraPop = false}) {
    if (extraPop) {
      Navigator.of(context).pop();
    }

    setState(() {
      userData.currentDay += 1;
      userData.daysLeft -= 1;
      userData.time = const TimeOfDay(hour: 9, minute: 0);
      location = SelectedLocation.home; // Reset location to home
    });

    updateUserData();

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: Scaffold(
            backgroundColor: Colors.black,
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.bedtime_rounded,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Next Day...',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ]),
          ),
        );
      },
      transitionDuration: Duration(seconds: 1),
    ));

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(context).pop();
    });
  }

  void updateAllJobs() {
    jobList[SelectedLocation.downtown] = generateDowntownJobs();
    jobList[SelectedLocation.hotel] = generateHotelJobs();
    jobList[SelectedLocation.wharf] = generateWharfJobs();
  }

  /*
 This calls getCarList from sheets.dart, which returns a list of CarModels
  */
  void getGameCarList() async {
    gameCarList = await getCarList();
  }

  void updateMoney(int newMoney) {
    userData.money = newMoney;
    setState(() {});
    updateUserData();
  }

  void updateLocation(SelectedLocation newLocation) {
    location = newLocation;
    setState(() {});
  }

  void addUserCar(Car newCar, int price) {
    newCar.userCarID = userData.currUserCarId;
    userData.currUserCarId++;
    userData.userCarList.add(newCar);
    userData.money -= price;
    setState(() {});
    updateUserData();
    // print("User car added");
    // print("${userData.userCarList.length} cars in userCarList");
    // print("User car ID: ${newCar.userCarID}");
    // print(userData.userCarList[0].userCarID);
  }

  void updateCurrentCar(Car newCar) {
    userData.currentCar = newCar;
    setState(() {});
    // delay 0.5s
    Future.delayed(Duration(milliseconds: 500), () {
      updateUserData();
    });
  }

  void replaceUserCar(Car newCar) {
    int index = userData.userCarList
        .indexWhere((car) => car.userCarID == newCar.userCarID);
    if (index != -1) {
      setState(() {
        userData.userCarList[index] = newCar;
      });
      // print("Car replaced in gameCarList");
    } else {
      // print("Target car not found in gameCarList");
    }
    updateUserData();
  }

  void handleJobAcceptance(TempJob job) {
    if (!hasTimeLeft(job.getTravelTime(50))) {
      // Show a message or handle the case when there is no time left
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Not Enough Time'),
            content: Text(
              'You do not have enough time left in the day to take on this job. Please wait for your availble days to refill',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
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
      return;
    }

    setState(() {
      location = job.endLocation;
    });

    Navigator.of(context).pop();

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Job to ${job.endLocationName} in Progress',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(seconds: 1),
    ));

    int travelTimeInMinutes = job.getTravelTime(50);
    int hours = travelTimeInMinutes ~/ 60;
    int minutes = travelTimeInMinutes % 60;

    // refresh jobs
    updateAllJobs();

    userData.money += job.reward;
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });

    // TODO check day left
    progressTime(hour: hours, minute: minutes);
    updateUserData();
  }

  /*
    for handling location entries
  */
  void handleEnterPress() {
    switch (location) {
      case SelectedLocation.downtown:
        // Action for downtown
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LocationJobPage(
              name: 'Downtown',
              imagePath: 'images/locations/job-downtown.png',
              jobs: jobList[
                  SelectedLocation.downtown]!, // Pass the list of TempJob here
              userCar: userData.currentCar!,
              handleJobAcceptance: handleJobAcceptance,
            );
          },
        );
        // print('Downtown selected');
        break;
      case SelectedLocation.home:
        // Go into homepage with animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => GaragePage(
              userCarList: userData.userCarList,
              money: userData.money,
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
        // print('Home selected');
        break;
      case SelectedLocation.hotel:
        // Action for hotel
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LocationJobPage(
              name: 'Hotel',
              imagePath: 'images/locations/job-hotel.png',
              jobs: jobList[
                  SelectedLocation.hotel]!, // Pass the list of TempJob here
              userCar: userData.currentCar!,
              handleJobAcceptance: handleJobAcceptance,
            );
          },
        );
        // print('Hotel selected');
        break;
      case SelectedLocation.showroom:
        // Action for showroom
        // TODO: showroom page
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LocationJobPage(
              name: 'Auto Showroom',
              imagePath: 'images/locations/job-showroom.png',
              jobs: [], // Pass the list of TempJob here
              userCar: userData.currentCar!,
              handleJobAcceptance: handleJobAcceptance,
            );
          },
        );
        // print('Showroom selected');
        break;
      case SelectedLocation.tuning:
        // Action for tuning
        // Go into homepage with animation
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ATAutoPage(
              currentCar: userData.currentCar,
              money: userData.money,
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
        // print('Tuning selected');
        break;
      case SelectedLocation.wharf:
        // Action for wharf
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return LocationJobPage(
              name: 'The Wharf',
              imagePath: 'images/locations/job-wharf.png',
              jobs: jobList[
                  SelectedLocation.wharf]!, // Pass the list of TempJob here
              userCar: userData.currentCar!,
              handleJobAcceptance: handleJobAcceptance,
            );
          },
        );
        // print('Wharf selected');
        break;
      default:
      // Default action
      // print('No location selected');
    }
  }

  Future<void> recoverInGameDays() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRecoveryTimestamp = prefs.getString('lastRecoveryTimestamp');
    final currentTimestamp = DateTime.now().toIso8601String();

    if (lastRecoveryTimestamp != null) {
      final lastRecoveryDateTime = DateTime.parse(lastRecoveryTimestamp);
      final currentDateTime = DateTime.parse(currentTimestamp);
      final difference = currentDateTime.difference(lastRecoveryDateTime);

      if (difference.inHours >= refillHours && userData.daysLeft < maxDays) {
        print("##### Recovering days #####");
        setState(() {
          userData.daysLeft = maxDays; // Refill to 5
        });
        await prefs.setString('lastRecoveryTimestamp', currentTimestamp);
        updateUserData();
      } else if (userData.daysLeft == maxDays) {
        await prefs.setString('lastRecoveryTimestamp', currentTimestamp);
      }
    } else {
      // If no last recovery timestamp is found, initialize it
      await prefs.setString('lastRecoveryTimestamp', currentTimestamp);
    }
  }

  bool hasTimeLeft(int timeToPassInMinutes) {
    // Calculate the total minutes after adding the time to pass
    int totalMinutes =
        userData.time.hour * 60 + userData.time.minute + timeToPassInMinutes;

    // Calculate the new hour and minute
    int newHour = totalMinutes ~/ 60;
    int newMinute = totalMinutes % 60;

    // Check if the new time exceeds 21:00 (9 PM) or if there are no days left
    if (newHour >= 21 && userData.daysLeft <= 0) {
      return false;
    }

    return true;
  }

  Future<Duration> getTimeLeftForRefill() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRecoveryTimestamp = prefs.getString('lastRecoveryTimestamp');
    final currentTimestamp = DateTime.now();

    if (lastRecoveryTimestamp != null) {
      final lastRecoveryDateTime = DateTime.parse(lastRecoveryTimestamp);
      final difference = currentTimestamp.difference(lastRecoveryDateTime);

      if (difference.inHours < refillHours) {
        final timeLeft = Duration(hours: refillHours) - difference;
        return timeLeft;
      }
    }

    return Duration.zero;
  }

  @override
  void initState() {
    userData = widget.userData;
    transformView(viewTransformationController);
    super.initState();
    getGameCarList();
    updateAllJobs();
    recoverInGameDays();
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
              mapItem(1600, 700, "images/downtown.svg",
                  SelectedLocation.downtown, location),
              mapItem(2150, 950, "images/home.svg", SelectedLocation.home,
                  location),
              mapItem(2000, 450, "images/hotel.svg", SelectedLocation.hotel,
                  location),
              mapItem(2350, 600, "images/showroom.svg",
                  SelectedLocation.showroom, location),
              mapItem(2760, 1200, "images/tuning.svg", SelectedLocation.tuning,
                  location),
              mapItem(950, 600, "images/wharf.svg", SelectedLocation.wharf,
                  location),
            ])),
      )),

      Align(
          alignment: Alignment.centerLeft,
          child: screenWidth > 700 && screenHeight > 600
              ? SideNav(
                  username: userData.username,
                  time: userData.time,
                  location: location,
                  money: userData.money,
                  currentDay: userData.currentDay,
                  logout: _logout,
                  daysLeft: userData.daysLeft,
                  timeLeftForRefill: getTimeLeftForRefill(),
                )
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
            currentCar: userData.currentCar,
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
                          money: userData.money,
                        );
                      } else {
                        // print("!!!!");
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

  Widget mapItem(double posX, double posY, String img, SelectedLocation toggle,
      SelectedLocation current) {
    /*
    Map item widget
    */

    bool thisToggled = location == toggle;

    void showTravelDialog(BuildContext context) {
      if (toggle == current) {
        return;
      }

      final travelTime = getTravelTime(current, toggle);

      // Check if the user has a car
      if (userData.currentCar == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Icon(Icons.warning_rounded),
              actionsAlignment: MainAxisAlignment.end,
              title: Text('No Car Available'),
              content: Text(
                'You do not have a car selected in your garage. Please select or buy a car to travel.',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      // Check if there is enough time left to travel
      if (!hasTimeLeft(getTravelTimeInMinutes(current, toggle))) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Icon(Icons.warning_rounded),
              actionsAlignment: MainAxisAlignment.end,
              title: Text('Not Enough Time'),
              content: Text(
                'You do not have enough time left in the day to travel to this location. Please wait for your available time to refill.',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      // Check if the car has broken components
      bool hasBrokenComponents = userData.currentCar!.hasBrokenComponents();

      if (hasBrokenComponents) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              icon: Icon(Icons.build_rounded),
              actionsAlignment: MainAxisAlignment.end,
              title: Text('Car Needs Repair'),
              content: Text(
                'Your current car has broken components. Please repair it before traveling.',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (toggle == SelectedLocation.tuning)
                  TextButton(
                    child: Text(
                      'Flatbed to Tuning (\$500)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      if (userData.money >= 500) {
                        setState(() {
                          userData.money -= 500;
                          location = toggle;
                          // TODO check day left
                          progressTime(
                              hour: travelTime['hours']!,
                              minute: travelTime['minutes']!);
                        });
                        updateUserData();
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              icon: Icon(Icons.error_rounded),
                              actionsAlignment: MainAxisAlignment.end,
                              title: Text('Insufficient Funds'),
                              content: Text(
                                'You do not have enough money to flatbed the car.',
                                style: TextStyle(color: Colors.black),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
              ],
            );
          },
        );
        return;
      }

      // If no issues, proceed with travel confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(Icons.directions_rounded),
            actionsAlignment: MainAxisAlignment.end,
            title: Text('Travel Confirmation'),
            content: Text(
              'Driving from ${current.name} to ${toggle.name}\nIt will be ${getDistance(current, toggle)} km and will take ${travelTime['hours']} hours and ${travelTime['minutes']} minutes.',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirm',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onPressed: () {
                  // Travel to the location
                  setState(() {
                    location = toggle;
                    int totalMinutes =
                        userData.time.minute + travelTime['minutes']!;
                    int newHour = userData.time.hour +
                        travelTime['hours']! +
                        totalMinutes ~/ 60;
                    int newMinute = totalMinutes % 60;
                    if (newHour >= 21) {
                      progressDay(extraPop: true);
                    } else {
                      newHour =
                          newHour % 24; // Ensure the hour is within 0-23 range
                      userData.time =
                          TimeOfDay(hour: newHour, minute: newMinute);
                      Navigator.of(context).pop();
                    }
                    updateUserData();
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return AnimatedPositioned(
        left: (thisToggled) ? posX - 15 : posX,
        top: (thisToggled) ? posY - 26 : posY,
        duration: const Duration(milliseconds: 450),
        curve: Curves.ease,
        height: 620,
        child: GestureDetector(
            onTap: () {
              setState(() {
                showTravelDialog(context);
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    width: ((thisToggled) ? 280 : 250) +
                        ((toggle == SelectedLocation.tuning) ? 30 : 0),
                    height: (thisToggled) ? 480 : 450,
                    curve: Curves.ease,
                    child: SimpleShadow(
                        color: Colors.black,
                        sigma: 8,
                        child: SvgPicture.asset(
                          img,
                          fit: BoxFit.contain,
                          height: 400,
                        ))),
                if (toggle == current)
                  Positioned(
                    top: 0,
                    child: SimpleShadow(
                      sigma: 6,
                      child: Image.asset(
                        "images/icons/current-location.png",
                        height: 100,
                      ),
                    ),
                  ),
              ],
            )));
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
                child: Padding(
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
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
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
