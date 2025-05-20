// lib\screens\dashboard\portfolios_screen2.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

class PortfoliosScreen2 extends StatefulWidget {
  const PortfoliosScreen2({Key? key}) : super(key: key);

  @override
  State<PortfoliosScreen2> createState() => _PortfoliosScreen2State();
}

enum DeviceSizeClass { mobile, tablet, desktop }

class _PortfoliosScreen2State extends State<PortfoliosScreen2>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late DashboardItemController<DashboardItem> _controller;
  late List<DashboardItem> _currentItems;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedTabKey = "Mine";
  String selectedPreset = "DefaultMine";

  final Map<String, List<String>> availablePresets = {
    "Mine": ["DefaultMine", "AltMine"],
    "Popular": ["DefaultPopular", "AltPopular"],
    "Build": ["DefaultBuild", "AltBuild"],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      final tab = _tabName(_tabController.index);
      setState(() {
        selectedTabKey = tab;
        selectedPreset = availablePresets[tab]!.first;
        _resetPreset();
      });
    });
    _currentItems = [];
    _controller = DashboardItemController<DashboardItem>(items: []);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _tabName(int index) => switch (index) {
        0 => "Mine",
        1 => "Popular",
        2 => "Build",
        _ => "Mine",
      };

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  List<DashboardItem> _getItemsForPreset(String preset) {
    final tab = selectedTabKey;
    final size = _currentSizeClass;
    if (size == null) return [];

    switch (tab) {
      case "Popular":
        return [
          DashboardItem(
              width: 12, height: 2, minWidth: 12, identifier: 'Model Filters'),
          for (int i = 1; i <= 4; i++)
            DashboardItem(
                width: 6,
                height: 3,
                minWidth: 6,
                identifier: 'Model Portfolio $i'),
          DashboardItem(
              width: 12,
              height: 4,
              minWidth: 6,
              identifier: 'Model Comparison'),
          DashboardItem(
              width: 12,
              height: 2,
              minWidth: 6,
              identifier: 'Try Before You Mirror'),
        ];
      case "Build":
        return [
          DashboardItem(
              width: 12, height: 2, minWidth: 12, identifier: 'Prompt Input'),
          DashboardItem(
              width: 12,
              height: 3,
              minWidth: 12,
              identifier: 'Risk & ROI Sliders'),
          DashboardItem(
              width: 12, height: 3, minWidth: 12, identifier: 'Token Filters'),
          DashboardItem(
              width: 12,
              height: 3,
              minWidth: 12,
              identifier: 'Backtest Results'),
          DashboardItem(
              width: 12,
              height: 2,
              minWidth: 12,
              identifier: 'Simulate & Save'),
        ];
      case "Mine":
      default:
        return [
          DashboardItem(
              width: 12,
              height: 2,
              minWidth: 12,
              identifier: 'Portfolio View Filters'),
          DashboardItem(
              width: 4, height: 6, minWidth: 4, identifier: 'Filters'),
          for (int i = 1; i <= 4; i++)
            DashboardItem(
                width: 4, height: 4, minWidth: 4, identifier: 'Portfolio $i'),
          DashboardItem(
              width: 12,
              height: 4,
              minWidth: 6,
              identifier: 'Portfolio Detail'),
          DashboardItem(
              width: 12,
              height: 4,
              minWidth: 6,
              identifier: 'Portfolio Comparison Radar'),
          DashboardItem(
              width: 12,
              height: 2,
              minWidth: 12,
              identifier: 'Create Portfolio'),
        ];
    }
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
        title: const Text('Portfolios'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Mine'),
            Tab(text: 'Popular'),
            Tab(text: 'Build')
          ],
        ),
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
        children: List.generate(3, (_) {
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
