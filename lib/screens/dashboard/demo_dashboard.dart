// lib\screens\dashboard\demo_dashboard.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import '../../utils/responsive.dart';

class DemoDashboard extends StatefulWidget {
  const DemoDashboard({Key? key}) : super(key: key);

  @override
  State<DemoDashboard> createState() => _DemoDashboardState();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _DemoDashboardState extends State<DemoDashboard> {
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
          DashboardItem(width: 12, height: 4, minWidth: 12, identifier: '1'),
          DashboardItem(width: 12, height: 4, minWidth: 12, identifier: '2'),
          DashboardItem(width: 12, height: 3, minWidth: 12, identifier: '3'),
        ];
      case DeviceSizeClass.tablet:
        return [
          DashboardItem(width: 6, height: 4, minWidth: 6, identifier: '1'),
          DashboardItem(width: 6, height: 4, minWidth: 6, identifier: '2'),
          DashboardItem(width: 8, height: 3, minWidth: 6, identifier: '3'),
          DashboardItem(width: 6, height: 4, minWidth: 6, identifier: '4'),
          DashboardItem(width: 8, height: 3, minWidth: 6, identifier: '5'),
        ];
      case DeviceSizeClass.desktop:
      default:
        return [
          DashboardItem(width: 6, height: 8, minWidth: 6, identifier: '1'),
          DashboardItem(width: 5, height: 4, minWidth: 5, minHeight: 3, identifier: '2'),
          DashboardItem(width: 4, height: 4, minWidth: 4, minHeight: 4, identifier: '3'),
          DashboardItem(width: 3, height: 5, minWidth: 3, identifier: '4'),
          DashboardItem(width: 2, height: 5, minWidth: 2, identifier: '5'),
          DashboardItem(width: 2, height: 2, minWidth: 2, identifier: '6'),
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
      setState(() {}); // Safe rebuild after controller swap
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Responsive Layout)'),
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
          horizontalSpace: 20,
          verticalSpace: 40,
          padding: const EdgeInsets.all(16),
          shrinkToPlace: false,
          slideToTop: false,
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
            final layoutData = item.layoutData!;
            final isHidden = !_visibility[id]!;

            if (!_isEditing && isHidden) return const SizedBox.shrink();

            return Container(
              decoration: BoxDecoration(
                color: isHidden ? Colors.grey[300] : Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Widget $id\n'
                      'x:${layoutData.startX} y:${layoutData.startY}\n'
                      'w:${layoutData.width} h:${layoutData.height}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: Icon(
                          isHidden ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _visibility[id] = !isHidden),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
