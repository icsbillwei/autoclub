import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'browser_window.dart';

class BrowserHomepage extends StatelessWidget {

  final Function(BrowserPages) updateBrowserPage;

  const BrowserHomepage(
    {super.key, required this.updateBrowserPage}
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SizedBox(height: 80,),
          SvgPicture.asset("/images/corone.svg", width: 200,),
          const SizedBox(height: 80,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Motortrader
              ElevatedButton(
                onPressed: () {
                  updateBrowserPage(BrowserPages.motortrader);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                  child: Column(
                    children: [
                      Image.asset("images/mt.png", width: 60,),
                      const SizedBox(height: 20,),
                      Text("Motortrader", style: Theme.of(context).textTheme.displaySmall,)
                    ],
                  ),
                ),
              ),

              SizedBox(width: 20,),

              // MotorPedia
              ElevatedButton(
                onPressed: () {
                  updateBrowserPage(BrowserPages.motorpedia);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
                  child: Column(
                    children: [
                      Image.asset("images/mp.png", width: 60,),
                      const SizedBox(height: 20,),
                      Text("Motorpedia", style: Theme.of(context).textTheme.displaySmall,)
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}