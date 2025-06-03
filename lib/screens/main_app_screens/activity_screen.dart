// lib/screens/dashboard/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

// Imported widgets
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/alerts_center.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/ai_next_step.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/my_activity_log.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/wrixl_pulse_feed.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/fyi_notifications.dart';

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
          {
            'id': 'Wrixl Pulse Feed',
            'x': 0,
            'y': 0,
            'w': 12,
            'h': 3,
            'minW': 12
          },
          {
            'id': 'FYI Notifications',
            'x': 0,
            'y': 3,
            'w': 6,
            'h': 3,
            'minW': 6
          },
          {'id': 'My Activity Log', 'x': 6, 'y': 3, 'w': 6, 'h': 3, 'minW': 6},
          {'id': 'Alerts Center', 'x': 0, 'y': 6, 'w': 12, 'h': 3, 'minW': 12},
          {'id': 'AI Next Step', 'x': 0, 'y': 9, 'w': 12, 'h': 2, 'minW': 12},
        ]);
      default:
        switch (sizeClass) {
          case DeviceSizeClass.mobile:
            return createItems([
              {
                'id': 'Alerts Center',
                'x': 0,
                'y': 0,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {
                'id': 'AI Next Step',
                'x': 0,
                'y': 3,
                'w': 12,
                'h': 2,
                'minW': 12
              },
              {
                'id': 'My Activity Log',
                'x': 0,
                'y': 5,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {
                'id': 'Wrixl Pulse Feed',
                'x': 0,
                'y': 8,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {
                'id': 'FYI Notifications',
                'x': 0,
                'y': 11,
                'w': 12,
                'h': 2,
                'minW': 12
              },
            ]);
          case DeviceSizeClass.tablet:
            return createItems([
              {
                'id': 'Alerts Center',
                'x': 0,
                'y': 0,
                'w': 12,
                'h': 3,
                'minW': 6
              },
              {'id': 'AI Next Step', 'x': 0, 'y': 3, 'w': 6, 'h': 2, 'minW': 6},
              {
                'id': 'My Activity Log',
                'x': 6,
                'y': 3,
                'w': 6,
                'h': 2,
                'minW': 6
              },
              {
                'id': 'Wrixl Pulse Feed',
                'x': 0,
                'y': 5,
                'w': 12,
                'h': 3,
                'minW': 12
              },
              {
                'id': 'FYI Notifications',
                'x': 0,
                'y': 8,
                'w': 12,
                'h': 2,
                'minW': 12
              },
            ]);
          case DeviceSizeClass.desktop:
          default:
            return createItems([
              {
                'id': 'Alerts Center',
                'x': 0,
                'y': 0,
                'w': 8,
                'h': 4,
                'minW': 6
              },
              {'id': 'AI Next Step', 'x': 8, 'y': 0, 'w': 4, 'h': 4, 'minW': 4},
              {
                'id': 'My Activity Log',
                'x': 0,
                'y': 4,
                'w': 6,
                'h': 3,
                'minW': 6
              },
              {
                'id': 'Wrixl Pulse Feed',
                'x': 6,
                'y': 4,
                'w': 6,
                'h': 3,
                'minW': 6
              },
              {
                'id': 'FYI Notifications',
                'x': 0,
                'y': 7,
                'w': 12,
                'h': 2,
                'minW': 12
              },
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

                Widget child;
                switch (id) {
                  case 'Alerts Center':
                    child = const AlertsCenterWidget();
                    break;
                  case 'AI Next Step':
                    child = const AINextStepWidget();
                    break;
                  case 'My Activity Log':
                    child = const MyActivityLogWidget();
                    break;
                  case 'Wrixl Pulse Feed':
                    child = const WrixlPulseFeedWidget();
                    break;
                  case 'FYI Notifications':
                    child = const FyiNotificationsWidget();
                    break;
                  default:
                    child = Text('Unknown widget: \$id');
                }

                return WidgetCard(
                  item: item,
                  child: child,
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _screenController.toggleVisibility(id);
                    });
                  },
                  modalTitle: id,
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
