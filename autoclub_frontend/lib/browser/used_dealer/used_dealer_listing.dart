import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/car.dart';
import 'package:intl/intl.dart';


class UsedDealerListing extends StatelessWidget {
  final Map<String, dynamic> listing;

  const UsedDealerListing({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define a fixed height for the image or use MediaQuery to make it responsive
    double imageHeight = 180; // Example fixed height

    return Column(
      mainAxisSize: MainAxisSize.min, // Make the column take up only needed space
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: imageHeight, // Apply fixed height to control image size
          child: Stack(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(listing["thumbnailLink"], fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: dark,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                       "\$ ${NumberFormat("#,##0", "en_US").format(listing["salePrice"])}",
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
        const SizedBox(height: 15,),
        Text(
            listing["carObject"].fullName(),
          style: Theme.of(context).primaryTextTheme.displayLarge,
        ),
        const SizedBox(height: 8,),
        Text(
          listing["titleDescription"],
          style: Theme.of(context).primaryTextTheme.displayMedium,
        ),
        Text(
          "${NumberFormat("#,##0", "en_US").format(listing["carObject"].mileage)} km",
          style: Theme.of(context).primaryTextTheme.displayMedium,
        )
      ],
    );
  }
}
