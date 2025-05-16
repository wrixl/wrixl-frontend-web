// lib\utils\layout_constants.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/screens/archive/layout_provider.dart';

enum WidgetHeight { short, medium, moderate, tall }

extension WidgetHeightExtension on WidgetHeight {
  double getHeight(BuildContext context) {
    final layout = LayoutProvider.of(context);
    switch (this) {
      case WidgetHeight.short:
        return layout.shortHeight;
      case WidgetHeight.medium:
        return layout.mediumHeight;
      case WidgetHeight.moderate:
        return layout.moderateHeight;
      case WidgetHeight.tall:
        return layout.tallHeight;
    }
  }
}

class LayoutHelper {
  final double screenWidth;
  final double screenHeight;

  static const double fixedOuterScreenMargin = 16.0;
  static const double collapsedSidebarWidth = 60.0;
  static const double expandedSidebarWidth = 220.0;

  late final double outerScreenMargin;
  late final double cardGutter;
  late final double verticalRowSpacing;
  late final double internalCardPadding;
  late final double cardCornerRadius;
  late final double cardElevation;

  late final double oneColumnWidth;
  late final double twoColumnWidth;
  late final double halfColumnWidth;
  late final double threeColumnWidth;

  late final double shortHeight;
  late final double mediumHeight;
  late final double moderateHeight;
  late final double tallHeight;

  LayoutHelper._withLayoutMode(
    this.screenWidth,
    this.screenHeight, {
    required bool isMobile,
    required bool isTablet,
    required bool isDesktop,
  }) {
    outerScreenMargin = fixedOuterScreenMargin;

    // only buffer on exactly 1024px
    final bool isTabletNarrow = isTablet && screenWidth == 1024;
    final double tabletWidthBuffer = isTabletNarrow ? 32.0 : 0.0;

    final baseWidth = screenWidth - (2 * outerScreenMargin) - tabletWidthBuffer;
    final baseUnit = baseWidth / 12;

    cardGutter = baseUnit * 0.2;
    verticalRowSpacing = baseUnit * 0.2;
    internalCardPadding = baseUnit * 0.5;
    cardCornerRadius = baseUnit * 0.15;
    cardElevation = baseUnit / 10;

    if (isMobile) {
      // single‑column
      oneColumnWidth = baseWidth;
      twoColumnWidth = baseWidth;
      threeColumnWidth = baseWidth;
      halfColumnWidth = (baseWidth - cardGutter) / 2;
    } else if (isTablet) {
      // two‑column layout
      oneColumnWidth = (baseWidth - cardGutter) / 2;
      twoColumnWidth = baseWidth;
      threeColumnWidth = baseWidth;
      halfColumnWidth = (baseWidth - cardGutter) / 2;
    } else {
      // ✅ full desktop grid — fix 3-column spacing
      oneColumnWidth = (baseWidth - 2 * cardGutter) / 3;
      twoColumnWidth = (baseWidth - cardGutter) * 2 / 3;
      halfColumnWidth = (baseWidth - cardGutter) / 2;
      threeColumnWidth = baseWidth;
    }

    shortHeight = screenHeight * 0.16;
    mediumHeight = shortHeight * 2;
    tallHeight = mediumHeight * 2 + verticalRowSpacing;
    moderateHeight = shortHeight + mediumHeight + verticalRowSpacing;
  }

  double get halfTallHeight => tallHeight / 2;

  static LayoutHelper of(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LayoutHelper.fromDimensions(size.width, size.height);
  }

  factory LayoutHelper.fromDimensions(double width, double height) {
    final isMobile = width < 600;
    final isTablet = width >= 600 && width <= 1024;
    final isDesktop = width > 1024;

    return LayoutHelper._withLayoutMode(
      width,
      height,
      isMobile: isMobile,
      isTablet: isTablet,
      isDesktop: isDesktop,
    );
  }
}

enum ModalSize { small, medium, large, fullscreen }

extension ModalSizeExtension on ModalSize {
  double getWidth(BuildContext context) {
    final layout = LayoutProvider.of(context);
    switch (this) {
      case ModalSize.small:
        return layout.oneColumnWidth;
      case ModalSize.medium:
        return layout.twoColumnWidth;
      case ModalSize.large:
        return layout.threeColumnWidth;
      case ModalSize.fullscreen:
        return layout.screenWidth;
    }
  }

  double getHeight(BuildContext context) {
    final layout = LayoutProvider.of(context);
    switch (this) {
      case ModalSize.small:
        return layout.shortHeight * 2;
      case ModalSize.medium:
        return layout.moderateHeight;
      case ModalSize.large:
        return layout.tallHeight;
      case ModalSize.fullscreen:
        return layout.screenHeight;
    }
  }
}
