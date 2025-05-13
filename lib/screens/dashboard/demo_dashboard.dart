// lib\screens\dashboard\demo_dashboard.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';

class DemoDashboard extends StatefulWidget {
  const DemoDashboard({Key? key}) : super(key: key);

  @override
  _DemoDashboardState createState() => _DemoDashboardState();
}

class _DemoDashboardState extends State<DemoDashboard> {
  late final DashboardItemController<DashboardItem> _controller;
  bool _isEditing = false;

  // Persistent per-widget layout state (including visibility)
  final Map<String, WidgetLayout> _widgetLayouts = {};

  @override
  void initState() {
    super.initState();

    final items = [
      DashboardItem(startX: 0, startY: 0, width: 2, height: 2, identifier: '1'),
      DashboardItem(startX: 2, startY: 0, width: 1, height: 1, identifier: '2'),
      DashboardItem(startX: 3, startY: 0, width: 3, height: 2, identifier: '3'),
      DashboardItem(startX: 0, startY: 2, width: 2, height: 1, identifier: '4'),
      DashboardItem(startX: 2, startY: 2, width: 1, height: 3, identifier: '5'),
      DashboardItem(startX: 3, startY: 2, width: 2, height: 2, identifier: '6'),
    ];

    for (var item in items) {
      final layout = item.layoutData;
      _widgetLayouts[item.identifier] = WidgetLayout(
        id: item.identifier,
        visible: true, // default to visible
        row: layout?.startY ?? 0,
        colStart: layout?.startX ?? 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true,
      );
    }

    _controller = DashboardItemController(items: items);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _controller.isEditing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final layoutHelper = LayoutHelper.fromDimensions(1200, 800);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Dashboard 0.0.4'),
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
          absorbPointer: false,
          dashboardItemController: _controller,
          slotCount: 8,
          slotAspectRatio: 1,
          horizontalSpace: 20,
          verticalSpace: 24,
          padding: const EdgeInsets.all(20),
          shrinkToPlace: false,
          slideToTop: false,
          animateEverytime: true,
          physics: const RangeMaintainingScrollPhysics(),
          slotBackgroundBuilder: SlotBackgroundBuilder.withFunction(
              (_, __, ___, ____, _____) => null),
          editModeSettings: EditModeSettings(
            longPressEnabled: true,
            panEnabled: true,
            draggableOutside: true,
            autoScroll: true,
            paintBackgroundLines: true,
            resizeCursorSide: 10,
            backgroundStyle: EditModeBackgroundStyle(
              lineColor: Color.fromARGB(255, 158, 158, 158),
              lineWidth: 0.5,
              dualLineHorizontal: true,
              dualLineVertical: true,
            ),
          ),
          itemBuilder: (item) {
            final id = item.identifier;
            final layout = item.layoutData;
            final modalSize = {
                  '1': ModalSize.medium,
                  '2': ModalSize.small,
                  '3': ModalSize.large,
                  '4': ModalSize.medium,
                  '5': ModalSize.large,
                  '6': ModalSize.small,
                }[id] ?? ModalSize.medium;

            final widgetLayout = _widgetLayouts[id]!;

            widgetLayout.modalSize = modalSize;

            // Don't render hidden widgets when not in edit mode
            if (!_isEditing && !widgetLayout.visible) return const SizedBox.shrink();

            return WrixlCard(
              layout: widgetLayout,
              layoutHelper: layoutHelper,
              isEditMode: _isEditing,
              isHidden: !widgetLayout.visible,
              onLayoutChanged: (updatedLayout) {
                setState(() {
                  _widgetLayouts[id] = updatedLayout;
                });
              },
              onToggleVisibility: () {
                setState(() {
                  widgetLayout.visible = !widgetLayout.visible;
                });
              },
              child: Center(
                child: Text(
                  'Widget $id\n'
                  'x:${layout?.startX ?? '?'} y:${layout?.startY ?? '?'}\n'
                  'w:${layout?.width ?? '?'} h:${layout?.height ?? '?'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          },


        ),
      ),
    );
  }
}