import 'dart:io';

import 'package:flutter/material.dart';

// final appThemeData = ThemeData(primaryColor: Colors.red);
// final appThemeDataDark = ThemeData.dark();
// final appThemeDataLight = ThemeData.light(
// primaryColor:
// );
// class MyTheme {
//   ThemeData get darkTheme {
//     return ThemeData(
//         primaryColor:
//             // Color(0x8A000000),
//             Color(0xff009394),
//         scaffoldBackgroundColor: Colors.grey.shade800,
//         //  Color(0xff006270),
//         fontFamily: 'Montserrat',
//         textTheme: ThemeData.dark().textTheme,
//         buttonTheme: ButtonThemeData(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0)),
//             buttonColor: Colors.red));
//   }
// }

ThemeData get appThemeLight => ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(),
      primaryColor: Color(0xffFFCB77),
      accentColor: Color(0xff227C9D),
      scaffoldBackgroundColor: Color(0xffFEF9EF),
      // elevatedButtonTheme: ElevatedButtonTheme(d),
      buttonTheme: ButtonThemeData(buttonColor: Colors.green),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0XFFFFCB77)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(color: Colors.amber)),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xff227C9D)),
              foregroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.amber))),
      dividerColor: Colors.grey[300],
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Color(0XFF17C3B2), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Color(0XFF17C3B2), width: 1.5),
          ),
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(color: Color(0xffC5C986), width: 1.5),
          )),
    );

ThemeData get appThemeDark => ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
      primaryColor: Color(0XFF984063),
      scaffoldBackgroundColor: Color(0XFF41436A),
      textTheme: TextTheme(
          headline1: TextStyle(), // - заголовки в шапке страницы
          headline2: TextStyle() // -
          ),
      // Color(0xFF6F88FC), -- ФИАЛКОВЫЙ
      dividerColor: Colors.grey[600],
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0XFFF64668)),
      accentColor: Color(0xfffe9677),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 5),
              // textStyle: MaterialStateProperty.resolveWith(
              //     (states) => TextStyle(color: Colors.transparent)),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0XFF41436A)),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xfffe9677)))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (state) => Color(0xfffe9677)),
              textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(color: Color(0xfffe9677))))),
      buttonTheme: ButtonThemeData(buttonColor: Colors.yellow),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(color: Color(0XFFF64668), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide(color: Color(0xfffe9677), width: 2),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.purple.shade800, width: 2),
        // )
      ),
    );
