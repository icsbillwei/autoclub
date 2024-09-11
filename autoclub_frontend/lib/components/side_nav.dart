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
            Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(
              height: 15,
            ),

            // SECTION: Time left in the day
            Text(daytimeLeft(),
                style: Theme.of(context).textTheme.headlineSmall),
            Text("of daytime left",
                style: Theme.of(context).textTheme.displaySmall),

            const SizedBox(height: 15),

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
            const SizedBox(height: 100),
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
