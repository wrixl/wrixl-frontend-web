// lib/screens/dashboard/dashboard_screen2.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class DashboardScreen2 extends StatefulWidget {
  const DashboardScreen2({super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _DashboardScreen2State extends State<DashboardScreen2> {
  late DashboardItemController<DashboardItem> _controller;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    switch (sizeClass) {
      case DeviceSizeClass.mobile:
        return [
          DashboardItem(
              width: 12,
              height: 4,
              minWidth: 12,
              identifier: 'Portfolio Snapshot'),
          DashboardItem(
              width: 12,
              height: 3,
              minWidth: 12,
              identifier: 'Smart Money Drift'),
          DashboardItem(
              width: 12, height: 3, minWidth: 12, identifier: 'AI Quick Tip'),
        ];
      case DeviceSizeClass.tablet:
        return [
          DashboardItem(
              width: 6,
              height: 4,
              minWidth: 6,
              identifier: 'Portfolio Snapshot'),
          DashboardItem(
              width: 6,
              height: 4,
              minWidth: 6,
              identifier: 'Smart Money Drift'),
          DashboardItem(
              width: 6, height: 3, minWidth: 6, identifier: 'AI Quick Tip'),
          DashboardItem(
              width: 8, height: 4, minWidth: 6, identifier: 'Token Allocation'),
          DashboardItem(
              width: 4, height: 3, minWidth: 4, identifier: 'Stress Radar'),
          DashboardItem(
              width: 12, height: 2, minWidth: 6, identifier: 'Live Ticker'),
          DashboardItem(
              width: 6, height: 4, minWidth: 6, identifier: 'Model Portfolios'),
          DashboardItem(
              width: 6,
              height: 3,
              minWidth: 6,
              identifier: 'Performance Benchmarks'),
          DashboardItem(width: 6, height: 3, minWidth: 6, identifier: 'Alerts'),
          DashboardItem(
              width: 6, height: 3, minWidth: 6, identifier: 'Next Best Action'),
          DashboardItem(
              width: 12, height: 2, minWidth: 6, identifier: 'Wrixler Rank'),
          DashboardItem(
              width: 6, height: 3, minWidth: 6, identifier: 'Streak Tracker'),
          DashboardItem(
              width: 6,
              height: 3,
              minWidth: 6,
              identifier: 'Missed Opportunities'),
        ];
      case DeviceSizeClass.desktop:
      default:
        return [
          DashboardItem(
              width: 6,
              height: 8,
              minWidth: 6,
              identifier: 'Portfolio Snapshot'),
          DashboardItem(
              width: 5,
              height: 4,
              minWidth: 5,
              minHeight: 3,
              identifier: 'Smart Money Drift'),
          DashboardItem(
              width: 4,
              height: 4,
              minWidth: 4,
              minHeight: 4,
              identifier: 'AI Quick Tip'),
          DashboardItem(
              width: 6, height: 4, minWidth: 6, identifier: 'Token Allocation'),
          DashboardItem(
              width: 3, height: 4, minWidth: 3, identifier: 'Stress Radar'),
          DashboardItem(
              width: 12, height: 2, minWidth: 6, identifier: 'Live Ticker'),
          DashboardItem(
              width: 6, height: 4, minWidth: 6, identifier: 'Model Portfolios'),
          DashboardItem(
              width: 6,
              height: 3,
              minWidth: 6,
              identifier: 'Performance Benchmarks'),
          DashboardItem(width: 6, height: 3, minWidth: 6, identifier: 'Alerts'),
          DashboardItem(
              width: 6, height: 4, minWidth: 6, identifier: 'Next Best Action'),
          DashboardItem(
              width: 12, height: 2, minWidth: 6, identifier: 'Wrixler Rank'),
          DashboardItem(
              width: 6, height: 3, minWidth: 6, identifier: 'Streak Tracker'),
          DashboardItem(
              width: 6,
              height: 3,
              minWidth: 6,
              identifier: 'Missed Opportunities'),
        ];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSizeClass = _getSizeClass(context);
    if (_currentSizeClass != newSizeClass) {
      final items = _getItemsForSize(newSizeClass);
      _controller = DashboardItemController(items: items);
      _visibility.clear();
      for (var item in items) {
        _visibility[item.identifier] = true;
      }
      _currentSizeClass = newSizeClass;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrixl Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                _controller.isEditing = _isEditing;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Dashboard<DashboardItem>(
          dashboardItemController: _controller,
          slotCount: 12,
          slotAspectRatio: 1,
          horizontalSpace: 40,
          verticalSpace: 40,
          padding: const EdgeInsets.all(16),
          shrinkToPlace: false,
          slideToTop: false,
          absorbPointer: false,
          animateEverytime: false,
          physics: const BouncingScrollPhysics(),
          slotBackgroundBuilder: SlotBackgroundBuilder.withFunction(
            (_, __, ___, ____, _____) => null,
          ),
          editModeSettings: EditModeSettings(
            longPressEnabled: true,
            panEnabled: true,
            draggableOutside: true,
            autoScroll: true,
            resizeCursorSide: 10,
            backgroundStyle: EditModeBackgroundStyle(
              lineColor: Colors.grey,
              lineWidth: 0.5,
              dualLineHorizontal: true,
              dualLineVertical: true,
            ),
          ),
          itemBuilder: (item) {
            final id = item.identifier;
            final isHidden = !_visibility[id]!;

            if (!_isEditing && isHidden) return const SizedBox.shrink();

            return WidgetCard(
              item: item,
              child: Text(
                'Widget $id'
                'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}'
                'w:\${item.layoutData?.width} h:\${item.layoutData?.height}',
                textAlign: TextAlign.center,
              ),
              isEditMode: _isEditing,
              isHidden: isHidden,
              onToggleVisibility: () =>
                  setState(() => _visibility[id] = !isHidden),
              modalTitle: 'Widget $id',
              modalSize: WidgetModalSize.medium,
            );
          },
        ),
      ),
    );
  }
}
