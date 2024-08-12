import 'package:autoclub_frontend/browser/used_dealer/used_dealer_homepage.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/car.dart';

class UsedDealerListing extends StatefulWidget {
  final Map<String, dynamic> listing;
  Function(UsedDealerPage, Map<String, dynamic>) updateDealerPage;
  Function(Car, int) addUserCar;
  final int money;

  UsedDealerListing(
      {super.key,
      required this.listing,
      required this.updateDealerPage,
      required this.addUserCar,
      required this.money});

  @override
  State<UsedDealerListing> createState() => _UsedDealerListingState();
}

class _UsedDealerListingState extends State<UsedDealerListing> {
  /*
  Dialog for car purchase confirmation
  */
  void showPurchaseConfirmation(
      BuildContext context,
      Car car,
      int sellPrice,
      Function(UsedDealerPage, Map<String, dynamic>) updateDealerPage,
      int money) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Purchase Confirmation'),
          content: Text(
            'Are you sure you want to purchase this ${car.fullName()} for \$$sellPrice?',
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                updateDealerPage(UsedDealerPage.buy, {});
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                if (sellPrice < money) {
                  widget.addUserCar(car, sellPrice);
                  Navigator.of(context).pop(); // Dismiss the dialog
                  updateDealerPage(UsedDealerPage.buy, {});
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Insufficient funds'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Dismiss the error dialog
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
  }

  /*
  One block of detailed information within the detailed information section
  */
  Widget detailedInfoItem(String desc, dynamic info) {
    return Container(
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: dark)),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          Text(
            desc,
            style: Theme.of(context)
                .primaryTextTheme
                .displayMedium
                ?.copyWith(fontSize: 18),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            info.toString(),
            style: Theme.of(context)
                .primaryTextTheme
                .displayMedium
                ?.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("### ${widget.listing["salePrice"]}");
    final Map<String, dynamic> listing = widget.listing;
    String? gotUrl = listing["thumbnailLink"];
    String imageUrl = (gotUrl != null)
        ? gotUrl
        : "https://i.imgur.com/ak0gS4U.png"; // placeholder car thumbmail

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),

          // first row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  // Back to listings button
                  onPressed: () {
                    widget.updateDealerPage(UsedDealerPage.buy, {});
                  },
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  )),
              Text(
                "All listings",
                style: Theme.of(context).primaryTextTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing["carObject"].fullName(),
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displayLarge
                          ?.copyWith(fontSize: 28),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      listing["titleDescription"],
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displayMedium
                          ?.copyWith(fontSize: 16),
                    ),
                    Text(
                      "${NumberFormat("#,##0", "en_US").format(listing["carObject"].mileage)} km",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displayMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "\$ ${NumberFormat("#,##0", "en_US").format(listing["salePrice"])}",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displayLarge
                          ?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          showPurchaseConfirmation(
                              context,
                              listing["carObject"],
                              listing["salePrice"],
                              widget.updateDealerPage,
                              widget.money);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Colors.green, // This is the background color
                          backgroundColor: Colors
                              .white, // This is the foreground color (text color)
                          // You can add more properties to style it further
                        ),
                        child: const Text("Buy")),
                    const SizedBox(
                      height: 30,
                    ),

                    // Description
                    Text(
                      placeholderDescription,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .displayMedium
                          ?.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(
            height: 80,
          ),

          Text(
            "Tags",
            style: Theme.of(context).primaryTextTheme.displayLarge,
          ),

          const SizedBox(
            height: 20,
          ),

          // add here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Wrap(
              spacing: 10, // Horizontal spacing between items
              runSpacing: 10, // Vertical spacing between lines
              children: List.generate(
                listing["carObject"].tags.length,
                (index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: const Color.fromARGB(255, 74, 165, 112),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        listing["carObject"].tags[index].name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(
            height: 80,
          ),

          Text(
            "Detailed Information",
            style: Theme.of(context).primaryTextTheme.displayLarge,
          ),

          const SizedBox(
            height: 40,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: GridView.extent(
                maxCrossAxisExtent: 600,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 10 / 1,
                children: [
                  detailedInfoItem("Make:", listing["carObject"].brandName),
                  detailedInfoItem("Name:", listing["carObject"].name),
                  detailedInfoItem("Year:", listing["carObject"].year),
                  detailedInfoItem("Mileage:", listing["carObject"].mileage),
                  detailedInfoItem(
                      "Country:", listing["carObject"].country.name),
                  detailedInfoItem(
                      "Vehicle Type:", listing["carObject"].type.name),
                  detailedInfoItem(
                      "Engine Type:", listing["carObject"].engineType.fullName),
                  detailedInfoItem("Displacement:",
                      "${listing["carObject"].displacement.toStringAsFixed(1)} L"),
                  detailedInfoItem("Engine Aspiration:",
                      listing["carObject"].aspirationType.name),
                  detailedInfoItem("Drivetrain Type:",
                      listing["carObject"].drivetrainType.name),
                  detailedInfoItem(
                      "Cargo Space:", listing["carObject"].space.name),
                  detailedInfoItem(
                      "Number of Seats:", listing["carObject"].seatCount),
                  detailedInfoItem(
                      "Power (new):", "${listing["carObject"].power} hp"),
                  detailedInfoItem(
                      "Weight:", "${listing["carObject"].weight} kg"),
                  detailedInfoItem("Designer:", listing["carObject"].designer),
                  // temp info
                  detailedInfoItem(
                      "Acceleration (new):", "${listing["carObject"].accel} s"),
                  detailedInfoItem(
                      "Quarter Mile (new):", "${listing["carObject"].qmile} s"),
                  detailedInfoItem(
                      "Top Speed (new):", "${listing["carObject"].vmax} km/h"),
                  detailedInfoItem("Low Speed Handling (new):",
                      "${listing["carObject"].handling0} G"),
                  detailedInfoItem("High Speed Handling (new):",
                      "${listing["carObject"].handling1} G"),
                  detailedInfoItem(
                      "Braking (new):", "${listing["carObject"].braking} m"),

                  // temp info
                  detailedInfoItem("Current Acceleration:",
                      "${listing["carObject"].currAccel} s"),
                  detailedInfoItem("Current Quarter Mile:",
                      "${listing["carObject"].currQmile} s"),
                  detailedInfoItem("Current Top Speed:",
                      "${listing["carObject"].currVmax} km/h"),
                  detailedInfoItem("Current Handling 0:",
                      "${listing["carObject"].currHandling0}"),
                  detailedInfoItem("Current Handling 1:",
                      "${listing["carObject"].currHandling1}"),
                  detailedInfoItem("Current Braking:",
                      "${listing["carObject"].currBraking}"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
