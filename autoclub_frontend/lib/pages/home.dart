import 'dart:html';

import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:autoclub_frontend/main.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Location { undefined, downtown, home, hotel, showroom, tuning, wharf }
enum BrowserPages { home, motortrader }

class _MyHomePageState extends State<MyHomePage> {
  final viewTransformationController = TransformationController();

  /*
  Order matters:
  0 - downtown
  1 - home
  2 - hotel
  3 - showroom
  4 - tuning
  5 - wharf
   */
  Location location = Location.undefined;

  @override
  void initState() {
    // Zoom controller
    const zoomFactor = 0.7;
    const xTranslate = 450.0;
    const yTranslate = 200.0;
    viewTransformationController.value.setEntry(0, 0, zoomFactor);
    viewTransformationController.value.setEntry(1, 1, zoomFactor);
    viewTransformationController.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.setEntry(1, 3, -yTranslate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SizedBox(
          child: GestureDetector(
            child: InteractiveViewer(
                // scaleFactor: 0.3,
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
              showDialog(context: context, builder:  (BuildContext context) {
                return browser();
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


  Widget browser() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String searchBar = "Choose a website from below";
    BrowserPages page = BrowserPages.home;

    return SimpleShadow(
      color: Colors.black,
      sigma: 10,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        surfaceTintColor: Theme.of(context).colorScheme.background,
        child: Container(
          width: width * 0.8,
          height: height * 0.8,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [

                // Navbar
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      SvgPicture.asset("images/Corone-logo.svg", width: 40),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            child: Text(
                              searchBar,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      SizedBox(
                        height: 50,
                        child: FittedBox(
                          child: IconButton(
                              onPressed: (){
                                setState(() {
                                  page = BrowserPages.home;
                                });
                              },
                              icon: Icon(
                                Icons.home, 
                                color: Theme.of(context).colorScheme.secondary,
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: FittedBox(
                          child: IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close_rounded, 
                                color: Theme.of(context).colorScheme.secondary,
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Container(
                  child: () {
                    switch (page) {

                      case BrowserPages.home:
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(height: 100,),
                              SvgPicture.asset("/images/corone.svg", width: 230,),
                              SizedBox(height: 130,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {

                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.onSecondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)
                                      )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(25),
                                      child: Column(
                                        children: [
                                          Image.asset("images/mt.png", width: 60,),
                                          SizedBox(height: 20,),
                                          Text("Motortrader", style: Theme.of(context).textTheme.displaySmall,)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );

                      case BrowserPages.motortrader:
                        return SizedBox();
                    }

                }())
              ],
            ),
          )
        ),
      ),
    );
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
                color: lightTheme.colorScheme.onPrimary,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Theme.of(context).colorScheme.secondary
                        ),
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
