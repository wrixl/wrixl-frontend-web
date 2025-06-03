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
  final String preset = 'Default';
  late final DashboardScreenController controller;
  late Future<void> _initFuture;
  bool _isEditing = false;
  String _filter = 'All';
  final List<String> _filters = ['All', 'Portfolios', 'Mirrored'];

  @override
  void initState() {
    super.initState();
    controller = DashboardScreenController(
      screenId: screenId,
      preset: preset,
      context: context,
      getDefaultItems: _getDefaultItems,
    );
    _initFuture = controller.initialize();
  }

  List<DashboardItem> _getDefaultItems(DeviceSizeClass sizeClass) {
    return [
      DashboardItem(
          identifier: 'Token Holdings Strip',
          width: 12,
          height: 2,
          minWidth: 12,
          startX: 0,
          startY: 0),
      DashboardItem(
          identifier: 'Active Strategies Grid',
          width: 12,
          height: 5,
          minWidth: 12,
          startX: 0,
          startY: 2),
      DashboardItem(
          identifier: 'Simulation Card Grid',
          width: 12,
          height: 4,
          minWidth: 12,
          startX: 0,
          startY: 7),
      DashboardItem(
          identifier: 'Portfolio Pulse',
          width: 6,
          height: 3,
          minWidth: 6,
          startX: 0,
          startY: 11),
      DashboardItem(
          identifier: 'Drift Meter Radar',
          width: 6,
          height: 3,
          minWidth: 6,
          startX: 6,
          startY: 11),
      DashboardItem(
          identifier: 'Performance Comparison Strip',
          width: 12,
          height: 2,
          minWidth: 12,
          startX: 0,
          startY: 14),
      DashboardItem(
          identifier: 'Next Best Action',
          width: 12,
          height: 2,
          minWidth: 12,
          startX: 0,
          startY: 16),
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
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return DashboardScaffold(
          title: 'Unified Positions',
          presets: ['Default', 'Alt', 'Custom'],
          selectedPreset: preset,
          isEditing: _isEditing,
          onPresetChanged: (_) {},
          onToggleEditing: () {
            setState(() {
              if (preset != 'Custom') {
                _isEditing = false;
              } else {
                _isEditing = !_isEditing;
              }
              controller.controller.isEditing = _isEditing;
            });
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
          child: Dashboard<DashboardItem>(
              dashboardItemController: controller.controller,
              slotCount: 12,
              slotAspectRatio: 1,
              horizontalSpace: 40,
              verticalSpace: 40,
              padding: const EdgeInsets.all(16),
              editModeSettings: EditModeSettings(),
              itemBuilder: (item) {
                final id = item.identifier;
                final isHidden = !controller.isVisible(id);
                if (!_isEditing && isHidden) return const SizedBox.shrink();

                late final Widget child;
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
                        // Future: route to portfolio rebalancer or open modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Acting on suggestion...')),
                        );
                      },
                      onSnooze: () {
                        // Future: mark this action as snoozed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Snoozed')),
                        );
                      },
                    );
                    break;
                  default:
                    child = Text(
                      'Widget $id\n'
                      'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                      'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                      textAlign: TextAlign.center,
                    );
                }

                return WidgetCard(
                  item: item,
                  child: child,
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(() => controller.toggleVisibility(id));
                  },
                  modalTitle: id,
                  modalSize: WidgetModalSize.medium,
                );
              }),
        );
      },
    );
  }
}
