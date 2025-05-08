import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.grey.shade300,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    color: Colors.deepPurple,
    elevation: 10.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xff7575CF),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);
