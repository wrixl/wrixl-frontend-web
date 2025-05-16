// lib\screens\dashboard\community_game_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class CommunityGameScreen extends StatefulWidget {
  const CommunityGameScreen({Key? key}) : super(key: key);

  @override
  State<CommunityGameScreen> createState() => _CommunityGameScreenState();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _CommunityGameScreenState extends State<CommunityGameScreen>
    with SingleTickerProviderStateMixin {
  late DashboardItemController<DashboardItem> _controller;
  late List<DashboardItem> _currentItems;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedPreset = "Default";

  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Predict'),
    Tab(text: 'Vote'),
    Tab(text: 'Earn'),
    Tab(text: 'Rank'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = DashboardItemController(items: []);
    _currentItems = [];
    _tabController = TabController(length: _tabs.length, vsync: this);
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
          DashboardItem(width: 6, height: 4, minWidth: 6, identifier: 'Predict - Signal Prediction Market'),
          DashboardItem(width: 12, height: 4, minWidth: 6, identifier: 'Predict - Portfolio Prediction Arena'),
        ];
      default:
        return [
          DashboardItem(width: 6, height: 4, minWidth: 6, identifier: 'Predict - Signal Prediction Market'),
          DashboardItem(width: 12, height: 4, minWidth: 6, identifier: 'Predict - Portfolio Prediction Arena'),
          DashboardItem(width: 12, height: 4, minWidth: 6, identifier: 'Vote - Signals DAO Voting'),
          DashboardItem(width: 8, height: 4, minWidth: 6, identifier: 'Vote - Signal Curation Submissions'),
          DashboardItem(width: 4, height: 3, minWidth: 3, identifier: 'Vote - Referral Impact'),
          DashboardItem(width: 8, height: 4, minWidth: 6, identifier: 'Earn - WRX Rewards Dashboard'),
          DashboardItem(width: 4, height: 3, minWidth: 3, identifier: 'Earn - Rewards Inventory'),
          DashboardItem(width: 6, height: 2, minWidth: 4, identifier: 'Earn - Claimable Perks'),
          DashboardItem(width: 6, height: 2, minWidth: 4, identifier: 'Earn - Impact Score'),
          DashboardItem(width: 4, height: 3, minWidth: 3, identifier: 'Rank - User Leaderboard'),
          DashboardItem(width: 8, height: 3, minWidth: 6, identifier: 'Rank - Community Contests'),
          DashboardItem(width: 4, height: 3, minWidth: 3, identifier: 'Rank - Badge Collection'),
          DashboardItem(width: 4, height: 2, minWidth: 3, identifier: 'Rank - XP Progress'),
          DashboardItem(width: 8, height: 3, minWidth: 6, identifier: 'Rank - Weekly Mission'),
          DashboardItem(width: 4, height: 3, minWidth: 3, identifier: 'Rank - Wrixler Rank'),
          DashboardItem(width: 8, height: 3, minWidth: 6, identifier: 'Rank - Sector Rankings'),
          DashboardItem(width: 12, height: 6, minWidth: 6, identifier: 'Rank - Discussion Threads'),
        ];
    }
  }

  void _resetPreset() {
    if (_currentSizeClass == null) return;
    final items = _getItemsForSize(_currentSizeClass!);
    _currentItems = items;
    final newController = DashboardItemController<DashboardItem>(items: items);
    setState(() {
      _controller = newController;
      _visibility.clear();
      _visibility.addEntries(items.map((i) => MapEntry(i.identifier, true)));
    });
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
      _resetPreset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community & Gamification"),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
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
                _controller = DashboardItemController<DashboardItem>(items: _currentItems);
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _controller.isEditing = _isEditing;
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
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (tabIndex) {
          final prefix = _tabs[tabIndex].text!;
          final widgetsToShow = _currentItems.where((w) => w.identifier.startsWith(prefix)).toList();
          return Dashboard<DashboardItem>(
            key: ValueKey('$selectedPreset|$_isEditing|$_currentSizeClass|$tabIndex'),
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
            slotBackgroundBuilder: SlotBackgroundBuilder.withFunction((_, __, ___, ____, _____) => null),
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
                child: Text('Widget $id\n'
                    'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}\n'
                    'w:\${item.layoutData?.width} h:\${item.layoutData?.height}'),
                isEditMode: _isEditing,
                isHidden: isHidden,
                onToggleVisibility: () {
                  setState(() => _visibility[id] = !(_visibility[id] ?? true));
                },
                modalTitle: 'Widget $id',
                modalSize: WidgetModalSize.medium,
              );
            },
          );
        }),
      ),
    );
  }
}
