import 'package:flutter/material.dart';
import 'package:uni_talk/models/custom_theme.dart';

final CustomTheme lightThemeData = CustomTheme(
  themeData: ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF697EC0),
    secondaryHeaderColor: const Color(0xFF829FCE),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
      ).titleLarge,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF3B5998),
      unselectedItemColor: Color(0xFF9BC0DC),
      showUnselectedLabels: true,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF697EC0)),
      displayMedium: TextStyle(color: Color(0xFF829FCE)),
      displaySmall: TextStyle(color: Color(0xFF9BC0DC)),
      headlineMedium: TextStyle(color: Color(0xFFB4E1EA)),
      headlineSmall: TextStyle(color: Color(0xFF697EC0)),
      titleLarge: TextStyle(color: Color(0xFF829FCE)),
      bodyLarge: TextStyle(color: Color(0xFF697EC0)),
      bodyMedium: TextStyle(color: Color(0xFF829FCE)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF9BC0DC),
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF697EC0)),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF829FCE)),
      ),
      labelStyle: TextStyle(color: Color(0xFF697EC0)),
    ),
  ),
);

final CustomTheme darkThemeData = CustomTheme(
  themeData: ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF697EC0),
    secondaryHeaderColor: const Color(0xFF829FCE),
    scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    appBarTheme: AppBarTheme(
      color: const Color.fromARGB(252, 0, 0, 0),
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 20),
      ).titleLarge,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      selectedItemColor: Color(0xFF697EC0),
      unselectedItemColor: Color(0xFF9BC0DC),
      showUnselectedLabels: true,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF697EC0)),
      displayMedium: TextStyle(color: Color(0xFF829FCE)),
      displaySmall: TextStyle(color: Color(0xFF9BC0DC)),
      headlineMedium: TextStyle(color: Color(0xFFB4E1EA)),
      headlineSmall: TextStyle(color: Color(0xFF697EC0)),
      titleLarge: TextStyle(color: Color(0xFF829FCE)),
      bodyLarge: TextStyle(color: Color(0xFF697EC0)),
      bodyMedium: TextStyle(color: Color(0xFF829FCE)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF9BC0DC),
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF697EC0)),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF829FCE)),
      ),
      labelStyle: TextStyle(color: Color(0xFF697EC0)),
    ),
  ),
);
