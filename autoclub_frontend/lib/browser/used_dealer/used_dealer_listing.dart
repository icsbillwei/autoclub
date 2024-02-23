import 'package:autoclub_frontend/browser/used_dealer/used_dealer_homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class UsedDealerListing extends StatefulWidget {
  final Map<String, dynamic> listing;
  Function(UsedDealerPage, Map<String, dynamic>) updateDealerPage;

  UsedDealerListing({super.key, required this.listing, required this.updateDealerPage});

  @override
  State<UsedDealerListing> createState() => _UsedDealerListingState();
}


class _UsedDealerListingState extends State<UsedDealerListing> {

  @override
  Widget build(BuildContext context) {
    String? gotUrl = widget.listing["thumbnailLink"];
    String imageUrl = (gotUrl != null) ? gotUrl : "https://i.imgur.com/ak0gS4U.png";

    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.4,),
            ),
            const SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listing["carObject"].fullName(),
                  style: Theme.of(context).primaryTextTheme.displayLarge,
                ),
                const SizedBox(height: 8,),
                Text(
                  widget.listing["titleDescription"],
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                ),
                Text(
                  "${NumberFormat("#,##0", "en_US").format(widget.listing["carObject"].mileage)} km",
                  style: Theme.of(context).primaryTextTheme.displayMedium,
                )
              ],
            )
          ],
        )

      ],
    );
  }

}