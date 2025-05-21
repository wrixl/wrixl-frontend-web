// lib\screens\dashboard\community_game_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class CommunityGameScreen extends StatefulWidget {
  const CommunityGameScreen({Key? key}) : super(key: key);

  @override
  State<CommunityGameScreen> createState() => _CommunityGameScreenState();
}

class _CommunityGameScreenState extends State<CommunityGameScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['Predict', 'Vote', 'Earn', 'Rank'];
  late TabController _tabController;
  late String selectedTabKey;
  late String selectedPreset;
  bool _isEditing = false;

  final Map<String, List<String>> availablePresets = {
    'Predict': ['Default', 'Alt', 'Custom'],
    'Vote': ['Default', 'Alt', 'Custom'],
    'Earn': ['Default', 'Alt', 'Custom'],
    'Rank': ['Default', 'Alt', 'Custom'],
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
      screenId: 'community_game',
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
      case 'Predict':
        return createItems([
          {
            'id': 'Predict - Signal Prediction Market',
            'x': 0,
            'y': 0,
            'w': 6,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Predict - Portfolio Prediction Arena',
            'x': 0,
            'y': 4,
            'w': 12,
            'h': 4,
            'minW': 6
          },
        ]);
      case 'Vote':
        return createItems([
          {
            'id': 'Vote - Signals DAO Voting',
            'x': 0,
            'y': 0,
            'w': 12,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Vote - Signal Curation Submissions',
            'x': 0,
            'y': 4,
            'w': 8,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Vote - Referral Impact',
            'x': 8,
            'y': 4,
            'w': 4,
            'h': 3,
            'minW': 3
          },
        ]);
      case 'Earn':
        return createItems([
          {
            'id': 'Earn - WRX Rewards Dashboard',
            'x': 0,
            'y': 0,
            'w': 8,
            'h': 4,
            'minW': 6
          },
          {
            'id': 'Earn - Rewards Inventory',
            'x': 8,
            'y': 0,
            'w': 4,
            'h': 3,
            'minW': 3
          },
          {
            'id': 'Earn - Claimable Perks',
            'x': 0,
            'y': 4,
            'w': 6,
            'h': 2,
            'minW': 4
          },
          {
            'id': 'Earn - Impact Score',
            'x': 6,
            'y': 4,
            'w': 6,
            'h': 2,
            'minW': 4
          },
        ]);
      case 'Rank':
        return createItems([
          {
            'id': 'Rank - User Leaderboard',
            'x': 0,
            'y': 0,
            'w': 4,
            'h': 3,
            'minW': 3
          },
          {
            'id': 'Rank - Community Contests',
            'x': 4,
            'y': 0,
            'w': 8,
            'h': 3,
            'minW': 6
          },
          {
            'id': 'Rank - Badge Collection',
            'x': 0,
            'y': 3,
            'w': 4,
            'h': 3,
            'minW': 3
          },
          {
            'id': 'Rank - XP Progress',
            'x': 4,
            'y': 3,
            'w': 4,
            'h': 2,
            'minW': 3
          },
          {
            'id': 'Rank - Weekly Mission',
            'x': 0,
            'y': 6,
            'w': 8,
            'h': 3,
            'minW': 6
          },
          {
            'id': 'Rank - Wrixler Rank',
            'x': 8,
            'y': 3,
            'w': 4,
            'h': 3,
            'minW': 3
          },
          {
            'id': 'Rank - Sector Rankings',
            'x': 0,
            'y': 9,
            'w': 8,
            'h': 3,
            'minW': 6
          },
          {
            'id': 'Rank - Discussion Threads',
            'x': 0,
            'y': 12,
            'w': 12,
            'h': 6,
            'minW': 6
          },
        ]);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Community & Gamification"),
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
              title: 'Community - $tabKey',
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
                          'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                          'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                          textAlign: TextAlign.center,
                        ),
                        isEditMode: _isEditing,
                        isHidden: isHidden,
                        onToggleVisibility: () =>
                            setState(() => controller.toggleVisibility(id)),
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
