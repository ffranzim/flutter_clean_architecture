import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ! Deixa a statusBar com caracteres brancos
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    const primaryColor = Color.fromRGBO(136, 14, 79, 1);
    const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
    const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);

    return MaterialApp(
      title: 'Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        accentColor: primaryColor,
        backgroundColor: Colors.white,

        //scaffoldBackgroundColor: primaryColorDark, // -> works

        cardColor: primaryColorDark,

        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: primaryColorDark),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: primaryColor),
            focusColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColorLight)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)),
            alignLabelWithHint: true),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      ),
      home: const LoginPage(presenter: null,),
    );
  }
}
