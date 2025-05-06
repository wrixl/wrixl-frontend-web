// lib\utils\layout_provider.dart

import 'package:flutter/material.dart';
import 'layout_constants.dart';

class LayoutProvider extends InheritedWidget {
  final LayoutHelper layout;

  const LayoutProvider({
    Key? key,
    required this.layout,
    required Widget child,
  }) : super(key: key, child: child);

  static LayoutHelper of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<LayoutProvider>();
    if (provider != null) return provider.layout;

    // Fallback for dialogs and modals not wrapped in provider
    final size = MediaQuery.of(context).size;
    return LayoutHelper.fromDimensions(size.width, size.height);
  }

  @override
  bool updateShouldNotify(LayoutProvider oldWidget) {
    return layout.screenWidth != oldWidget.layout.screenWidth ||
           layout.screenHeight != oldWidget.layout.screenHeight;
  }
}
