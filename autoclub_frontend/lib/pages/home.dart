import 'package:autoclub_frontend/main.dart';
import 'package:autoclub_frontend/style.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();


}

class _MyHomePageState extends State<MyHomePage> {
  final viewTransformationController = TransformationController();

  bool downtownToggle = false;

  @override
  void initState() {

    // Zoom controller
    final zoomFactor = 0.5;
    final xTranslate = 100.0;
    final yTranslate = 100.0;
    viewTransformationController.value.setEntry(0, 0, zoomFactor);
    viewTransformationController.value.setEntry(1, 1, zoomFactor);
    viewTransformationController.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.setEntry(1, 3, -yTranslate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        child: InteractiveViewer(
            // scaleFactor: 0.3,
            minScale: 0.5,
            maxScale: 0.5,
            interactionEndFrictionCoefficient: 0.02,
            constrained: false,
            transformationController: viewTransformationController,
            child: Stack(
                children: <Widget>[
                  Image.asset("images/game-bg.png"),
                  AnimatedPositioned(
                      left: (downtownToggle) ? 1600 - 15: 1600,
                      top: (downtownToggle) ? 700 - 26 : 700,
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.ease,
                      child: GestureDetector(
                          onTap: (){
                            setState(() {
                              downtownToggle = !downtownToggle;
                            });
                          },
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 450),
                              width: (downtownToggle) ? 280 : 250,
                              height: (downtownToggle) ? 280 : 250,
                              curve: Curves.ease,
                              child: Image.asset("images/downtown.png", fit: BoxFit.contain,)
                          )
                      )
                  )
                ]
            )
        ),
      )
    );
  }

 
}
