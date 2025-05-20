// lib/screens/dashboard/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';
import 'package:wrixl_frontend/utils/dashboard_item_storage_delegate.dart'; // Import the delegate

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _ActivityScreenState extends State<ActivityScreen> {
  Future<void>? _initFuture;
  late DashboardItemController<DashboardItem> _controller;
  late SharedPrefsDashboardStorage _storage;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedPreset = "Default";
  bool _layoutLoaded = false;

  @override
  void initState() {
    super.initState();

    _storage = SharedPrefsDashboardStorage(
      'activity_layout',
      'activity_visibility',
      fallbackBuilder: () => _getItemsForSize(DeviceSizeClass.desktop),
    );

    _controller = DashboardItemController.withDelegate(
      itemStorageDelegate: _storage,
    );

    _storage.controller = _controller;

    _controller.addListener(() async {
      // getAllItems returns the full list (from prefs or fallback)
      final allItems = await _storage.getAllItems(12);
      // ensure every item has layoutData
      for (final item in allItems) {
        item.layoutData ??=
            ItemLayout(startX: 0, startY: 0, width: 12, height: 3);
      }
      // persist the complete list
      await _storage.onItemsUpdated(allItems, 12);
      print('[ActivityScreen] Persisted ${allItems.length} items.');
    });

    _initFuture = _initializeLayout();
  }

  Future<void> _initializeLayout() async {
    final items = await _controller.itemStorageDelegate!.getAllItems(12);

    _controller.notifyItemsChangedExternally(items); // ✅ apply saved layout
    _layoutLoaded = true;

    final visibility = await _storage.loadVisibility();

    setState(() {
      _visibility.addAll(visibility);
    });

    await _storage.logSavedLayout();
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
      case "Alt":
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

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  void _resetPreset() async {
    if (_currentSizeClass == null) return;

    final items = _getItemsForSize(_currentSizeClass!);

    // Save preset layout
    await _storage.onItemsUpdated(items, 12);
    _controller.notifyItemsChangedExternally(items);
    await _storage.logSavedLayout(); // ✅ works now

    // Preserve visibility across preset changes
    setState(() {
      for (final item in items) {
        _visibility.putIfAbsent(item.identifier, () => true);
      }
    });

    await _storage.saveVisibility(_visibility);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.isEditing = _isEditing;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSizeClass = _getSizeClass(context);

    if (_currentSizeClass != newSizeClass) {
      _currentSizeClass = newSizeClass;
      if (!_layoutLoaded) {
        _initFuture = _initializeLayout(); // ✅ load layout only if not loaded
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity & Alerts'),
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
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
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
                  (_, __, ___, ____, _____) => null),
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
                    'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                    'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                    textAlign: TextAlign.center,
                  ),
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _visibility[id] = !(_visibility[id] ?? true);
                    });
                    _storage.saveVisibility(_visibility);
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
