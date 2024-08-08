import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/components/current_car.dart';

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
              icon: Icon(Icons.close, size: 30, color: Colors.white),
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
          decoration: BoxDecoration(
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
                  EntryButton(
                    title: 'Service & Repairs',
                    imagePath: 'images/at-auto/service-entry.png',
                  ),
                  SizedBox(width: 50),
                  EntryButton(
                    title: 'Upgrades',
                    imagePath: 'images/at-auto/upgrades-entry.png',
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

  const EntryButton({Key? key, required this.title, required this.imagePath})
      : super(key: key);

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
        onTap: () {
          // Define your onTap action here
        },
        child: SimpleShadow(
          sigma: 8,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
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
              child: SimpleShadow(
                sigma: 4,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
