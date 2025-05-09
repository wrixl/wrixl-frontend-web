// lib/screens/dashboard/market_intelligence.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/widgets/common/draggable_card_wrapper.dart';
import 'package:wrixl_frontend/utils/widget_layout_storage.dart';

class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() =>
      _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool isEditMode = false;
  String selectedPreset = "Default";
  Map<String, List<WidgetLayout>> layoutPresets = {};

  final ScrollController _scrollController = ScrollController();

  final List<Tab> _tabs = [
    Tab(text: 'Insights'),
    Tab(text: 'Smart \$'),
    Tab(text: 'Signals'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadPresets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPresets() async {
    final defaultPreset =
        await WidgetLayoutStorage.loadPreset("MarketIntelligence") ??
            _defaultLayout();
    setState(() {
      layoutPresets = {"Default": defaultPreset};
    });
  }

  void toggleEditMode() => setState(() => isEditMode = !isEditMode);

  void toggleVisibility(String id) {
    final layout = _currentLayout().firstWhere((w) => w.id == id);
    setState(() => layout.visible = !layout.visible);
    WidgetLayoutStorage.savePreset("MarketIntelligence", _currentLayout());
  }

  void updateLayout(WidgetLayout updated) {
    final index = _currentLayout().indexWhere((w) => w.id == updated.id);
    if (index != -1) {
      setState(() => _currentLayout()[index] = updated);
      WidgetLayoutStorage.savePreset("MarketIntelligence", _currentLayout());
    }
  }

  List<WidgetLayout> _currentLayout() => layoutPresets[selectedPreset]!;

  void resetPreset() async {
    await WidgetLayoutStorage.deletePreset("MarketIntelligence");
    setState(() {
      layoutPresets["Default"] = _defaultLayout();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (layoutPresets.isEmpty || !layoutPresets.containsKey(selectedPreset)) {
      return const Center(child: CircularProgressIndicator());
    }

    final layoutHelper = LayoutHelper.of(context);
    final visibleWidgets = _currentLayout().where((w) => w.visible).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Intelligence"),
        bottom: TabBar(controller: _tabController, tabs: _tabs),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.lock_open : Icons.lock),
            tooltip: isEditMode ? "Lock Layout" : "Unlock Layout",
            onPressed: toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Preset",
            onPressed: isEditMode ? resetPreset : null,
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final layoutHelper = LayoutHelper.fromDimensions(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        final widgetsToShow = isEditMode
            ? (_currentLayout()
              ..sort((a, b) =>
                  (a.visible == b.visible) ? 0 : (a.visible ? -1 : 1)))
            : _currentLayout().where((w) => w.visible).toList();

        return TabBarView(
          controller: _tabController,
          children: List.generate(_tabs.length, (tabIndex) {
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: LayoutHelper.fixedOuterScreenMargin,
                vertical: 24,
              ),
              child: Wrap(
                spacing: layoutHelper.cardGutter,
                runSpacing: layoutHelper.verticalRowSpacing,
                children: List.generate(widgetsToShow.length, (index) {
                  final layout = widgetsToShow[index];

                  // Filter per tab
                  if (!_isInTab(layout.id, tabIndex))
                    return const SizedBox.shrink();

                  final card = WrixlCard(
                    layout: layout,
                    layoutHelper: layoutHelper,
                    isEditMode: isEditMode,
                    isHidden: !layout.visible,
                    onLayoutChanged: updateLayout,
                    onToggleVisibility: () => toggleVisibility(layout.id),
                    modalTitle: layout.id,
                    child: Text("${layout.id} Placeholder"),
                  );

                  if (!layout.visible && isEditMode) return card;

                  return DraggableCardWrapper(
                    index: index,
                    isEditMode: isEditMode,
                    visibleWidgets: visibleWidgets,
                    onReorder: (from, to) {
                      setState(() {
                        final all = _currentLayout();
                        final visible = all.where((w) => w.visible).toList();

                        final moved = visible.removeAt(from);
                        visible.insert(to, moved);

                        final reordered = [
                          ...visible,
                          ...all.where((w) => !w.visible),
                        ];

                        layoutPresets[selectedPreset] = reordered;
                        WidgetLayoutStorage.savePreset(
                            "MarketIntelligence", reordered);
                      });
                    },
                    child: card,
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }

  bool _isInTab(String id, int tabIndex) {
    final insights = {
      "Filter Bar",
      "Unified Feed",
      "Live Signal Ticker",
      "Capital Flow Sankey"
    };
    final smart = {
      "Wallet Leaderboard",
      "Wallet Strategy",
      "Mirror Strategy",
      "Wallet Filters",
      "Live Whale Ticker"
    };
    final signals = {
      "Signal Feed",
      "Top Gainers / Losers",
      "Correlation Matrix",
      "Signal Tags"
    };
    return switch (tabIndex) {
      0 => insights.contains(id),
      1 => smart.contains(id),
      2 => signals.contains(id),
      _ => false,
    };
  }

  List<WidgetLayout> _defaultLayout() => [
        WidgetLayout(
          id: "Filter Bar",
          visible: true,
          row: 0,
          colStart: 0,
          width: WidgetWidth.threeColumn,
          height: WidgetHeight.short,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Unified Feed",
          visible: true,
          row: 1,
          colStart: 0,
          width: WidgetWidth.twoColumn,
          height: WidgetHeight.tall,
          modalSize: ModalSize.large,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Live Signal Ticker",
          visible: true,
          row: 1,
          colStart: 2,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.tall,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Capital Flow Sankey",
          visible: true,
          row: 2,
          colStart: 0,
          width: WidgetWidth.threeColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.fullscreen,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Wallet Leaderboard",
          visible: true,
          row: 3,
          colStart: 0,
          width: WidgetWidth.threeColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.large,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Wallet Strategy",
          visible: true,
          row: 4,
          colStart: 0,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Mirror Strategy",
          visible: true,
          row: 4,
          colStart: 1,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.short,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Wallet Filters",
          visible: true,
          row: 4,
          colStart: 2,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Live Whale Ticker",
          visible: true,
          row: 5,
          colStart: 0,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Signal Feed",
          visible: true,
          row: 6,
          colStart: 0,
          width: WidgetWidth.threeColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.large,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Top Gainers / Losers",
          visible: true,
          row: 7,
          colStart: 0,
          width: WidgetWidth.twoColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.large,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Correlation Matrix",
          visible: true,
          row: 7,
          colStart: 2,
          width: WidgetWidth.twoColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.large,
          openOnTap: true,
        ),
        WidgetLayout(
          id: "Signal Tags",
          visible: true,
          row: 8,
          colStart: 0,
          width: WidgetWidth.oneColumn,
          height: WidgetHeight.medium,
          modalSize: ModalSize.medium,
          openOnTap: true,
        ),
      ];
}
