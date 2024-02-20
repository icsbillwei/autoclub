import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


const dark = Color.fromRGBO(62, 62, 62, 1);
const whiteTranslucent = Color.fromRGBO(255, 255, 255, 0.9);
const blue = Color.fromRGBO(0, 165, 217, 1);
const bgWhite = Color.fromRGBO(248, 248, 248, 1);
const darkWhite = Color.fromRGBO(225, 225, 225, 1);

ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: blue, // white
        onPrimary: whiteTranslucent,
        secondary: dark,
        onSecondary: darkWhite,
        error: Colors.red,
        onError: Colors.red,
        background: bgWhite,
        onBackground: bgWhite,
        surface: bgWhite,
        onSurface: bgWhite),

    /*
    Main textTheme
     */
    textTheme: const TextTheme(

        // Main menu => location description => title
        displayMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.black
        ),

        // "of daytime left"
        displaySmall: TextStyle(
            fontSize: 14,
            color: Colors.black
        ),

        // "xx hours"
        headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black
        ),

        labelMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white
        ),

        labelSmall: TextStyle(), // I forgot what is this for

        // Navbar => time
        headlineMedium: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 32,
            color: Colors.black,
        )
    ),


    /*
    Motortrader text theme
     */
    primaryTextTheme: TextTheme(
      
      // Autos and auctions navbar texts
      headlineMedium:  TextStyle(
        fontSize: 18,
        color: dark,
        fontFamily: GoogleFonts.getFont("Rubik").fontFamily
      ),

      // autos and auctions listing title
      displayLarge: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.getFont("Rubik").fontFamily
      ),

      // listing description
      displayMedium: TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.getFont("Rubik").fontFamily
      ),

      // listing price
      displaySmall: TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.getFont("Rubik").fontFamily
      )
    ),
    
    
    fontFamily: GoogleFonts.getFont("Sora").fontFamily
);

ThemeData navTheme = ThemeData(
  primaryColorLight: const Color.fromRGBO(245, 245, 245, 0.8),
  primaryColorDark: const Color.fromRGBO(30, 30, 30, 0.7),
);

final currencyFormat = NumberFormat("#,##0.00", "en_US");