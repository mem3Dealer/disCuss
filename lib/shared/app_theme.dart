import 'package:flutter/material.dart';

ThemeData get appThemeLight => ThemeData(
      snackBarTheme: SnackBarThemeData(
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xffFFCB77),
        contentTextStyle: TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w300),
        //  shape:ShapeBorder
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
      ),
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(),
      primaryColor: Color(0xffffb703),
      accentColor: Color(0xff227C9D),
      scaffoldBackgroundColor: Color(0xfffff1e6),
      // elevatedButtonTheme: ElevatedButtonTheme(d),
      // buttonTheme: ButtonThemeData(buttonColor: Colors.green),

      textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0XFF17C3B2), selectionColor: Color(0XFF17C3B2)),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xffffb703)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
              textStyle: MaterialStateProperty.resolveWith(
                  (states) => TextStyle(color: Colors.amber)),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Color(0xffffb703),
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xff227C9D)))),
      dividerColor: Colors.grey[300],
      inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[300],
          labelStyle: TextStyle(color: Colors.black),
          errorMaxLines: 3,
          errorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          // border: OutlineInputBorder(
          //   gapPadding: 0,
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(15),
          //   ),
          //   borderSide: BorderSide(color: Colors., width: 2),
          // ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          // labelStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Color(0XFF17C3B2), width: 1.5),
          )),
    );

ThemeData get appThemeDark => ThemeData(
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black,
        contentTextStyle: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w300),
        //  shape:ShapeBorder
      ),
      // appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
      primaryColor: Color(0xff7556c8),
      scaffoldBackgroundColor: Color(0XFF41436A),
      textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white), // - заголовки в шапке страницы
          headline2: TextStyle() // -
          ),
      // Color(0xFF6F88FC), -- ФИАЛКОВЫЙ
      dividerColor: Colors.grey[600],
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xff7556c8)),
      accentColor: Color(0xfffe9677),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                //  side: BorderSide(color: Colors.red)
              )),
              elevation: MaterialStateProperty.resolveWith((states) => 5),
              // textStyle: MaterialStateProperty.resolveWith(
              //     (states) => TextStyle(color: Colors.transparent)),
              foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0XFF41436A)),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xfffe9677)))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.resolveWith((state) => Color(0xfffe9677)),
        // textStyle: MaterialStateProperty.resolveWith(
        //     (states) => TextStyle(color: Color(0xfffe9677))))
      )),
      // buttonTheme: ButtonThemeData(buttonColor: Colors.yellow),

      textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xfffe9677), selectionColor: Color(0xfffe9677)),

      inputDecorationTheme: InputDecorationTheme(
        // fillColor: Colors.grey,
        filled: true,
        errorMaxLines: 3,
        errorBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(color: Color(0xfffe9677), width: 1.5)),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(20),
        //   ),
        //   borderSide: BorderSide(color: Color(0XFFF64668), width: 2),
        // ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(color: Color(0xfffe9677), width: 1),
        ),
      ),
    );
