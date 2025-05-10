// lib\screens\dashboard\community_game_screen.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/utils/widget_layout_storage.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/widgets/common/draggable_card_wrapper.dart';

class CommunityGameScreen extends StatefulWidget {
  const CommunityGameScreen({Key? key}) : super(key: key);

  @override
  State<CommunityGameScreen> createState() => _CommunityGameScreenState();
}

class _CommunityGameScreenState extends State<CommunityGameScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isEditMode = false;
  final String selectedPreset = "CommunityDefault";
  Map<String, List<WidgetLayout>> layoutPresets = {};

  final List<Tab> _tabs = const [
    Tab(text: 'Predict'),
    Tab(text: 'Vote'),
    Tab(text: 'Earn'),
    Tab(text: 'Rank'),
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadPresets();
  }

  Future<void> _loadPresets() async {
    final defaultPreset = await WidgetLayoutStorage.loadPreset(selectedPreset);
    setState(() {
      layoutPresets = {
        selectedPreset: defaultPreset ?? _defaultLayout(),
      };
    });
  }

  void toggleEditMode() => setState(() => isEditMode = !isEditMode);

  void toggleVisibility(String id) {
    final layout = _currentLayout().firstWhere((w) => w.id == id);
    setState(() => layout.visible = !layout.visible);
    WidgetLayoutStorage.savePreset(selectedPreset, _currentLayout());
  }

  void updateLayout(WidgetLayout updated) {
    final index = _currentLayout().indexWhere((w) => w.id == updated.id);
    if (index != -1) {
      setState(() => _currentLayout()[index] = updated);
      WidgetLayoutStorage.savePreset(selectedPreset, _currentLayout());
    }
  }

  List<WidgetLayout> _currentLayout() => layoutPresets[selectedPreset]!;

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (layoutPresets.isEmpty || !layoutPresets.containsKey(selectedPreset)) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Community & Gamification"),
        elevation: 0,
        bottom: TabBar(controller: _tabController, tabs: _tabs),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.lock_open : Icons.lock),
            tooltip: isEditMode ? "Lock Layout" : "Unlock Layout",
            onPressed: toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Layout",
            onPressed: () async {
              await WidgetLayoutStorage.deletePreset(selectedPreset);
              setState(() {
                layoutPresets[selectedPreset] = _defaultLayout();
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layoutHelper = LayoutHelper.fromDimensions(
              constraints.maxWidth, constraints.maxHeight);
          final allWidgets = _currentLayout();
          final visibleWidgets = allWidgets.where((w) => w.visible).toList();

          return TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              final tabIdPrefix = tab.text!;
              final widgetsToShow = isEditMode
                  ? (allWidgets
                      .where((w) => w.id.startsWith("$tabIdPrefix -"))
                      .toList()
                    ..sort((a, b) => (a.visible == b.visible) ? 0 : (a.visible ? -1 : 1)))
                  : visibleWidgets
                      .where((w) => w.id.startsWith("$tabIdPrefix -"))
                      .toList();

              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: LayoutHelper.fixedOuterScreenMargin,
                    vertical: 24),
                child: Wrap(
                  spacing: layoutHelper.cardGutter,
                  runSpacing: layoutHelper.verticalRowSpacing,
                  children: List.generate(widgetsToShow.length, (index) {
                    final layout = widgetsToShow[index];

                    final wrixlCard = WrixlCard(
                      layout: layout,
                      layoutHelper: layoutHelper,
                      isEditMode: isEditMode,
                      isHidden: !layout.visible,
                      onLayoutChanged: updateLayout,
                      onToggleVisibility: () => toggleVisibility(layout.id),
                      modalTitle: layout.id,
                      child: Text("${layout.id} Placeholder"),
                    );

                    if (!layout.visible && isEditMode) return wrixlCard;

                    return DraggableCardWrapper(
                      index: index,
                      isEditMode: isEditMode,
                      visibleWidgets: visibleWidgets,
                      onReorder: (from, to) {
                        setState(() {
                          final tabWidgets = allWidgets
                              .where((w) =>
                                  w.visible &&
                                  w.id.startsWith("$tabIdPrefix -"))
                              .toList();
                          final moved = tabWidgets.removeAt(from);
                          tabWidgets.insert(to, moved);

                          final reordered = [
                            ...tabWidgets,
                            ...allWidgets.where((w) =>
                                !w.id.startsWith("$tabIdPrefix -") ||
                                !w.visible)
                          ];

                          layoutPresets[selectedPreset] = reordered;
                          WidgetLayoutStorage.savePreset(
                              selectedPreset, reordered);
                        });
                      },
                      child: wrixlCard,
                    );
                  }),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  List<WidgetLayout> _defaultLayout() {
    return [
// Predict Tab
      WidgetLayout(
        id: "Predict - Signal Prediction Market",
        visible: true,
        row: 0,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.large,
            openOnTap: true),
      WidgetLayout(
        id: "Predict - Portfolio Prediction Arena",
        visible: true,
        row: 1,
        colStart: 0,
        width: WidgetWidth.threeColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.fullscreen,
        openOnTap: true),
      // Vote Tab
      WidgetLayout(
        id: "Vote - Signals DAO Voting",
        visible: true,
        row: 0,
        colStart: 0,
        width: WidgetWidth.threeColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.large,
        openOnTap: true),
      WidgetLayout(
        id: "Vote - Signal Curation Submissions",
        visible: true,
        row: 1,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.large,
        openOnTap: true),
      WidgetLayout(
        id: "Vote - Referral Impact",
        visible: true,
        row: 2,
        colStart: 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      // Earn Tab
      WidgetLayout(
        id: "Earn - WRX Rewards Dashboard",
        visible: true,
        row: 0,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.large,
        openOnTap: true),
      WidgetLayout(
        id: "Earn - Rewards Inventory",
        visible: true,
        row: 1,
        colStart: 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Earn - Claimable Perks",
        visible: true,
        row: 2,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.short,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Earn - Impact Score",
        visible: true,
        row: 2,
        colStart: 2,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.short,
        modalSize: ModalSize.medium,
        openOnTap: true),
      // Rank Tab
      WidgetLayout(
        id: "Rank - User Leaderboard",
        visible: true,
        row: 0,
        colStart: 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Community Contests",
        visible: true,
        row: 1,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.large,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Badge Collection",
        visible: true,
        row: 2,
        colStart: 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - XP Progress",
        visible: true,
        row: 2,
        colStart: 1,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.short,
        modalSize: ModalSize.small,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Weekly Mission",
        visible: true,
        row: 3,
        colStart: 0,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.moderate,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Wrixler Rank",
        visible: true,
        row: 4,
        colStart: 0,
        width: WidgetWidth.oneColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Sector Rankings",
        visible: true,
        row: 4,
        colStart: 1,
        width: WidgetWidth.twoColumn,
        height: WidgetHeight.medium,
        modalSize: ModalSize.medium,
        openOnTap: true),
      WidgetLayout(
        id: "Rank - Discussion Threads",
        visible: true,
        row: 5,
        colStart: 0,
        width: WidgetWidth.threeColumn,
        height: WidgetHeight.tall,
        modalSize: ModalSize.fullscreen,
        openOnTap: true),
    ];
  }
}
