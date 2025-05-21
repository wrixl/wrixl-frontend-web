// lib/screens/dashboard/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late DashboardScreenController _screenController;
  Future<void>? _initFuture;
  bool _isEditing = false;
  String selectedPreset = 'Default';

  final List<String> presetOptions = ['Default', 'Alt', 'Custom'];

  @override
  void initState() {
    super.initState();
    _initFuture = _initController();
  }

  void _syncEditingState() {
    _screenController.controller.isEditing = _isEditing;
  }

  Future<void> _initController() async {
    _screenController = DashboardScreenController(
      screenId: 'activity',
      preset: selectedPreset,
      context: context,
      getDefaultItems: _getItemsForSize,
    );
    await _screenController.initialize();
    _syncEditingState();
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    List<DashboardItem> createItems(List<Map<String, dynamic>> configs) {
      return configs.map((config) {
        return DashboardItem(
          identifier: config['id'],
          width: config['w'],
          height: config['h'],
          minWidth: config['minW'],
          minHeight: config['minH'] ?? 1,
          startX: config['x'],
          startY: config['y'],
        );
      }).toList();
    }

    switch (selectedPreset) {
      case 'Alt':
        return createItems([
          {'id': 'events', 'x': 0, 'y': 0, 'w': 12, 'h': 3, 'minW': 12},
          {'id': 'notifications', 'x': 0, 'y': 3, 'w': 6, 'h': 3, 'minW': 6},
          {'id': 'transactions', 'x': 6, 'y': 3, 'w': 6, 'h': 3, 'minW': 6},
        ]);
      default:
        switch (sizeClass) {
          case DeviceSizeClass.mobile:
            return createItems([
              {
                'id': 'notifications',
                'x': 0,
                'y': 0,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {
                'id': 'transactions',
                'x': 0,
                'y': 3,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {'id': 'events', 'x': 0, 'y': 6, 'w': 12, 'h': 3, 'minW': 12},
              {'id': 'airdrops', 'x': 0, 'y': 9, 'w': 12, 'h': 2, 'minW': 12},
              {'id': 'alerts', 'x': 0, 'y': 11, 'w': 12, 'h': 2, 'minW': 12},
            ]);
          case DeviceSizeClass.tablet:
            return createItems([
              {
                'id': 'notifications',
                'x': 0,
                'y': 0,
                'w': 6,
                'h': 3,
                'minW': 6
              },
              {'id': 'transactions', 'x': 6, 'y': 0, 'w': 6, 'h': 3, 'minW': 6},
              {'id': 'events', 'x': 0, 'y': 3, 'w': 12, 'h': 3, 'minW': 12},
              {'id': 'airdrops', 'x': 0, 'y': 6, 'w': 6, 'h': 2, 'minW': 6},
              {'id': 'alerts', 'x': 6, 'y': 6, 'w': 6, 'h': 2, 'minW': 6},
            ]);
          case DeviceSizeClass.desktop:
          default:
            return createItems([
              {
                'id': 'notifications',
                'x': 0,
                'y': 0,
                'w': 6,
                'h': 4,
                'minW': 6
              },
              {'id': 'transactions', 'x': 6, 'y': 0, 'w': 6, 'h': 4, 'minW': 6},
              {'id': 'events', 'x': 0, 'y': 4, 'w': 12, 'h': 3, 'minW': 6},
              {'id': 'airdrops', 'x': 0, 'y': 7, 'w': 6, 'h': 2, 'minW': 6},
              {'id': 'alerts', 'x': 6, 'y': 7, 'w': 6, 'h': 2, 'minW': 6},
            ]);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Activity & Alerts',
      presets: presetOptions,
      selectedPreset: selectedPreset,
      isEditing: _isEditing,
      onPresetChanged: (value) async {
        setState(() {
          selectedPreset = value;
          _isEditing = false;
        });
        _initFuture = _initController();
        await _initFuture;
        setState(() {});
      },
      onToggleEditing: () {
        if (selectedPreset != 'Custom') {
          setState(() {
            selectedPreset = 'Custom';
            _isEditing = false;
          });
          _initFuture = _initController();
        } else {
          setState(() {
            _isEditing = !_isEditing;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncEditingState();
          });
        }
      },
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Dashboard<DashboardItem>(
              key: ValueKey('$selectedPreset|$_isEditing'),
              dashboardItemController: _screenController.controller,
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
                final isHidden = !_screenController.isVisible(id);
                if (!_isEditing && isHidden) return const SizedBox.shrink();

                return WidgetCard(
                  item: item,
                  child: Text(
                    'Widget $id\n'
                    'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                    'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                    textAlign: TextAlign.center,
                  ),
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _screenController.toggleVisibility(id);
                    });
                  },
                  modalTitle: 'Widget $id',
                  modalSize: WidgetModalSize.small,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
