// lib/widgets/common/card_edit_overlay.dart

import 'package:flutter/material.dart';

class CardEditOverlay extends StatelessWidget {
  final bool isHidden;
  final bool isEditMode;
  final VoidCallback? onToggleVisibility;
  final bool visible;

  const CardEditOverlay({
    super.key,
    required this.isEditMode,
    required this.isHidden,
    required this.onToggleVisibility,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditMode) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, right: 4),
        child: GestureDetector(
          onTap: onToggleVisibility,
          onPanStart: (_) {},    // absorb pan gestures on the button
          onPanUpdate: (_) {},
          onPanEnd: (_) {},
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              size: 18,
              color: visible
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}