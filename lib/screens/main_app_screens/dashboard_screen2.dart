// lib/screens/dashboard/dashboard_screen2.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

// Current widget imports
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/portfolio_snapshot_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/smart_money_drift_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/ai_quick_tip_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/stress_radar_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/live_ticker_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/performance_benchmarks_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/alerts_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/next_best_action_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/wrixler_rank_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/streak_tracker_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/missed_opportunities_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/dashboard/all_eyes_widget.dart';

class DashboardScreen2 extends StatefulWidget {
  const DashboardScreen2({super.key});

  @override
  State<DashboardScreen2> createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {
  late DashboardScreenController _screenController;
  Future<void>? _initFuture;
  bool _isEditing = false;
  String selectedPreset = 'Default';

  final List<String> presetOptions = ['Default', 'Alt', 'Custom'];

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
      screenId: 'dashboard',
      preset: selectedPreset,
      context: context,
      getDefaultItems: _getItemsForSize,
    );
    await _screenController.initialize();
    _syncEditingState();
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    List<Map<String, dynamic>> baseItems;
    switch (selectedPreset) {
      case 'Alt':
        baseItems = [
          {
            'id': 'Smart Money Drift',
            'x': 0,
            'y': 0,
            'w': 6,
            'h': 4,
            'minW': 5
          },
          {
            'id': 'Portfolio Snapshot',
            'x': 6,
            'y': 0,
            'w': 6,
            'h': 4,
            'minW': 5
          },
          {'id': 'AI Quick Tip', 'x': 0, 'y': 4, 'w': 6, 'h': 2, 'minW': 4},
          {
            'id': 'Performance Benchmarks',
            'x': 6,
            'y': 4,
            'w': 6,
            'h': 3,
            'minW': 6
          },
          {'id': 'Next Best Action', 'x': 0, 'y': 6, 'w': 6, 'h': 3, 'minW': 6},
          {'id': 'Alerts', 'x': 6, 'y': 7, 'w': 6, 'h': 2, 'minW': 6},
        ];
        break;
      default:
        baseItems = [
          {'id': 'Portfolio Snapshot', 'x': 0, 'y': 0, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Performance Benchmarks', 'x': 4, 'y': 0, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'All Eyes', 'x': 8, 'y': 0, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Live Ticker', 'x': 0, 'y': 4, 'w': 12, 'h': 2, 'minW': 6},
          {'id': 'Smart Money Drift', 'x': 0, 'y': 6, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Stress Radar', 'x': 4, 'y': 6, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Next Best Action', 'x': 8, 'y': 6, 'w': 4, 'h': 2, 'minW': 4},
          {'id': 'AI Quick Tip', 'x': 8, 'y': 8, 'w': 4, 'h': 2, 'minW': 4},
          {'id': 'Alerts', 'x': 0, 'y': 10, 'w': 8, 'h': 3, 'minW': 6},
          {'id': 'Wrixler Rank', 'x': 8, 'y': 10, 'w': 4, 'h': 3, 'minW': 4},
          {'id': 'Streak Tracker', 'x': 0, 'y': 13, 'w': 6, 'h': 3, 'minW': 6},
          {'id': 'Missed Opportunities', 'x': 6, 'y': 13, 'w': 6, 'h': 3, 'minW': 6},
        ];
    }
    return baseItems
        .map((config) => DashboardItem(
              identifier: config['id'],
              width: config['w'],
              height: config['h'],
              minWidth: config['minW'],
              minHeight: config['minH'] ?? 1,
              startX: config['x'],
              startY: config['y'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Wrixl Dashboard',
      presets: presetOptions,
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
              itemBuilder: (item) {
                final id = item.identifier;
                final isHidden = !_screenController.isVisible(id);
                if (!_isEditing && isHidden) return const SizedBox.shrink();

                return WidgetCard(
                  item: item,
                  isEditMode: _isEditing,
                  isHidden: isHidden,
                  onToggleVisibility: () {
                    setState(() {
                      _screenController.toggleVisibility(id);
                    });
                  },
                  modalTitle: 'Widget $id',
                  modalSize: WidgetModalSize.medium,
                  child: switch (id) {
                    'Portfolio Snapshot' => const PortfolioSnapshotWidget(),
                    'Smart Money Drift' => const SmartMoneyDriftWidget(),
                    'AI Quick Tip' => const AIQuickTipWidget(),
                    'Stress Radar' => const StressRadarWidget(),
                    'Live Ticker' => const LiveTickerStreamer(),
                    'Performance Benchmarks' =>
                      const PerformanceBenchmarksWidget(),
                    'Alerts' => const AlertsWidget(),
                    'Next Best Action' => const NextBestActionWidget(),
                    'Wrixler Rank' => const WrixlerRankWidget(),
                    'Streak Tracker' => const StreakTrackerWidget(),
                    'All Eyes' => const AllEyesWidget(),
                    'Missed Opportunities' => const MissedOpportunitiesWidget(),
                    _ => Text(
                        'Widget $id\n'
                        'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}\n'
                        'w:\${item.layoutData?.width} h:\${item.layoutData?.height}',
                        textAlign: TextAlign.center,
                      )
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
