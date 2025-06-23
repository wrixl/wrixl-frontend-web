// lib/screens/main_app_screens/my_positions_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

// Widgets
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/portfolio_pulse.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/token_holdings_strip.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/active_strategies_grid.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/drift_meter_radar.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/performance_comparison_strip.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/position_next_best_action.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/positions/simulation_card_grid.dart';

class MyPositionsScreen extends StatefulWidget {
  const MyPositionsScreen({super.key});

  @override
  State<MyPositionsScreen> createState() => _MyPositionsScreenState();
}

class _MyPositionsScreenState extends State<MyPositionsScreen> {
  final String screenId = 'Positions';
  late DashboardScreenController _screenController;
  Future<void>? _initFuture;

  bool _isEditing = false;
  String selectedPreset = 'Default';
  String _filter = 'All';

  final List<String> _filters = ['All', 'Portfolios', 'Mirrored'];
  final List<String> _presets = ['Default', 'Alt', 'Custom'];

  @override
  void initState() {
    super.initState();
    _initFuture = _initController();
  }

  void _syncEditingState() {
    _screenController.controller.isEditing = _isEditing;
  }

  Future<void> _initController() async {
    _screenController = DashboardScreenController(
      screenId: screenId,
      preset: selectedPreset,
      context: context,
      getDefaultItems: _getDefaultItems,
    );
    await _screenController.initialize();
    _syncEditingState();
  }

  List<DashboardItem> _getDefaultItems(DeviceSizeClass sizeClass) {
    return [
      DashboardItem(identifier: 'Token Holdings Strip', width: 12, height: 3, minWidth: 12, startX: 0, startY: 0),
      DashboardItem(identifier: 'Active Strategies Grid', width: 12, height: 9, minWidth: 12, startX: 0, startY: 3),
      DashboardItem(identifier: 'Simulation Card Grid', width: 12, height: 12, minWidth: 12, startX: 0, startY: 12),
      DashboardItem(identifier: 'Portfolio Pulse', width: 4, height: 5, minWidth: 4, startX: 0, startY: 24),
      DashboardItem(identifier: 'Drift Meter Radar', width: 4, height: 5, minWidth: 4, startX: 8, startY: 24),
      DashboardItem(identifier: 'Performance Comparison Strip', width: 4, height: 5, minWidth: 4, startX: 4, startY: 24),
      DashboardItem(identifier: 'Next Best Action', width: 12, height: 3, minWidth: 12, startX: 0, startY: 29),
    ];
  }

  void _cycleFilter() {
    final currentIndex = _filters.indexOf(_filter);
    final nextIndex = (currentIndex + 1) % _filters.length;
    setState(() {
      _filter = _filters[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Unified Positions',
      presets: _presets,
      selectedPreset: selectedPreset,
      isEditing: _isEditing,
      onPresetChanged: (value) async {
        setState(() {
          selectedPreset = value;
          _isEditing = false;
        });
        _initFuture = _initController();
        await _initFuture;
        setState(() {});
      },
      onToggleEditing: () {
        if (selectedPreset != 'Custom') {
          setState(() {
            selectedPreset = 'Custom';
            _isEditing = false;
          });
          _initFuture = _initController();
        } else {
          setState(() {
            _isEditing = !_isEditing;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncEditingState();
          });
        }
      },
      leadingActions: [
        IconButton(
          icon: Icon(
            _filter == 'All'
                ? Icons.layers
                : _filter == 'Portfolios'
                    ? Icons.auto_graph
                    : Icons.wallet,
          ),
          tooltip: 'Filter: $_filter',
          onPressed: _cycleFilter,
        ),
      ],
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Dashboard<DashboardItem>(
              key: ValueKey('$selectedPreset|$_isEditing'),
              dashboardItemController: _screenController.controller,
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
                (_, __, ___, ____, _____) => null,
              ),
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
              itemBuilder: _buildItem,
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(DashboardItem item) {
    final id = item.identifier;
    final isHidden = !_screenController.isVisible(id);
    if (!_isEditing && isHidden) return const SizedBox.shrink();

    Widget child;
    switch (id) {
      case 'Portfolio Pulse':
        child = const PortfolioPulse();
        break;
      case 'Token Holdings Strip':
        child = const TokenHoldingsStrip();
        break;
      case 'Active Strategies Grid':
        child = ActiveStrategiesGrid(strategies: dummyStrategies);
        break;
      case 'Simulation Card Grid':
        child = SimulationCardGrid(strategies: dummySimulations);
        break;
      case 'Drift Meter Radar':
        child = DriftMeterRadar(
          alignmentScore: 72.5,
          driftDirection: 'Risky',
          driftDrivers: dummyDriftDrivers,
        );
        break;
      case 'Performance Comparison Strip':
        child = PerformanceComparisonStrip(
          benchmarks: dummyBenchmarks,
          userPerformance: 4.0,
        );
        break;
      case 'Next Best Action':
        child = PositionNextBestAction(
          action: dummyNextBestAction,
          onAct: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Acting on suggestion...')),
            );
          },
          onSnooze: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Snoozed')),
            );
          },
        );
        break;
      default:
        child = Text(
          'Widget $id\nx:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
          'w:${item.layoutData?.width} h:${item.layoutData?.height}',
          textAlign: TextAlign.center,
        );
    }

    return WidgetCard(
      item: item,
      child: child,
      isEditMode: _isEditing,
      isHidden: isHidden,
      onToggleVisibility: () => setState(() => _screenController.toggleVisibility(id)),
      modalTitle: id,
      modalSize: WidgetModalSize.medium,
      enableCardTap: id != 'Token Holdings Strip' &&
                     id != 'Active Strategies Grid' &&
                     id != 'Simulation Card Grid' &&
                     id != 'Next Best Action',
    );
  }
}