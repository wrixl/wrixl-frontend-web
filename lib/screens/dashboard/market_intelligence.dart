// lib/screens/dashboard/market_intelligence.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() =>
      _MarketIntelligenceScreenState();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late DashboardItemController<DashboardItem> _controller;
  late List<DashboardItem> _currentItems;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedTabKey = "Insights";
  String selectedPreset = "DefaultInsights";

  final Map<String, List<String>> availablePresets = {
    "Insights": ["DefaultInsights", "AltInsights"],
    "Smart \$": ["DefaultSmart \$", "AltSmart \$"],
    "Signals": ["DefaultSignals", "AltSignals"],
  };

  final List<Tab> _tabs = const [
    Tab(text: 'Insights'),
    Tab(text: 'Smart \$'),
    Tab(text: 'Signals'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      final tab = _tabs[_tabController.index].text!;
      setState(() {
        selectedTabKey = tab;
        selectedPreset = availablePresets[tab]!.first;
        _resetPreset();
      });
    });
    _currentItems = [];
    _controller = DashboardItemController<DashboardItem>(items: []);
  }

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  List<DashboardItem> _getItemsForPreset(String preset) {
    final tab = selectedTabKey;
    final size = _currentSizeClass;
    if (size == null) return [];

    if (tab == "Insights") {
      return [
        DashboardItem(
            width: 12, height: 2, minWidth: 12, identifier: "Filter Bar"),
        DashboardItem(
            width: 8, height: 5, minWidth: 8, identifier: "Unified Feed"),
        DashboardItem(
            width: 4, height: 5, minWidth: 4, identifier: "Live Signal Ticker"),
        DashboardItem(
            width: 12,
            height: 4,
            minWidth: 12,
            identifier: "Capital Flow Sankey"),
      ];
    } else if (tab == "Smart \$") {
      return [
        DashboardItem(
            width: 12,
            height: 4,
            minWidth: 12,
            identifier: "Wallet Leaderboard"),
        DashboardItem(
            width: 4, height: 4, minWidth: 4, identifier: "Wallet Strategy"),
        DashboardItem(
            width: 4, height: 3, minWidth: 4, identifier: "Mirror Strategy"),
        DashboardItem(
            width: 4, height: 4, minWidth: 4, identifier: "Wallet Filters"),
        DashboardItem(
            width: 4, height: 4, minWidth: 4, identifier: "Live Whale Ticker"),
      ];
    } else if (tab == "Signals") {
      return [
        DashboardItem(
            width: 12, height: 4, minWidth: 12, identifier: "Signal Feed"),
        DashboardItem(
            width: 8,
            height: 4,
            minWidth: 8,
            identifier: "Top Gainers / Losers"),
        DashboardItem(
            width: 8, height: 4, minWidth: 8, identifier: "Correlation Matrix"),
        DashboardItem(
            width: 4, height: 4, minWidth: 4, identifier: "Signal Tags"),
      ];
    }

    return [];
  }

  void _resetPreset() {
    if (_currentSizeClass == null) return;
    final items = _getItemsForPreset(selectedPreset);
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
        title: const Text("Market Intelligence"),
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
            items: availablePresets[selectedTabKey]!
                .map((preset) =>
                    DropdownMenuItem(value: preset, child: Text(preset)))
                .toList(),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.lock_open : Icons.lock),
            tooltip: _isEditing ? "Lock Layout" : "Unlock Layout",
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                _controller = DashboardItemController<DashboardItem>(
                    items: _currentItems);
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
        children: List.generate(_tabs.length, (_) {
          return SafeArea(
            child: Dashboard<DashboardItem>(
              key: ValueKey(
                  '$selectedPreset|$_isEditing|$_currentSizeClass|$selectedTabKey'),
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
                    'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}\n'
                    'w:\${item.layoutData?.width} h:\${item.layoutData?.height}',
                    textAlign: TextAlign.center,
                  ),
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(
                        () => _visibility[id] = !(_visibility[id] ?? true));
                  },
                  modalTitle: 'Widget $id',
                  modalSize: WidgetModalSize.medium,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
