// lib\widgets\common\new_reusable_widget_card.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/card_edit_overlay.dart';

class WidgetCard extends StatefulWidget {
  final DashboardItem item;
  final Widget child;
  final bool isEditMode;
  final bool isHidden;
  final VoidCallback? onToggleVisibility;
  final String? modalTitle;
  final WidgetModalSize modalSize;

  const WidgetCard({
    Key? key,
    required this.item,
    required this.child,
    required this.isEditMode,
    required this.isHidden,
    this.onToggleVisibility,
    this.modalTitle,
    this.modalSize = WidgetModalSize.medium,
  }) : super(key: key);

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

class _WidgetCardState extends State<WidgetCard> {
  bool _isHovered = false;

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: widget.modalTitle ?? widget.item.identifier,
        child: widget.child,
        size: widget.modalSize,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
//      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.isHidden
            ? colorScheme.surface.withOpacity(0.5)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isHidden
              ? Colors.grey
              : (_isHovered
                  ? colorScheme.primary
                  : colorScheme.secondary.withOpacity(0.6)),
          width: widget.isHidden ? 1.0 : (_isHovered ? 2.0 : 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isHidden
                ? Colors.grey.withOpacity(0.1)
                : (_isHovered
                    ? colorScheme.primary.withOpacity(0.25)
                    : Colors.black.withOpacity(0.05)),
            blurRadius: widget.isHidden ? 6 : (_isHovered ? 20 : 6),
            spreadRadius: widget.isHidden ? 0 : (_isHovered ? 3 : 1),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.child),
          Positioned(
            top: 4,
            left: 8,
            child: Text(
              widget.item.identifier,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary.withOpacity(0.75),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (widget.isHidden && widget.isEditMode) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: -0.7,
                    child: Text(
                      'HIDDEN',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.3),
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (widget.isEditMode)
            Positioned.fill(
              child: CardEditOverlay(
                isEditMode: widget.isEditMode,
                isHidden: widget.isHidden,
                onToggleVisibility: widget.onToggleVisibility,
                visible: !widget.isHidden,
              ),
            ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child:
          (!widget.isEditMode && widget.modalSize != WidgetModalSize.fullscreen)
              ? GestureDetector(onTap: () => _openModal(context), child: card)
              : card,
    );
  }
}
