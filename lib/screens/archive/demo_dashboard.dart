// lib/screens/dashboard/demo_dashboard.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class DemoDashboard extends StatefulWidget {
  const DemoDashboard({Key? key}) : super(key: key);

  @override
  State<DemoDashboard> createState() => _DemoDashboardState();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _DemoDashboardState extends State<DemoDashboard> {
  late DashboardItemController<DashboardItem> _controller;
  late List<DashboardItem> _currentItems;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedPreset = "Default";

  @override
  void initState() {
    super.initState();
    _currentItems = [];
    _controller = DashboardItemController<DashboardItem>(items: []);
  }

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    switch (selectedPreset) {
      case "Alt":
        return [
          DashboardItem(width: 4, height: 3, minWidth: 4, identifier: '2'),
          DashboardItem(width: 4, height: 3, minWidth: 4, identifier: '4'),
        ];
      default:
        switch (sizeClass) {
          case DeviceSizeClass.mobile:
            return [
              DashboardItem(
                  width: 12, height: 4, minWidth: 12, identifier: '1'),
              DashboardItem(
                  width: 12, height: 4, minWidth: 12, identifier: '2'),
              DashboardItem(
                  width: 12, height: 3, minWidth: 12, identifier: '3'),
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
              DashboardItem(
                  width: 5,
                  height: 4,
                  minWidth: 5,
                  minHeight: 3,
                  identifier: '2'),
              DashboardItem(
                  width: 4,
                  height: 4,
                  minWidth: 4,
                  minHeight: 4,
                  identifier: '3'),
              DashboardItem(width: 3, height: 5, minWidth: 3, identifier: '4'),
              DashboardItem(width: 2, height: 5, minWidth: 2, identifier: '5'),
              DashboardItem(width: 2, height: 2, minWidth: 2, identifier: '6'),
            ];
        }
    }
  }

  void _resetPreset() {
    if (_currentSizeClass == null) return;

    final items = _getItemsForSize(_currentSizeClass!);
    _currentItems = items;

    final newController = DashboardItemController<DashboardItem>(items: items);

    setState(() {
      _controller = newController;
      _visibility
        ..clear()
        ..addEntries(items.map((i) => MapEntry(i.identifier, true)));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.isEditing = _isEditing;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSizeClass = _getSizeClass(context);
    if (_currentSizeClass != newSizeClass) {
      _currentSizeClass = newSizeClass;
      _resetPreset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard (Responsive Layout)'),
        actions: [
          DropdownButton<String>(
            value: selectedPreset,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedPreset = value;
                _resetPreset();
              });
            },
            items: const [
              DropdownMenuItem(value: "Default", child: Text("Default")),
              DropdownMenuItem(value: "Alt", child: Text("Alt")),
            ],
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.lock_open : Icons.lock),
            tooltip: _isEditing ? "Lock Layout" : "Unlock Layout",
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                _controller = DashboardItemController<DashboardItem>(
                  items: _currentItems,
                );
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.isEditing = _isEditing;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Preset",
            onPressed: _isEditing ? _resetPreset : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Dashboard<DashboardItem>(
          key: ValueKey('$selectedPreset|$_isEditing|$_currentSizeClass'),
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
            final isHidden = !(_visibility[id] ?? true);
            if (!_isEditing && isHidden) return const SizedBox.shrink();

            return WidgetCard(
              item: item,
              child: Text(
                'Widget $id\n'
                'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}\n'
                'w:\${item.layoutData?.width} h:\${item.layoutData?.height}',
                textAlign: TextAlign.center,
              ),
              isEditMode: _isEditing,
              isHidden: isHidden,
              onToggleVisibility: () {
                setState(() {
                  _visibility[id] = !(_visibility[id] ?? true);
                });
              },
              modalTitle: 'Widget $id',
              modalSize: WidgetModalSize.small,
            );
          },
        ),
      ),
    );
  }
}
