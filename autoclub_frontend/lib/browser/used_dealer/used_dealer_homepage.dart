import 'package:autoclub_frontend/browser/used_dealer/used_dealer_listing.dart';
import 'package:autoclub_frontend/browser/used_dealer/used_dealer_listing_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'package:autoclub_frontend/models/car.dart';
import 'package:autoclub_frontend/utilities/car_utilities.dart';
import 'package:autoclub_frontend/utilities/dealer_car_generation.dart';

enum UsedDealerPage { buy, sell, listing }

class UsedDealerHomepage extends StatefulWidget {
  final List<CarModel> gameCarList;
  final List<Map<String, dynamic>> listings;
  final Function(Car, int) addUserCar;
  final int money;
  const UsedDealerHomepage(
      {super.key,
      required this.gameCarList,
      required this.listings,
      required this.addUserCar,
      required this.money});

  @override
  State<UsedDealerHomepage> createState() => _UsedDealerHomepageState();
}

class _UsedDealerHomepageState extends State<UsedDealerHomepage> {
  UsedDealerPage page = UsedDealerPage.buy;
  Map<String, dynamic> targetListing = {"id": -1};

  void updateDealerPage(UsedDealerPage newPage, Map<String, dynamic> target) {
    setState(() {
      page = newPage;
      if (newPage == UsedDealerPage.listing) {
        // // print("#### ${target["salePrice"]}");
        targetListing = target;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    // print("!! Used dealer initstate");
  }

  @override
  Widget build(BuildContext context) {
    /*
    This is the Autos & Auctions SUBPAGE of the browser
    This includes the website navbar and conditionally displays the buy, sell and detailed listing pages

    passes through money, listings, addUserCar
     */

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Column(
        children: [
          Row(
            // Website navbar
            children: [
              SvgPicture.asset("images/autosandauctions-long.svg", width: 200),
              const SizedBox(
                width: 50,
              ),
              TextButton(
                  onPressed: () {
                    updateDealerPage(UsedDealerPage.buy, {});
                  },
                  child: Text(
                    "Buy Cars",
                    style: Theme.of(context).primaryTextTheme.headlineMedium,
                  )),
              TextButton(
                  onPressed: () {
                    // todo: sell cars
                  },
                  child: Text(
                    "Sell Cars",
                    style: Theme.of(context).primaryTextTheme.headlineMedium,
                  ))
            ],
          ),

          const SizedBox(
            height: 30,
          ),

          // Autos and Auctions content
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: () {
                switch (page) {
                  case UsedDealerPage.buy:
                    return GridView.extent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 20,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 0),
                      children: widget.listings
                          .map((l) => UsedDealerListingEntry(
                                listing: l,
                                updateDealerPage: updateDealerPage,
                              ))
                          .toList(),
                    );
                  case UsedDealerPage.sell:
                  // TODO: Handle this case.
                  case UsedDealerPage.listing:
                    return UsedDealerListing(
                      listing: targetListing,
                      updateDealerPage: updateDealerPage,
                      addUserCar: widget.addUserCar,
                      money: widget.money,
                    );
                }
              }())
        ],
      ),
    );
  }
}
