import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF0F0F10), // Rich black background
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6C63FF),       // Soft neon indigo for actions (e.g. buttons)
    onPrimary: Colors.white,
    secondary: Color(0xFF27272A),     // Soft surface cards
    onSecondary: Colors.white,
    background: Color(0xFF0F0F10),
    onBackground: Colors.white,
    surface: Color(0xFF1A1A1C),
    onSurface: Colors.white,
    error: Color(0xFFFF6B6B),         // Vibrant red
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F0F10),
    elevation: 0,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1A1A1C),
    selectedItemColor: Color(0xFF6C63FF),
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: false,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6C63FF),
    foregroundColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1A1A1C),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 3,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF27272A),
    hintStyle: const TextStyle(color: Colors.grey),
    labelStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
    labelLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  ),
);




final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF4F6FA), // Light pastel background
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6C63FF),       // Soft indigo (buttons, accents)
    onPrimary: Colors.white,
    secondary: Color(0xFFE0E5F2),     // Soft surface backgrounds
    onSecondary: Colors.black87,
    background: Color(0xFFF4F6FA),
    onBackground: Colors.black87,
    surface: Color(0xFFFFFFFF),
    onSurface: Colors.black,
    error: Color(0xFFE53935),         // Subtle error red
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF4F6FA),
    elevation: 0,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFE0E5F2),
    selectedItemColor: Color(0xFF6C63FF),
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: false,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF6C63FF),
    foregroundColor: Colors.white,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFFFFFFFF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 3,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFE9ECF5),
    hintStyle: const TextStyle(color: Colors.grey),
    labelStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
    labelLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
  ),
);


