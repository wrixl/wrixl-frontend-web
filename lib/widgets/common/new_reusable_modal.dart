// lib\widgets\common\new_reusable_modal.dart

import 'package:flutter/material.dart';

enum WidgetModalSize { small, medium, large, fullscreen }

extension WidgetModalSizeDimensions on WidgetModalSize {
  Size getSize(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    switch (this) {
      case WidgetModalSize.small:
        return Size(screen.width * 0.4, screen.height * 0.35);
      case WidgetModalSize.medium:
        return Size(screen.width * 0.6, screen.height * 0.55);
      case WidgetModalSize.large:
        return Size(screen.width * 0.8, screen.height * 0.75);
      case WidgetModalSize.fullscreen:
        return Size(screen.width, screen.height);
    }
  }
}

class NewWidgetModal extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onClose;
  final WidgetModalSize size;
  final Size? fixedSize;

  const NewWidgetModal({
    Key? key,
    required this.title,
    required this.child,
    required this.onClose,
    this.size = WidgetModalSize.medium,
    this.fixedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final resolvedSize = fixedSize ?? size.getSize(context);
    const double cardCornerRadius = 16;
    const double cardPadding = 16;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: resolvedSize.width,
        height: resolvedSize.height,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(cardCornerRadius),
          border: Border.all(color: colorScheme.primary, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.25),
              blurRadius: 24,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(cardCornerRadius),
                  topRight: Radius.circular(cardCornerRadius),
                ),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(cardPadding),
                child: SingleChildScrollView(child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
