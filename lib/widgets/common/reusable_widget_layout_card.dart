// lib/widgets/common/reusable_widget_layout_card.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/theme/layout_theme_extension.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/widgets/common/reusable_card_modal.dart';

class WrixlCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool centerContent;
  final bool stacked;
  final bool openOnTap;
  final ModalSize modalSize;
  final String? modalTitle;

  const WrixlCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.centerContent = false,
    this.stacked = false,
    this.openOnTap = false,
    this.modalSize = ModalSize.medium,
    this.modalTitle,
  }) : super(key: key);

  @override
  State<WrixlCard> createState() => _WrixlCardState();
}

class _WrixlCardState extends State<WrixlCard> {
  bool _isHovered = false;

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WrixlModal(
        size: widget.modalSize,
        title: widget.modalTitle ?? "Details",
        child: widget.child,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = LayoutThemeExtension.of(context).layout;
    final colorScheme = Theme.of(context).colorScheme;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.width,
      height: widget.height,
      margin: widget.margin ??
          (widget.stacked
              ? EdgeInsets.zero
              : EdgeInsets.only(bottom: layout.verticalRowSpacing)),
      padding: widget.padding ?? EdgeInsets.all(layout.internalCardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(layout.cardCornerRadius),
        border: Border.all(
          color: _isHovered
              ? colorScheme.primary
              : colorScheme.secondary.withOpacity(0.6),
          width: _isHovered ? 2.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isHovered
                ? colorScheme.primary.withOpacity(0.25)
                : Colors.black.withOpacity(0.05),
            blurRadius: _isHovered ? 20 : layout.cardElevation,
            spreadRadius: _isHovered ? 3 : 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.centerContent ? Center(child: widget.child) : widget.child,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.openOnTap
          ? GestureDetector(
              onTap: () => _openModal(context),
              child: card,
            )
          : card,
    );
  }
}
