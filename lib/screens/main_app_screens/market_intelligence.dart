// lib/screens/dashboard/market_intelligence.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/anomaly_map.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/my_relevant_alerts.dart';

// widgets
// Trends
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/narrative_filter.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/narrative_intelligence_feed.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/narrative_momentum_heatmap.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/signal_accuracy_leaderboard.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/todays_intelligence_summary.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_weather.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/performance_compare.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/macro_insights.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_correlation_matrix.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/narrative_velocity_tracker.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/stablecoin_flow.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/alts_vs_btc_dominance.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/capital_movement_map.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/top_gainers_losers.dart';

// Smart Money
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/wallet_leaderboard.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/mirror_strategy.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/wallet_strategy_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/conviction_radar.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/drift_vs_you.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/wallet_clusters.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/rotations_map.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_trades_ticker.dart';

// Signals

import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_feed_insight_cards.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_widget_insights_feeder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_sector_movers_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_smart_news_strip_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/signal_feed.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/whale_alerts_timeline.dart';




class MarketIntelligenceScreen extends StatefulWidget {
  const MarketIntelligenceScreen({super.key});

  @override
  State<MarketIntelligenceScreen> createState() =>
      _MarketIntelligenceScreenState();
}

class _MarketIntelligenceScreenState extends State<MarketIntelligenceScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['Trends', 'Smart Money', 'Signals'];
  late TabController _tabController;
  late String selectedTabKey;
  late String selectedPreset;
  bool _isEditing = false;

  final Map<String, List<String>> availablePresets = {
    'Trends': ['Default', 'Alt', 'Custom'],
    'Smart Money': ['Default', 'Alt', 'Custom'],
    'Signals': ['Default', 'Alt', 'Custom'],
  };

  final Map<String, DashboardScreenController> _controllers = {};
  final Map<String, Future<void>> _initFutures = {};

  @override
  void initState() {
    super.initState();
    selectedTabKey = _tabKeys[0];
    selectedPreset = 'Default';
    _tabController = TabController(length: _tabKeys.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _initializeController(selectedTabKey, selectedPreset);
  }

  void _onTabChanged() {
    final newTab = _tabKeys[_tabController.index];
    setState(() {
      selectedTabKey = newTab;
      selectedPreset = 'Default';
    });
    _initializeController(newTab, selectedPreset);
  }

  void _syncEditingState() {
    _controllers[selectedTabKey]?.controller.isEditing = _isEditing;
  }

  Future<void> _initializeController(String tab, String preset) async {
    final controller = DashboardScreenController(
      screenId: 'market_intelligence',
      preset: '${preset}_$tab',
      context: context,
      getDefaultItems: (DeviceSizeClass sizeClass) {
        return _getItemsForTab(tab, sizeClass);
      },
    );
    _controllers[tab] = controller;
    _initFutures[tab] =
        controller.initialize().then((_) => _syncEditingState());
    setState(() {});
  }

  List<DashboardItem> _getItemsForTab(String tab, DeviceSizeClass sizeClass) {
    List<DashboardItem> createItems(List<Map<String, dynamic>> configs) {
      return configs
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

    switch (tab) {
      case 'Trends':
        return createItems([
          {'id': 'Narrative Filter', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12},
          {'id': 'Narrative Intelligence Feed', 'x': 0, 'y': 2, 'w': 8, 'h': 5,'minW': 8},
          {'id': 'Narrative Momentum Heatmap', 'x': 8, 'y': 2, 'w': 4, 'h': 5, 'minW': 4},
          {'id': 'Capital Movement Map', 'x': 0, 'y': 7, 'w': 12, 'h': 4, 'minW': 12},
          {'id': 'Today\'s Intelligence Summary', 'x': 0, 'y': 11, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Market Weather', 'x': 4, 'y': 11, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Compare Intelligence', 'x': 0, 'y': 15, 'w': 4, 'h': 4, 'minW': 4},          
          {'id': 'Macro Insights', 'x': 0, 'y': 19, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Correlation Matrix', 'x': 0, 'y': 23, 'w': 12, 'h': 5, 'minW': 4},
          {'id': 'Narrative Velocity Tracker', 'x': 0, 'y': 28, 'w': 6, 'h': 4, 'minW': 4},
          {'id': 'Stablecoin Flow', 'x': 6, 'y': 32, 'w': 6, 'h': 4, 'minW': 4},
          {'id': 'ETH vs BTC Dominance', 'x': 0, 'y': 36, 'w': 12, 'h': 4, 'minW': 4},
        ]);
      case 'Smart Money':
        return createItems([
          {'id': 'Wallet Leaderboard', 'x': 0, 'y': 0, 'w': 12, 'h': 4, 'minW': 12},
          {'id': 'Mirror Strategy', 'x': 0, 'y': 4, 'w': 4, 'h': 3, 'minW': 4},
          {'id': 'Wallet Strategy Card', 'x': 4, 'y': 4, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Smart Trades Ticker', 'x': 8, 'y': 4, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Drift vs You', 'x': 0, 'y': 8, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Wallet Clusters', 'x': 4, 'y': 8, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Rotations Map', 'x': 8, 'y': 8, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Conviction Radar', 'x': 0, 'y': 12, 'w': 12, 'h': 4, 'minW': 4},
        ]);
      case 'Signals':
        return createItems([
          {'id': 'Signal Feed', 'x': 0, 'y': 0, 'w': 12, 'h': 4,'minW': 12},
          {'id': 'Top Gainers / Losers', 'x': 0, 'y': 4, 'w': 6, 'h': 4, 'minW': 6},
          {'id': 'My Relevant Alerts', 'x': 6, 'y': 4, 'w': 6, 'h': 4,'minW': 6},
          {'id': 'Correlation Matrix', 'x': 0, 'y': 8, 'w': 12, 'h': 4, 'minW': 8},
          {'id': 'Whale Alerts Timeline', 'x': 0, 'y': 12, 'w': 6, 'h': 4, 'minW': 4},
          {'id': 'Anomaly Map','x': 6, 'y': 12, 'w': 6, 'h': 4, 'minW': 4},
          {'id': 'Sector Movers', 'x': 0, 'y': 16, 'w': 12, 'h': 4, 'minW': 4},
          {'id': 'Signal Accuracy Leaderboard', 'x': 0, 'y': 20, 'w': 12, 'h': 4, 'minW': 4},
          {'id': 'Smart News Strip','x': 0, 'y': 24, 'w': 12, 'h': 4, 'minW': 4},
        ]);
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabKeys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Market Intelligence"),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabKeys.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabKeys.map((tabKey) {
            final controller = _controllers[tabKey];
            final future = _initFutures[tabKey];
            final presets = availablePresets[tabKey]!;

            if (controller == null || future == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return DashboardScaffold(
              title: 'Market Intelligence • $tabKey',
              presets: presets,
              selectedPreset: selectedPreset,
              isEditing: _isEditing,
              onPresetChanged: (val) async {
                setState(() {
                  selectedPreset = val;
                  _isEditing = false;
                });
                await _initializeController(tabKey, val);
              },
              onToggleEditing: () {
                if (selectedPreset != 'Custom') {
                  setState(() {
                    selectedPreset = 'Custom';
                    _isEditing = false;
                  });
                  _initializeController(tabKey, selectedPreset);
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
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Dashboard<DashboardItem>(
                    key: ValueKey('$tabKey|$selectedPreset|$_isEditing'),
                    dashboardItemController: controller.controller,
                    slotCount: 12,
                    slotAspectRatio: 1,
                    horizontalSpace: 32,
                    verticalSpace: 32,
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
                      resizeCursorSide: 8,
                      backgroundStyle: EditModeBackgroundStyle(
                        lineColor: Colors.grey,
                        lineWidth: 0.5,
                        dualLineHorizontal: true,
                        dualLineVertical: true,
                      ),
                    ),
                    itemBuilder: (item) {
                      final id = item.identifier;
                      final isHidden = !controller.isVisible(id);
                      if (!_isEditing && isHidden) {
                        return const SizedBox.shrink();
                      }

                      Widget resolvedChild;
                      switch (id) {
                        // Trends Tab
                        case 'Narrative Filter':
                          resolvedChild = NarrativeFilterWidget(
                            onFilterChanged: (filters) {
                              // TODO: hook into state/store/context later
                              debugPrint("Selected filters: $filters");
                            },
                          );
                          break;
                        case 'Narrative Intelligence Feed':
                          resolvedChild = const NarrativeIntelligenceFeed();
                          break;
                        case 'Narrative Momentum Heatmap':
                          resolvedChild = const NarrativeMomentumHeatmap();
                          break;
                        case 'Capital Movement Map':
                          resolvedChild = const SmartMoneyFeedFlowDiagram();
                          break;
                        case 'Today\'s Intelligence Summary':
                          resolvedChild = const TodaysIntelligenceSummary();
                          break;
                        case 'Market Weather':
                          resolvedChild = const MarketWeather();
                          break;
                        case 'Compare Intelligence':
                          resolvedChild = const PerformanceOverTimeChart();
                          break;
                        case 'Macro Insights':
                          resolvedChild = const MarketSignalsMacroIntelligenceCardsWidget();
                          break;
                        case 'Correlation Matrix':
                          resolvedChild = const CorrelationMatrixWidget();
                          break;
                        case 'Narrative Velocity Tracker':
                          resolvedChild = const NarrativeVelocityTracker();
                          break;
                        case 'Stablecoin Flow':
                          resolvedChild = const StablecoinFlowWidget();
                          break;
                        case 'ETH vs BTC Dominance':
                          resolvedChild = const AltsVsBTCDominanceWidget();
                          break;

                        // Smart Money Tab
                        case 'Wallet Leaderboard':
                          resolvedChild = const WalletLeaderboardWidget();
                          break;
                        case 'Mirror Strategy':
                          resolvedChild = const MirrorStrategyWidget(walletAlias: "TopVC_01");
                          break;
                        case 'Wallet Strategy Card':
                          resolvedChild = const WalletStrategyCard(
                            walletAlias: 'TopVC_01',
                            walletType: 'VC',
                            rankDelta: 4.5,
                          );
                          break;
                        case 'Drift vs You':
                          resolvedChild = const DriftVsYouWidget();
                          break;
                        case 'Wallet Clusters':
                          resolvedChild = const WalletClustersWidget();
                          break;
                        case 'Rotations Map':
                          resolvedChild = const RotationsMapWidget();
                          break;
                        case 'Conviction Radar':
                          resolvedChild = const ConvictionRadarWidget();
                          break;
                        case 'Smart Trades Ticker':
                          resolvedChild = const SmartTradesTickerWidget();
                          break;                               

                        // Signals Tab
                        case 'Signal Feed':
                          resolvedChild = const SignalFeed();
                          break;
                        case 'Top Gainers / Losers':
                          resolvedChild = const TopGainersLosersWidget();
                          break;
                        case 'My Relevant Alerts':
                          resolvedChild = const MyRelevantAlertsWidget();
                          break;
                        case 'Whale Alerts Timeline':
                          resolvedChild = const WhaleAlertsTimelineWidget();
                          break; 
                        case 'Anomaly Map':
                          resolvedChild = AnomalyMapWidget();
                          break;
                        case 'Sector Movers':
                          resolvedChild = MarketSignalsSectorMoversWidget();
                          break;                                                                                                                                 
                        case 'Signal Accuracy Leaderboard':
                          resolvedChild = SignalAccuracyLeaderboard();
                          break;
                        case 'Smart News Strip':
                          resolvedChild =
                              MarketSignalsSmartNewsStripWidget();
                          break;

                        // For any new or placeholder widgets, show generic text
                        default:
                          resolvedChild = Center(
                            child: Text(
                              id,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          );
                      }

                      return WidgetCard(
                        item: item,
                        child: resolvedChild,
                        isEditMode: _isEditing,
                        isHidden: isHidden,
                        onToggleVisibility: () {
                          setState(() => controller.toggleVisibility(id));
                        },
                        modalTitle: id,
                        modalSize: WidgetModalSize.medium,
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
