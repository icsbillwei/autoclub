import 'package:autoclub_frontend/browser/used_dealer/used_dealer_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:autoclub_frontend/utilities/dealer_car_generation.dart';


enum UsedDealerPage {buy, sell}


class UsedDealerHomepage extends StatefulWidget {
  final List<CarModel> gameCarList;
  final List<Map<String, dynamic>> listings;
  const UsedDealerHomepage({super.key, required this.gameCarList, required this.listings});

  @override
  State<UsedDealerHomepage> createState() => _UsedDealerHomepageState();
}

class _UsedDealerHomepageState extends State<UsedDealerHomepage> {
  UsedDealerPage page = UsedDealerPage.buy;

  @override
  void initState() {
    super.initState();
    setState(() {});
    print("!! Used dealer initstate");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Column(
        children: [
          Row(
            // Website navbar
            children: [
              SvgPicture.asset("images/autosandauctions-long.svg", width: 200),
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
          ),

          const SizedBox(height: 30,),

          // Autos and Auctions content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.60,
              child: () {
              switch (page) {
                case UsedDealerPage.buy:
                  return GridView.extent(
                    maxCrossAxisExtent: 400,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    children: widget.listings.map((l) => UsedDealerListing(listing: l)).toList(),
                  );
                case UsedDealerPage.sell:
                  // TODO: Handle this case.
              }
            }())
        ],
      ),
    );
  }
}