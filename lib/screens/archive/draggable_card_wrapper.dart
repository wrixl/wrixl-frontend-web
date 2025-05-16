// lib/widgets/common/draggable_card_wrapper.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DraggableCardWrapper extends StatefulWidget {
  final Widget child;
  final int index;
  final bool isEditMode;
  final List visibleWidgets;
  final void Function(int fromIndex, int toIndex) onReorder;

  const DraggableCardWrapper({
    super.key,
    required this.child,
    required this.index,
    required this.isEditMode,
    required this.visibleWidgets,
    required this.onReorder,
  });

  @override
  State<DraggableCardWrapper> createState() => _DraggableCardWrapperState();
}

class _DraggableCardWrapperState extends State<DraggableCardWrapper> {
  Timer? _scrollTimer;

  void _handleAutoScroll(DragUpdateDetails details) {
    final scrollable = Scrollable.of(context);
    final scrollController = scrollable?.widget.controller;
    if (scrollController == null) return;

    const threshold = 100.0; // px from top/bottom to trigger scroll
    const scrollSpeed = 10.0;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.globalToLocal(details.globalPosition);

    if (offset.dy < threshold) {
      scrollController.jumpTo(
        (scrollController.offset - scrollSpeed)
            .clamp(0.0, scrollController.position.maxScrollExtent),
      );
    } else if (offset.dy > renderBox.size.height - threshold) {
      scrollController.jumpTo(
        (scrollController.offset + scrollSpeed)
            .clamp(0.0, scrollController.position.maxScrollExtent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEditMode) return widget.child;

    final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    final dragWidget = isMobile
        ? LongPressDraggable<int>(
            data: widget.index,
            feedback: Opacity(opacity: 0.85, child: widget.child),
            childWhenDragging: const SizedBox.shrink(),
            onDragCompleted: () {},
            onDragUpdate: _handleAutoScroll,
            child: _buildDragTarget(),
          )
        : Draggable<int>(
            data: widget.index,
            feedback: Opacity(opacity: 0.85, child: widget.child),
            childWhenDragging: const SizedBox.shrink(),
            onDragCompleted: () {},
            onDragUpdate: _handleAutoScroll,
            child: _buildDragTarget(),
          );

    return dragWidget;
  }

  Widget _buildDragTarget() {
    return DragTarget<int>(
      onWillAccept: (from) => from != widget.index,
      onAccept: (fromIndex) => widget.onReorder(fromIndex, widget.index),
      builder: (_, __, ___) => widget.child,
    );
  }
}
