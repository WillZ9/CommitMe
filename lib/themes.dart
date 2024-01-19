import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class pickColor {
  static const Color navyBlue = Color(0xFF001f3f);
  static const Color oceanBlue = Color(0xFF69a3b2);
  static const Color lightBlue = Color(0xFF98c1d9);
  static const Color cloudWhite = Color(0xFFf0f3f5);
  static const Color slateGray = Color(0xFF2e3b4e);
  static const Color steelGray = Color(0xFF6a737d);
  static const Color forestGreen = Color(0xFF4caf50);
  static const Color sunsetRed = Color(0xFFd32f2f);
  static const Color goldenYellow = Color(0xFFffa000);
  static const Color darkGray = Color(0xFF333366);
  static const Color niceBlue = Color.fromARGB(255, 58, 62, 183);
}

class Themes {
  static final light = ThemeData(
      primaryColor: pickColor.oceanBlue, brightness: Brightness.light);

  static final dark = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 0, 0, 102),
      onPrimary: pickColor.niceBlue,
      secondary: pickColor.cloudWhite,
      onSecondary: pickColor.cloudWhite,
      error: pickColor.sunsetRed,
      onError: pickColor.sunsetRed,
      background: Color.fromARGB(255, 0, 0, 51),
      onBackground: pickColor.niceBlue,
      surface: Color.fromARGB(255, 0, 0, 102),
      onSurface: pickColor.cloudWhite,
    ),
  );
}

TextStyle get frontPageStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 50,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.bold,
  ));
}

TextStyle get normalTextStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ));
}
