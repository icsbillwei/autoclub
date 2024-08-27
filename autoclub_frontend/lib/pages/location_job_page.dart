import 'package:flutter/material.dart';
import 'package:autoclub_frontend/models/job.dart';
import 'package:simple_shadow/simple_shadow.dart';

class LocationJobPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final List<TempJob> jobs;

  LocationJobPage({
    required this.name,
    required this.imagePath,
    required this.jobs,
  });

  @override
  _LocationJobPageState createState() => _LocationJobPageState();
}

class _LocationJobPageState extends State<LocationJobPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor:
          Colors.transparent, // Ensuring dialog background is transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              20.0), // Rounded corners for the whole dialog
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            // Left half with image and overlaid title
            Container(
              width: screenWidth * 0.8 * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(30.0),
                child: SimpleShadow(
                  sigma: 10,
                  opacity: 1,
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Right half with black background and exit button
            Container(
              width: screenWidth * 0.8 * 0.7,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
