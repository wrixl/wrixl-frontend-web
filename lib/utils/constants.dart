// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppConstants {
  // Base URL for API calls.
  static const String baseUrl = 'http://localhost:8000';

  // Endpoints.
  static const String loginEndpoint = '/auth/token';
  static const String registerEndpoint = '/auth/register';

  // Primary theme colors.
  static const Color primaryColor = Color(0xFF121212); // Deep charcoal
  static const Color accentColor = Color(0xFF00FFFF); // Electric Blue
  static const Color neonMagenta = Color(0xFFFF00FF); // Vivid Magenta
  static const Color neonGreen = Color(0xFF39FF14); // Neon Green

  // Additional neon highlights.
  static const Color neonYellow = Color(0xFFFFF95B); // Bright yellow
  static const Color neonOrange = Color(0xFFFF6E00); // Warning orange
  static const Color neonRed = Color(0xFFFF1744); // Alert red

  // Text colors.
  static const Color textColor = Color(0xFFE0E0E0); // Primary soft white
  static const Color secondaryTextColor =
      Color(0xFFB0BEC5); // Subtle steel blue

  // Layout constants.
  static const double defaultPadding = 16.0;
}
