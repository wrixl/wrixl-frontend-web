// lib/widgets/common/reusable_widget_layout_card.dart

import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/theme/layout_theme_extension.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/widgets/common/reusable_card_modal.dart';
import 'package:wrixl_frontend/widgets/common/card_edit_overlay.dart';
import 'package:wrixl_frontend/utils/responsive.dart';

enum WidgetWidth { oneColumn, onePointFiveColumn, twoColumn, threeColumn }

class WidgetLayout {
  final String id;
  bool visible;
  int row;
  int colStart;
  WidgetWidth width;
  WidgetHeight height;
  ModalSize modalSize;
  bool openOnTap;

  WidgetLayout({
    required this.id,
    required this.visible,
    required this.row,
    required this.colStart,
    required this.width,
    required this.height,
    this.modalSize = ModalSize.medium,
    this.openOnTap = false,
  });

  factory WidgetLayout.fromJson(Map<String, dynamic> json) {
    return WidgetLayout(
      id: json['id'],
      visible: json['visible'],
      row: json['row'],
      colStart: json['colStart'],
      width: WidgetWidth.values.firstWhere((e) => e.name == json['width']),
      height: WidgetHeight.values.firstWhere((e) => e.name == json['height']),
      modalSize:
          ModalSize.values.firstWhere((e) => e.name == json['modalSize']),
      openOnTap: json['openOnTap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visible': visible,
      'row': row,
      'colStart': colStart,
      'width': width.name,
      'height': height.name,
      'modalSize': modalSize.name,
      'openOnTap': openOnTap,
    };
  }
}

class WrixlCard extends StatefulWidget {
  final WidgetLayout layout;
  final LayoutHelper layoutHelper;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool centerContent;
  final bool stacked;
  final String? modalTitle;
  final bool isEditMode;
  final void Function(WidgetLayout) onLayoutChanged;
  final bool isHidden;
  final VoidCallback? onToggleVisibility;

  const WrixlCard({
    Key? key,
    required this.layout,
    required this.layoutHelper,
    required this.child,
    required this.isEditMode,
    required this.onLayoutChanged,
    required this.isHidden,
    this.onToggleVisibility,
    this.padding,
    this.margin,
    this.centerContent = false,
    this.stacked = false,
    this.modalTitle,
  }) : super(key: key);

  @override
  State<WrixlCard> createState() => _WrixlCardState();

  factory WrixlCard.fromDashboardItem({
    required DashboardItem item,
    required bool isEditMode,
    required LayoutHelper layoutHelper,
    required Widget child,
  }) {
    final layout = item.layoutData;

    return WrixlCard(
      layout: WidgetLayout(
        id: item.identifier,
        visible: true,
        row: layout?.startY ?? 0,
        colStart: layout?.startX ?? 0,
        width: WidgetWidth.oneColumn, // Approximate mapping
        height: WidgetHeight.medium, // Approximate mapping
      ),
      layoutHelper: layoutHelper,
      isEditMode: isEditMode,
      onLayoutChanged: (_) {}, // No-op for demo
      isHidden: false,
      child: child,
    );
  }
}

class _WrixlCardState extends State<WrixlCard> {
  bool _isHovered = false;

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => WrixlModal(
        size: widget.layout.modalSize,
        title: widget.modalTitle ?? widget.layout.id,
        child: widget.child,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  double getCardWidth() {
    if (Responsive.isMobile(context)) {
      return widget.layoutHelper.threeColumnWidth;
    }

    switch (widget.layout.width) {
      case WidgetWidth.oneColumn:
        return widget.layoutHelper.oneColumnWidth;
      case WidgetWidth.onePointFiveColumn:
        return widget.layoutHelper.halfColumnWidth;
      case WidgetWidth.twoColumn:
        return widget.layoutHelper.twoColumnWidth;
      case WidgetWidth.threeColumn:
        return widget.layoutHelper.threeColumnWidth;
    }
  }

  double getCardHeight() {
    switch (widget.layout.height) {
      case WidgetHeight.short:
        return widget.layoutHelper.shortHeight;
      case WidgetHeight.medium:
        return widget.layoutHelper.mediumHeight;
      case WidgetHeight.moderate:
        return widget.layoutHelper.moderateHeight;
      case WidgetHeight.tall:
        return widget.layoutHelper.tallHeight;
    }
  }

  void _resizeWidth() {
    if (Responsive.isMobile(context)) return;
    final next = WidgetWidth
        .values[(widget.layout.width.index + 1) % WidgetWidth.values.length];
    widget.onLayoutChanged(widget.layout..width = next);
  }

  void _resizeHeight() {
    final next = WidgetHeight
        .values[(widget.layout.height.index + 1) % WidgetHeight.values.length];
    widget.onLayoutChanged(widget.layout..height = next);
  }

  WrixlCard copyWithModalConfig({ModalSize? modalSize, bool? openOnTap}) {
    return WrixlCard(
      layout: widget.layout
        ..modalSize = modalSize ?? widget.layout.modalSize
        ..openOnTap = openOnTap ?? widget.layout.openOnTap,
      layoutHelper: widget.layoutHelper,
      isEditMode: widget.isEditMode,
      onLayoutChanged: widget.onLayoutChanged,
      isHidden: widget.isHidden,
      child: widget.child,
      onToggleVisibility: widget.onToggleVisibility,
      modalTitle: widget.modalTitle,
      padding: widget.padding,
      margin: widget.margin,
      centerContent: widget.centerContent,
      stacked: widget.stacked,
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = LayoutThemeExtension.of(context).layout;
    final colorScheme = Theme.of(context).colorScheme;

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: getCardWidth(),
      height: getCardHeight(),
      margin: widget.margin ??
          (widget.stacked
              ? EdgeInsets.zero
              : EdgeInsets.only(bottom: layout.verticalRowSpacing)),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.isHidden
            ? colorScheme.surface.withOpacity(0.5)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(layout.cardCornerRadius),
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
            blurRadius:
                widget.isHidden ? 6 : (_isHovered ? 20 : layout.cardElevation),
            spreadRadius: widget.isHidden ? 0 : (_isHovered ? 3 : 1),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding:
                  widget.padding ?? EdgeInsets.all(layout.internalCardPadding),
              child: widget.centerContent
                  ? Center(child: widget.child)
                  : widget.child,
            ),
          ),
          Positioned(
            top: 4,
            left: 8,
            child: Text(
              widget.layout.id,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
              ),
            ),
          ),
          if (widget.isHidden && widget.isEditMode) ...[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(layout.cardCornerRadius),
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
                visible: widget.layout.visible,
              ),
            ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: (!widget.layout.visible && !widget.isEditMode)
          ? const SizedBox.shrink()
          : widget.layout.openOnTap && !widget.isEditMode
              ? GestureDetector(onTap: () => _openModal(context), child: card)
              : card,
    );
  }
}
