// lib/screens/dashboard/dashboard_screen2.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/utils/widget_layout_storage.dart';
import 'package:wrixl_frontend/widgets/common/draggable_card_wrapper.dart';

class DashboardScreen2 extends StatefulWidget {
  const DashboardScreen2({super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {
  bool isEditMode = false;
  late String selectedPreset;
  Map<String, List<WidgetLayout>> layoutPresets = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadPresets();
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

  void resetPreset() async {
    await WidgetLayoutStorage.deletePreset(selectedPreset);
    setState(() {
      layoutPresets[selectedPreset] = switch (selectedPreset) {
        "Trading" => _tradingLayout(),
        "Minimal" => _minimalLayout(),
        _ => _defaultLayout(),
      };
    });
  }

  Future<void> _loadPresets() async {
    final defaultPreset = await WidgetLayoutStorage.loadPreset("Default");
    final tradingPreset = await WidgetLayoutStorage.loadPreset("Trading");
    final minimalPreset = await WidgetLayoutStorage.loadPreset("Minimal");

    setState(() {
      layoutPresets = {
        "Default": defaultPreset ?? _defaultLayout(),
        "Trading": tradingPreset ?? _tradingLayout(),
        "Minimal": minimalPreset ?? _minimalLayout(),
      };
      selectedPreset = "Default";
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Safety guard during async preset loading
    if (layoutPresets.isEmpty || !layoutPresets.containsKey(selectedPreset)) {
      return const Center(child: CircularProgressIndicator());
    }

    final layoutHelper = LayoutHelper.of(context);
    final visibleWidgets = _currentLayout().where((w) => w.visible).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Wrixl Dashboard"),
        actions: [
          DropdownButton<String>(
            value: selectedPreset,
            underline: const SizedBox.shrink(),
            onChanged: isEditMode
                ? null
                : (value) => setState(() => selectedPreset = value!),
            items: layoutPresets.keys.map((preset) {
              return DropdownMenuItem(
                value: preset,
                child: Text(preset),
              );
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
            constraints.maxWidth,
            constraints.maxHeight,
          );

          final widgetsToShow = isEditMode
              ? (_currentLayout()
                ..sort((a, b) =>
                    (a.visible == b.visible) ? 0 : (a.visible ? -1 : 1)))
              : _currentLayout().where((w) => w.visible).toList();

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

                final wrixlCard = WrixlCard(
                  layout: layout,
                  layoutHelper: layoutHelper,
                  isEditMode: isEditMode,
                  isHidden: !layout.visible,
                  onLayoutChanged: updateLayout,
                  onToggleVisibility: () => toggleVisibility(layout.id),
                  modalTitle: layout.id,
                  child: Text("${layout.id}"),
                );

                if (!layout.visible && isEditMode) return wrixlCard;

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
                      WidgetLayoutStorage.savePreset(selectedPreset, reordered);
                    });
                  },
                  child: wrixlCard,
                );
              }),
            ),
          );
        },
      ),
    );
  }

  List<WidgetLayout> _defaultLayout() => [..._coreWidgets()];
  List<WidgetLayout> _tradingLayout() =>
      _coreWidgets().where((w) => w.id != "AI Quick Tip").toList();
  List<WidgetLayout> _minimalLayout() => _coreWidgets()
      .where((w) => w.height.index <= WidgetHeight.medium.index)
      .take(5)
      .toList();

  List<WidgetLayout> _coreWidgets() => [
        WidgetLayout(
            id: "Portfolio Snapshot",
            visible: true,
            row: 0,
            colStart: 0,
            width: WidgetWidth.twoColumn,
            height: WidgetHeight.tall,
            modalSize: ModalSize.large,
            openOnTap: true),
        WidgetLayout(
            id: "Smart Money Drift",
            visible: true,
            row: 0,
            colStart: 2,
            width: WidgetWidth.oneColumn,
            height: WidgetHeight.medium,
            openOnTap: true),
        WidgetLayout(
            id: "AI Quick Tip",
            visible: true,
            row: 1,
            colStart: 2,
            width: WidgetWidth.oneColumn,
            height: WidgetHeight.medium,
            openOnTap: true),
        WidgetLayout(
            id: "Token Allocation",
            visible: true,
            row: 2,
            colStart: 0,
            width: WidgetWidth.twoColumn,
            height: WidgetHeight.moderate,
            modalSize: ModalSize.large,
            openOnTap: true),
        WidgetLayout(
            id: "Stress Radar",
            visible: true,
            row: 2,
            colStart: 2,
            width: WidgetWidth.oneColumn,
            height: WidgetHeight.moderate),
        WidgetLayout(
            id: "Live Ticker",
            visible: true,
            row: 3,
            colStart: 0,
            width: WidgetWidth.threeColumn,
            height: WidgetHeight.short),
        WidgetLayout(
            id: "Model Portfolios",
            visible: true,
            row: 4,
            colStart: 0,
            width: WidgetWidth.twoColumn,
            height: WidgetHeight.medium,
            modalSize: ModalSize.large),
        WidgetLayout(
            id: "Performance Benchmarks",
            visible: true,
            row: 4,
            colStart: 2,
            width: WidgetWidth.oneColumn,
            height: WidgetHeight.medium),
        WidgetLayout(
            id: "Alerts",
            visible: true,
            row: 5,
            colStart: 0,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.medium),
        WidgetLayout(
            id: "Next Best Action",
            visible: true,
            row: 5,
            colStart: 1,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.medium),
        WidgetLayout(
            id: "Wrixler Rank",
            visible: true,
            row: 6,
            colStart: 0,
            width: WidgetWidth.threeColumn,
            height: WidgetHeight.short),
        WidgetLayout(
            id: "Streak Tracker",
            visible: true,
            row: 7,
            colStart: 0,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.medium),
        WidgetLayout(
            id: "Missed Opportunities",
            visible: true,
            row: 7,
            colStart: 1,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.medium),
      ];
}
