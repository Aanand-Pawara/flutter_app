import 'package:flutter/material.dart';

class AppTheme {
  // ----------------- Colors -----------------
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);

  static const Color lightBackground = Colors.white;
  static const Color lightText = Colors.black87;

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Colors.white70;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 202, 35, 231),
      Color.fromARGB(255, 255, 0, 140),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const String Slogan = "Dream. Discover. Decide.";
  // ----------------- Layout -----------------
  static const double radius = 12;
  static const EdgeInsets padding = EdgeInsets.all(16);
  static const List<BoxShadow> shadow = [
    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
  ];

  // ----------------- Font Styles -----------------
  static const String mainFont = "Outfit";

  static TextStyle heading({
    Color? color,
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.bold,
  }) => TextStyle(
    fontFamily: mainFont,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? lightText,
  );

  static TextStyle body({
    Color? color,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) => TextStyle(
    fontFamily: mainFont,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? lightText,
  );

  // ----------------- ThemeData -----------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBackground,
    textTheme: TextTheme(
      displayLarge: heading(color: lightText),
      bodyLarge: body(color: lightText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: darkBackground,
    textTheme: TextTheme(
      displayLarge: heading(color: darkText),
      bodyLarge: body(color: darkText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    ),
  );
}
