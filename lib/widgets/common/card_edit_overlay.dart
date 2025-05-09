// lib/widgets/common/card_edit_overlay.dart

import 'package:flutter/material.dart';

class CardEditOverlay extends StatelessWidget {
  final bool isHidden;
  final bool isEditMode;
  final VoidCallback? onResizeWidth;
  final VoidCallback? onResizeHeight;
  final VoidCallback? onToggleVisibility;
  final bool visible;

  const CardEditOverlay({
    super.key,
    required this.isEditMode,
    required this.isHidden,
    required this.onResizeWidth,
    required this.onResizeHeight,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Visibility toggle
            if (onToggleVisibility != null)
              Opacity(
                opacity: visible ? 1.0 : 0.4,
                child: IconButton(
                  icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                  tooltip: visible ? "Hide" : "Show",
                  onPressed: onToggleVisibility,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surfaceVariant,
                    minimumSize: const Size(28, 28),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            const SizedBox(width: 4),

            // Resize width (↔️)
            Opacity(
              opacity: isHidden ? 0.4 : 1.0,
              child: IconButton(
                icon: const Icon(Icons.swap_horiz),
                tooltip: "Resize Width",
                onPressed: isHidden ? null : onResizeWidth,
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant,
                  minimumSize: const Size(28, 28),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Resize height (↕️)
            Opacity(
              opacity: isHidden ? 0.4 : 1.0,
              child: IconButton(
                icon: const Icon(Icons.swap_vert),
                tooltip: "Resize Height",
                onPressed: isHidden ? null : onResizeHeight,
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant,
                  minimumSize: const Size(28, 28),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
