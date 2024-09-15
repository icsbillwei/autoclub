import 'dart:math';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:autoclub_frontend/models/location.dart';
import 'package:autoclub_frontend/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SideNav extends StatelessWidget {
  final TimeOfDay time;
  final SelectedLocation location;
  final int money;
  final Weather weather;
  final int currentDay;
  final String username;
  final VoidCallback logout;
  final int daysLeft;
  final Future<Duration> timeLeftForRefill;

  // colors
  final theme = "light"; // light or dark

  const SideNav({
    super.key,
    required this.time,
    required this.location,
    required this.money,
    this.weather = Weather.sunny,
    required this.currentDay,
    required this.username,
    required this.logout,
    required this.daysLeft,
    required this.timeLeftForRefill,
  });

  String daytimeLeft() {
    final endOfDay = TimeOfDay(hour: 21, minute: 0);
    final nowInMinutes = time.hour * 60 + time.minute;
    final endOfDayInMinutes = endOfDay.hour * 60 + endOfDay.minute;
    final remainingMinutes = endOfDayInMinutes - nowInMinutes;

    if (remainingMinutes <= 0) {
      return "00:00";
    }

    final hoursLeft = remainingMinutes ~/ 60;
    final minutesLeft = remainingMinutes % 60;

    return "${hoursLeft.toString().padLeft(2, '0')}:${minutesLeft.toString().padLeft(2, '0')}";
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double widthFactor = 0.155;
    double heightFactor = 0.925;
    // predefined colour
    final backgroundColour = theme == "dark"
        ? navTheme.primaryColorDark
        : navTheme.primaryColorLight;

    final textColour = theme == "dark" ? Colors.white : Colors.black;

    return SimpleShadow(
      sigma: 8,
      child: Container(
        width: min(screenWidth * widthFactor, 180),
        height: screenHeight * heightFactor,
        margin: EdgeInsets.all(screenWidth * widthFactor / 6.2),
        padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: 15 + screenWidth * widthFactor / 15),
        // decoration (colour and border radius)
        decoration: BoxDecoration(
            color: backgroundColour,
            borderRadius: const BorderRadius.all(Radius.circular(30))),
        child: Column(
          children: [
            // SECTION: Weather Icon
            SvgPicture.asset(
              "images/weather/sunny.svg",
              width: min(screenWidth * widthFactor * 0.25,
                  screenHeight * heightFactor * 0.25),
            ),

            const SizedBox(
              height: 15,
            ),

            // SECTION: Time
            Tooltip(
              message: "A day begins at 9:00\nand ends at 21:00",
              child: Text(
                "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // // SECTION: Time left in the day
            // Text(daytimeLeft(),
            //     style: Theme.of(context).textTheme.headlineSmall),
            // Text("of daytime left",
            //     style: Theme.of(context).textTheme.displaySmall),

            // const SizedBox(height: 30),

            // SECTION: Number of days left
            Tooltip(
              message: "You can progress this many days before the next refill",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    child: LinearProgressIndicator(
                      value: daysLeft / 5,
                      minHeight: 10,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("$daysLeft/5",
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Text("Next refill in",
                style: Theme.of(context).textTheme.displaySmall),
            Tooltip(
              message:
                  "Your days left will refill in this amount of real life time",
              child: FutureBuilder<Duration>(
                future: timeLeftForRefill,
                builder: (context, snapshot) {
                  if (daysLeft == 5) {
                    return Text(
                      "--:--",
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final timeLeft = snapshot.data!;
                    return Text(
                      formatDuration(timeLeft),
                      style: Theme.of(context).textTheme.headlineSmall,
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            // SECTION: Current Day
            Text("Day $currentDay",
                style: Theme.of(context).textTheme.headlineSmall),
            Text("current day",
                style: Theme.of(context).textTheme.displaySmall),

            const SizedBox(height: 50),

            // SECTION: Current Location
            Icon(Icons.location_on, color: textColour),
            const SizedBox(height: 5),
            Text(location.name,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 13)),

            Text("current location",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 12)),

            // SECTION: Money
            const SizedBox(height: 45),
            Text("\$ ${currencyFormat.format(money)}",
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 18)),

            // SECTION: Profile Picture (Todo)

            // SECTION: Username (Todo)
            const SizedBox(height: 70),
            Text(username,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 16)),

            // SECTION: Settings and Log Out
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: blue),
                  onPressed: logout,
                  child: Icon(Icons.logout, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
