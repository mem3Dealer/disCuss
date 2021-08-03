import 'package:flutter/material.dart';

// final appThemeData = ThemeData(primaryColor: Colors.red);
// final appThemeDataDark = ThemeData.dark();
// final appThemeDataLight = ThemeData.light(
// primaryColor:
// );
class MyTheme {
  ThemeData get darkTheme {
    return ThemeData(
        primaryColor:
            // Color(0x8A000000),
            Color(0xff009394),
        scaffoldBackgroundColor: Colors.grey.shade800,
        //  Color(0xff006270),
        fontFamily: 'Montserrat',
        textTheme: ThemeData.dark().textTheme,
        buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            buttonColor: Colors.red));
  }
}

ThemeData get appThemeLight => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(),
    primaryColor: Colors.pink[900],
    // elevatedButtonTheme: ElevatedButtonTheme(d),
    buttonTheme: ButtonThemeData(buttonColor: Colors.red),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith(
                (states) => TextStyle(color: Colors.amber)),
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.red),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.amber))));

ThemeData get appThemeDark => ThemeData(
    brightness: Brightness.dark,
    //
    primaryColor: Colors.teal[900],
    colorScheme: ColorScheme.dark(),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith(
                (states) => TextStyle(color: Colors.amber)),
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.amber),
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.teal[900]))),
    buttonTheme: ButtonThemeData(buttonColor: Colors.teal[800]));
