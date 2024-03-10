import 'package:autoclub_frontend/browser/browser_homepage.dart';
import 'package:autoclub_frontend/browser/used_dealer/used_dealer_homepage.dart';
import 'package:autoclub_frontend/code_assets/texts.dart';
import 'package:autoclub_frontend/main.dart';
import 'package:autoclub_frontend/code_assets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../models/car.dart';

enum BrowserPages { home, autosandauctions, motorpedia }

class BrowserWidget extends StatefulWidget {
  final List<CarModel> gameCarList;
  final List<Map<String, dynamic>> usedListings;
  final Function(Car, int) addUserCar;
  final int money;

  const BrowserWidget({Key? key, required this.gameCarList, required this.usedListings, required this.addUserCar, required this.money}) : super(key: key);

  @override
  _BrowserWidgetState createState() => _BrowserWidgetState();
}

class _BrowserWidgetState extends State<BrowserWidget> {
  BrowserPages page = BrowserPages.home;


  void updateBrowserPage(BrowserPages newPage) {
    setState(() {
      page = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String searchBar = switch (page) {
      BrowserPages.home => "Choose a website from below",
      BrowserPages.motorpedia => "motorpedia.org",
      BrowserPages.autosandauctions => "autosandauctions.com"
    };


    return SimpleShadow(
      color: Colors.black,
      sigma: 10,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        surfaceTintColor: Theme.of(context).colorScheme.background,
        child: Container(
            width: width * 0.8,
            height: height * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Column(
                children: [
                  // Navbar
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        SvgPicture.asset("images/Corone-logo.svg", width: 40),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: Text(
                                searchBar,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 40,
                          child: FittedBox(
                            child: IconButton(
                                onPressed: () {
                                  updateBrowserPage(BrowserPages.home);
                                },
                                icon: Icon(
                                  Icons.home,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: FittedBox(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Container(child: () {
                    switch (page) {
                      case BrowserPages.home:
                        return BrowserHomepage(
                          updateBrowserPage: updateBrowserPage,
                        );

                      case BrowserPages.autosandauctions:
                        return UsedDealerHomepage(gameCarList: widget.gameCarList, listings: widget.usedListings, addUserCar: widget.addUserCar, money: widget.money,);

                      case BrowserPages.motorpedia:
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Site not found",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: GoogleFonts.cutiveMono().fontFamily,
                                fontSize: 30),
                          ),
                        );
                    }
                  }())
                ],
              ),
            )),
      ),
    );
  }
}
