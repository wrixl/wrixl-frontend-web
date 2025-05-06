import 'package:flutter/material.dart';
import '../utils/layout_constants.dart';

class LayoutThemeExtension extends ThemeExtension<LayoutThemeExtension> {
  final LayoutHelper layout;

  const LayoutThemeExtension({required this.layout});

  @override
  LayoutThemeExtension copyWith({LayoutHelper? layout}) {
    return LayoutThemeExtension(
      layout: layout ?? this.layout,
    );
  }

  @override
  LayoutThemeExtension lerp(ThemeExtension<LayoutThemeExtension>? other, double t) {
    if (other is! LayoutThemeExtension) {
      return this;
    }
    return this;
  }

  // Convenience method for access
  static LayoutThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<LayoutThemeExtension>()!;
  }
}
