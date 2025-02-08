import 'package:flutter/material.dart';

ThemeData fancyTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.yellow,
  scaffoldBackgroundColor: const Color.fromARGB(255, 35, 165, 109),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.black87,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.purpleAccent,
  ),
  cardTheme: CardTheme(
    color: Colors.black54,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 5,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
);
