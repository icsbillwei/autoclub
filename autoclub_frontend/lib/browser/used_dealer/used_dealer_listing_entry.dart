import 'package:autoclub_frontend/browser/used_dealer/used_dealer_homepage.dart';
import 'package:autoclub_frontend/browser/used_dealer/used_dealer_listing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsedDealerListingEntry extends StatelessWidget {
  final Map<String, dynamic> listing;
  final Function(UsedDealerPage, Map<String, dynamic>) updateDealerPage;

  const UsedDealerListingEntry(
      {Key? key, required this.listing, required this.updateDealerPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a fixed height for the image or use MediaQuery to make it responsive
    double imageHeight = 180; // Example fixed height

    return GestureDetector(
      onTap: () {
        updateDealerPage(UsedDealerPage.listing, listing);
      },
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Make the column take up only needed space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: imageHeight, // Apply fixed height to control image size
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  listing["thumbnailLink"],
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "\$ ${NumberFormat("#,##0", "en_US").format(listing["salePrice"])}",
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            listing["carObject"].fullName(),
            style: Theme.of(context).primaryTextTheme.displayLarge,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            listing["titleDescription"],
            style: Theme.of(context).primaryTextTheme.displayMedium,
          ),
          Text(
            "${NumberFormat("#,##0", "en_US").format(listing["carObject"].mileage)} km",
            style: Theme.of(context).primaryTextTheme.displayMedium,
          )
        ],
      ),
    );
  }
}
