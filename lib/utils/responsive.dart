// lib/utils/responsive.dart

import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  // include 1024px as tablet
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w <= 1024;
  }

  // strictly greater than 1024 for desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1024;
}

