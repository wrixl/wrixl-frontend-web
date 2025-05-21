// lib\screens\dashboard\portfolios_screen2.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class PortfoliosScreen2 extends StatefulWidget {
  const PortfoliosScreen2({Key? key}) : super(key: key);

  @override
  State<PortfoliosScreen2> createState() => _PortfoliosScreen2State();
}

class _PortfoliosScreen2State extends State<PortfoliosScreen2>
    with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['Mine', 'Popular', 'Build'];
  late TabController _tabController;
  late String selectedTabKey;
  late String selectedPreset;
  bool _isEditing = false;

  final Map<String, List<String>> availablePresets = {
    'Mine': ['Default', 'Alt', 'Custom'],
    'Popular': ['Default', 'Alt', 'Custom'],
    'Build': ['Default', 'Alt', 'Custom'],
  };

  final Map<String, DashboardScreenController> _controllers = {};
  final Map<String, Future<void>> _initFutures = {};

  @override
  void initState() {
    super.initState();
    selectedTabKey = _tabKeys[0];
    selectedPreset = 'Default';
    _tabController = TabController(length: _tabKeys.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _initializeController(selectedTabKey, selectedPreset);
  }

  void _onTabChanged() {
    final newTab = _tabKeys[_tabController.index];
    setState(() {
      selectedTabKey = newTab;
      selectedPreset = 'Default';
    });
    _initializeController(newTab, selectedPreset);
  }

  void _syncEditingState() {
    _controllers[selectedTabKey]?.controller.isEditing = _isEditing;
  }

  Future<void> _initializeController(String tab, String preset) async {
    final controller = DashboardScreenController(
      screenId: 'portfolios',
      preset: '${preset}_$tab',
      context: context,
      getDefaultItems: (DeviceSizeClass sizeClass) =>
          _getItemsForTab(tab, sizeClass),
    );
    _controllers[tab] = controller;
    _initFutures[tab] =
        controller.initialize().then((_) => _syncEditingState());
    setState(() {});
  }

  List<DashboardItem> _getItemsForTab(String tab, DeviceSizeClass sizeClass) {
    List<DashboardItem> createItems(List<Map<String, dynamic>> configs) {
      return configs
          .map((config) => DashboardItem(
                identifier: config['id'],
                width: config['w'],
                height: config['h'],
                minWidth: config['minW'],
                minHeight: config['minH'] ?? 1,
                startX: config['x'],
                startY: config['y'],
              ))
          .toList();
    }

    switch (tab) {
      case 'Popular':
        return createItems([
          {'id': 'Model Filters', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12},
          for (int i = 1; i <= 4; i++)
            {
              'id': 'Model Portfolio $i',
              'x': (i - 1) % 2 * 6,
              'y': 1 + (i - 1) ~/ 2 * 3,
              'w': 6,
              'h': 3,
              'minW': 6
            },
          {
            'id': 'Model Comparison',
            'x': 0,
            'y': 7,
            'w': 12,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Try Before You Mirror',
            'x': 0,
            'y': 11,
            'w': 12,
            'h': 2,
            'minW': 6
          },
        ]);
      case 'Build':
        return createItems([
          {'id': 'Prompt Input', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12},
          {
            'id': 'Risk & ROI Sliders',
            'x': 0,
            'y': 2,
            'w': 12,
            'h': 3,
            'minW': 12
          },
          {'id': 'Token Filters', 'x': 0, 'y': 5, 'w': 12, 'h': 3, 'minW': 12},
          {
            'id': 'Backtest Results',
            'x': 0,
            'y': 8,
            'w': 12,
            'h': 3,
            'minW': 12
          },
          {
            'id': 'Simulate & Save',
            'x': 0,
            'y': 11,
            'w': 12,
            'h': 2,
            'minW': 12
          },
        ]);
      case 'Mine':
      default:
        return createItems([
          {
            'id': 'Portfolio View Filters',
            'x': 0,
            'y': 0,
            'w': 12,
            'h': 2,
            'minW': 12
          },
          {'id': 'Filters', 'x': 0, 'y': 2, 'w': 4, 'h': 6, 'minW': 4},
          for (int i = 1; i <= 4; i++)
            {
              'id': 'Portfolio $i',
              'x': ((i - 1) % 3) * 4,
              'y': 2 + ((i - 1) ~/ 3) * 4,
              'w': 4,
              'h': 4,
              'minW': 4
            },
          {
            'id': 'Portfolio Detail',
            'x': 0,
            'y': 10,
            'w': 12,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Portfolio Comparison Radar',
            'x': 0,
            'y': 14,
            'w': 12,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Create Portfolio',
            'x': 0,
            'y': 18,
            'w': 12,
            'h': 2,
            'minW': 12
          },
        ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Portfolios"),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabKeys.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabKeys.map((tabKey) {
            final controller = _controllers[tabKey];
            final future = _initFutures[tabKey];
            final presets = availablePresets[tabKey]!;

            if (controller == null || future == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return DashboardScaffold(
              title: 'Portfolios - $tabKey',
              presets: presets,
              selectedPreset: selectedPreset,
              isEditing: _isEditing,
              onPresetChanged: (val) async {
                setState(() {
                  selectedPreset = val;
                  _isEditing = false;
                });
                await _initializeController(tabKey, val);
              },
              onToggleEditing: () {
                if (selectedPreset != 'Custom') {
                  setState(() {
                    selectedPreset = 'Custom';
                    _isEditing = false;
                  });
                  _initializeController(tabKey, selectedPreset);
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
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Dashboard<DashboardItem>(
                    key: ValueKey('$tabKey|$selectedPreset|$_isEditing'),
                    dashboardItemController: controller.controller,
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
                      final isHidden = !controller.isVisible(id);
                      if (!_isEditing && isHidden)
                        return const SizedBox.shrink();

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
                          setState(() => controller.toggleVisibility(id));
                        },
                        modalTitle: 'Widget $id',
                        modalSize: WidgetModalSize.medium,
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
