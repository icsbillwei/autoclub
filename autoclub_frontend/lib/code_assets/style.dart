import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

const dark = Color.fromRGBO(62, 62, 62, 1);
const whiteTranslucent = Color.fromRGBO(255, 255, 255, 0.8);
const blue = Color.fromRGBO(0, 165, 217, 1);

ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(

    // Main menu => location description => title
    displayMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: dark
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      color: dark
    ),
    labelMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.white
    )

  ),
  fontFamily: GoogleFonts.sora().fontFamily
);