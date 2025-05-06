// lib\widgets\common\reusable_card_modal.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/theme/layout_theme_extension.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';

class WrixlModal extends StatelessWidget {
  final ModalSize size;
  final String title;
  final Widget child;
  final VoidCallback onClose;

  const WrixlModal({
    Key? key,
    required this.size,
    required this.title,
    required this.child,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layout = LayoutThemeExtension.of(context).layout;
    final width = size.getWidth(context);
    final height = size.getHeight(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(layout.cardCornerRadius),
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
            /// Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(layout.cardCornerRadius),
                  topRight: Radius.circular(layout.cardCornerRadius),
                ),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            /// Body
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(layout.internalCardPadding),
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
