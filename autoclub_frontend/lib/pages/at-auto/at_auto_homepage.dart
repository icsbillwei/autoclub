import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/components/current_car.dart';
import 'package:autoclub_frontend/pages/at-auto/at_auto_repairs.dart';

class ATAutoPage extends StatelessWidget {
  final Car? currentCar;

  ATAutoPage({required this.currentCar});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(30),
              child: SimpleShadow(
                  sigma: 8,
                  child: Image.asset(
                    'images/at-auto/at-auto-white.png',
                    height: 40,
                    filterQuality: FilterQuality.high,
                  ))),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/at-auto/at-auto-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Repairs
                  EntryButton(
                    title: 'Service & Repairs',
                    imagePath: 'images/at-auto/service-entry.png',
                    onTap: () {
                      print(currentCar);
                      if (currentCar == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // No car selected dialog
                            return AlertDialog(
                              title: const Text('No Car Selected',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              content: const Text(
                                  'Please select a car from your garage before visiting us.',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black)),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ATAutoRepair(car: currentCar!),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(
                                seconds: 1), // Adjust the duration as needed
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 50),
                  // Upgrades
                  EntryButton(
                    title: 'Upgrades',
                    imagePath: 'images/at-auto/upgrades-entry.png',
                    onTap: () {
                      // Add onTap callback
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: CarDisplay(
            currentCar: currentCar,
          ),
        ),
      ),
    ]);
  }
}

class EntryButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap; // Add onTap callback

  const EntryButton({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap, // Add onTap callback
  }) : super(key: key);

  @override
  _EntryButtonState createState() => _EntryButtonState();
}

class _EntryButtonState extends State<EntryButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    double baseWidth = MediaQuery.of(context).size.height > 1000 ? 400 : 250;
    double baseHeight = MediaQuery.of(context).size.height > 1000 ? 650 : 450;
    double width = isHovered ? baseWidth * 1.05 : baseWidth;
    double height = isHovered ? baseHeight * 1.05 : baseHeight;

    return MouseRegion(
      onEnter: (event) => setState(() => isHovered = true),
      onExit: (event) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap, // Use the onTap callback from the widget
        child: SimpleShadow(
          sigma: 8,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
