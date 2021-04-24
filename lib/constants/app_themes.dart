import 'package:flutter/material.dart';
import 'package:movies_clone/constants/constants.dart';

class AppThemes {
  static final ThemeData lightThemeData = ThemeData(
    primaryColor: Constants.lightPrimaryColor,
    accentColor: Color.fromARGB(250, 13, 8, 66),
    textTheme: _lightTextTheme,
  );

  static final _lightTextTheme = TextTheme(
    bodyText1: TextStyle(color: Color.fromARGB(250, 13, 8, 66)),
    headline1: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 30),
    headline2: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 25),
    headline3: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 22),
    headline4: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 18),
    headline5: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.1),
    headline6: TextStyle(
        color: Color.fromARGB(250, 13, 8, 66),
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: 1.1),
    bodyText2: TextStyle(color: Color.fromARGB(250, 13, 8, 66), fontSize: 16),
  );
}
