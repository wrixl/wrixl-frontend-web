// lib/screens/dashboard/portfolios_screen2.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/utils/widget_layout_storage.dart';
import 'package:wrixl_frontend/widgets/common/draggable_card_wrapper.dart';

class PortfoliosScreen2 extends StatefulWidget {
  const PortfoliosScreen2({Key? key}) : super(key: key);

  @override
  State<PortfoliosScreen2> createState() => _PortfoliosScreen2State();
}

class _PortfoliosScreen2State extends State<PortfoliosScreen2>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isEditMode = false;
  String selectedTabKey = "Mine";
  Map<String, List<WidgetLayout>> layoutPresets = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabKey = _tabName(_tabController.index);
      });
    });
    _loadPresets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String _tabName(int index) {
    return switch (index) {
      0 => "Mine",
      1 => "Popular",
      2 => "Build",
      _ => "Mine",
    };
  }

  String get selectedPreset => "Default$selectedTabKey";

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

  void resetPreset() async {
    await WidgetLayoutStorage.deletePreset(selectedPreset);
    setState(() {
      layoutPresets[selectedPreset] = _defaultLayoutForTab(selectedTabKey);
    });
  }

  Future<void> _loadPresets() async {
    final mine = await WidgetLayoutStorage.loadPreset("DefaultMine");
    final popular = await WidgetLayoutStorage.loadPreset("DefaultPopular");
    final build = await WidgetLayoutStorage.loadPreset("DefaultBuild");

    setState(() {
      layoutPresets = {
        "DefaultMine": mine ?? _defaultLayoutForTab("Mine"),
        "DefaultPopular": popular ?? _defaultLayoutForTab("Popular"),
        "DefaultBuild": build ?? _defaultLayoutForTab("Build"),
      };
    });
  }

  List<WidgetLayout> _defaultLayoutForTab(String tab) {
    return switch (tab) {
      "Mine" => [
          WidgetLayout(
              id: "Portfolio View Filters",
              visible: true,
              row: 0,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short),
          WidgetLayout(
              id: "Filters",
              visible: true,
              row: 1,
              colStart: 0,
              width: WidgetWidth.oneColumn,
              height: WidgetHeight.tall),
          for (int i = 1; i <= 4; i++)
            WidgetLayout(
                id: "Portfolio $i",
                visible: true,
                row: 1 + i,
                colStart: 0,
                width: WidgetWidth.oneColumn,
                height: WidgetHeight.medium),
          WidgetLayout(
              id: "Portfolio Detail",
              visible: true,
              row: 7,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium,
              modalSize: ModalSize.large),
          WidgetLayout(
              id: "Portfolio Comparison Radar",
              visible: true,
              row: 8,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium,
              modalSize: ModalSize.large),
          WidgetLayout(
              id: "Create Portfolio",
              visible: true,
              row: 9,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short),
        ],
      "Popular" => [
          WidgetLayout(
              id: "Model Filters",
              visible: true,
              row: 0,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short),
          for (int i = 1; i <= 4; i++)
            WidgetLayout(
                id: "Model Portfolio $i",
                visible: true,
                row: i,
                colStart: 0,
                width: WidgetWidth.oneColumn,
                height: WidgetHeight.medium),
          WidgetLayout(
              id: "Model Comparison",
              visible: true,
              row: 6,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium,
              modalSize: ModalSize.fullscreen),
          WidgetLayout(
              id: "Try Before You Mirror",
              visible: true,
              row: 7,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short),
        ],
      "Build" => [
          WidgetLayout(
              id: "Prompt Input",
              visible: true,
              row: 0,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short),
          WidgetLayout(
              id: "Risk & ROI Sliders",
              visible: true,
              row: 1,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium),
          WidgetLayout(
              id: "Token Filters",
              visible: true,
              row: 2,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium),
          WidgetLayout(
              id: "Backtest Results",
              visible: true,
              row: 3,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.medium,
              modalSize: ModalSize.large),
          WidgetLayout(
              id: "Simulate & Save",
              visible: true,
              row: 4,
              colStart: 0,
              width: WidgetWidth.threeColumn,
              height: WidgetHeight.short,
              modalSize: ModalSize.small),
        ],
      _ => [],
    };
  }

  @override
  Widget build(BuildContext context) {
    if (layoutPresets.isEmpty || !layoutPresets.containsKey(selectedPreset)) {
      return const Center(child: CircularProgressIndicator());
    }

    final layoutHelper = LayoutHelper.of(context);
    final visibleWidgets = _currentLayout().where((w) => w.visible).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Portfolios'),
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'Mine'),
          Tab(text: 'Popular'),
          Tab(text: 'Build'),
        ]),
        actions: [
          DropdownButton<String>(
            value: selectedPreset,
            underline: const SizedBox.shrink(),
            onChanged: null,
            items: layoutPresets.keys.map((preset) {
              return DropdownMenuItem(value: preset, child: Text(preset));
            }).toList(),
          ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final layoutHelper = LayoutHelper.fromDimensions(
              constraints.maxWidth, constraints.maxHeight);
          final widgetsToShow = isEditMode
              ? (_currentLayout()
                ..sort((a, b) =>
                    (a.visible == b.visible) ? 0 : (a.visible ? -1 : 1)))
              : _currentLayout().where((w) => w.visible).toList();

          return TabBarView(
            controller: _tabController,
            children: List.generate(3, (index) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                    horizontal: LayoutHelper.fixedOuterScreenMargin,
                    vertical: 24),
                child: Wrap(
                  spacing: layoutHelper.cardGutter,
                  runSpacing: layoutHelper.verticalRowSpacing,
                  children: List.generate(widgetsToShow.length, (i) {
                    final layout = widgetsToShow[i];
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
                      index: i,
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
                            ...all.where((w) => !w.visible)
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
            }),
          );
        },
      ),
    );
  }
}
