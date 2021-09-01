import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  const secundaryColor = Color.fromRGBO(0, 77, 64, 1);
  const secundaryColorDart = Color.fromRGBO(0, 37, 26, 1);
  final disabledColor = Colors.grey[400];
  final dividerColor = Colors.grey;

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: secundaryColor,
    secondaryHeaderColor: secundaryColorDart,
    accentColor: primaryColor,
    backgroundColor: Colors.white,
    disabledColor: disabledColor,
    dividerColor: dividerColor,
    //scaffoldBackgroundColor: primaryColorDark, // -> works
    cardColor: primaryColorDark,

    textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.bold, color: primaryColorDark),
    ),
    inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: primaryColor),
        focusColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColorLight)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        alignLabelWithHint: true),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.purple,
    ),
  );
}
