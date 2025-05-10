// lib/screens/dashboard/activity_screen.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/layout_constants.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/utils/widget_layout_storage.dart';
import 'package:wrixl_frontend/widgets/common/reusable_widget_layout_card.dart';
import 'package:wrixl_frontend/widgets/common/draggable_card_wrapper.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isEditMode = false;
  Map<String, List<WidgetLayout>> layoutPresets = {};
  late String selectedPreset;
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
      layoutPresets[selectedPreset] = _defaultLayout();
    });
  }

  Future<void> _loadPresets() async {
    final defaultPreset =
        await WidgetLayoutStorage.loadPreset("ActivityDefault");
    setState(() {
      layoutPresets = {
        "ActivityDefault": defaultPreset ?? _defaultLayout(),
      };
      selectedPreset = "ActivityDefault";
    });
  }

  List<WidgetLayout> _defaultLayout() => [
        WidgetLayout(
            id: "notifications",
            visible: true,
            row: 0,
            colStart: 0,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.tall,
            modalSize: ModalSize.large,
            openOnTap: true),
        WidgetLayout(
            id: "transactions",
            visible: true,
            row: 0,
            colStart: 1,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.tall,
            modalSize: ModalSize.large,
            openOnTap: true),
        WidgetLayout(
            id: "events",
            visible: true,
            row: 1,
            colStart: 0,
            width: WidgetWidth.threeColumn,
            height: WidgetHeight.medium,
            modalSize: ModalSize.large,
            openOnTap: true),
        WidgetLayout(
            id: "airdrops",
            visible: true,
            row: 2,
            colStart: 0,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.short,
            modalSize: ModalSize.medium,
            openOnTap: true),
        WidgetLayout(
            id: "alerts",
            visible: true,
            row: 2,
            colStart: 1,
            width: WidgetWidth.onePointFiveColumn,
            height: WidgetHeight.short,
            modalSize: ModalSize.medium,
            openOnTap: true),
      ];

  @override
  Widget build(BuildContext context) {
    if (layoutPresets.isEmpty || !layoutPresets.containsKey(selectedPreset)) {
      return const Center(child: CircularProgressIndicator());
    }

    final layoutHelper = LayoutHelper.of(context);
    final visibleWidgets = _currentLayout().where((w) => w.visible).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity & Alerts'),
        actions: [
          IconButton(
            icon: Icon(isEditMode ? Icons.lock_open : Icons.lock),
            tooltip: isEditMode ? "Lock Layout" : "Unlock Layout",
            onPressed: toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Layout",
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
                  child: Text(layout.id),
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
}
