// lib\theme\theme.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WrixlTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppConstants.primaryColor,
      fontFamily: 'Roboto',
      primaryColor: AppConstants.accentColor,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.accentColor,
        secondary: AppConstants.neonGreen,
        surface: AppConstants.primaryColor,
        error: AppConstants.neonRed,
        onPrimary: Colors.black,
        onSecondary: AppConstants.textColor,
        onSurface: AppConstants.textColor,
        onError: AppConstants.textColor,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: TextStyle(fontFamily: 'Rajdhani', fontSize: 20, color: Colors.white),
        titleMedium: TextStyle(fontFamily: 'Rajdhani', fontSize: 18, color: Colors.white),
        bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.white70),
        labelLarge: TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Colors.white54),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade900,
        labelStyle: const TextStyle(color: Colors.white54),
        hintStyle: const TextStyle(color: Colors.white38),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppConstants.accentColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppConstants.accentColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppConstants.accentColor),
        titleTextStyle: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, color: Colors.white),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppConstants.accentColor,
        contentTextStyle: TextStyle(color: Colors.black),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
      primaryColor: AppConstants.accentColor,
      colorScheme: const ColorScheme.light(
        primary: AppConstants.accentColor,
        secondary: AppConstants.neonGreen,
        surface: Colors.white,
        error: AppConstants.neonRed,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Rajdhani', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        headlineMedium: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
        titleLarge: TextStyle(fontFamily: 'Rajdhani', fontSize: 20, color: Colors.black),
        titleMedium: TextStyle(fontFamily: 'Rajdhani', fontSize: 18, color: Colors.black),
        bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black),
        bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black87),
        labelLarge: TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Colors.black54),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black38),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppConstants.accentColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppConstants.accentColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppConstants.accentColor),
        titleTextStyle: TextStyle(fontFamily: 'Rajdhani', fontSize: 24, color: Colors.black),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppConstants.accentColor,
        contentTextStyle: TextStyle(color: Colors.black),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static BoxDecoration getHoverGlow([Color glowColor = AppConstants.accentColor]) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: glowColor.withAlpha(153),
          blurRadius: 12,
          spreadRadius: 2,
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}
