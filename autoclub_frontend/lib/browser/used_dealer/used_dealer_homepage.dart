import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';


class UsedDealerHomepage extends StatefulWidget {
  final gameCarList;
  const UsedDealerHomepage({super.key, required this.gameCarList});

  @override
  State<UsedDealerHomepage> createState() => _UsedDealerHomepageState();
}

class _UsedDealerHomepageState extends State<UsedDealerHomepage> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Row(
              // Website navbar
              children: [
                Image.asset("images/mt.png", width: 40,),
                SizedBox(width: 20,),
                SvgPicture.asset("images/mt-long.svg", width: 180),
                SizedBox(width: 50,),
                TextButton(
                  onPressed: () {
                    // todo: buy cars
                  },
                  child: Text(
                    "Buy Cars",
                    style: Theme.of(context).primaryTextTheme.headlineMedium,
                  )
                ),

                TextButton(
                    onPressed: () {
                      // todo: sell cars
                    },
                    child: Text(
                      "Sell Cars",
                      style: Theme.of(context).primaryTextTheme.headlineMedium,
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}