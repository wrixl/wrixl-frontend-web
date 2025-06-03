// lib/screens/dashboard/market_intelligence.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';

// Imported widget implementations
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_weather.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_correlation_matrix.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/macro_insights.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/capital_movement_map.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/performance_compare.dart';

import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_feed_insight_cards.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_widget_insights_feeder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_sector_movers_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/market_signals_smart_news_strip_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/signal_feed.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/dashboard_overview_sector_dominance_card.dart';

class MarketIntelligenceScreen2 extends StatefulWidget {
  const MarketIntelligenceScreen2({super.key});

  @override
  State<MarketIntelligenceScreen2> createState() =>
      _MarketIntelligenceScreen2State();
}

class _MarketIntelligenceScreen2State extends State<MarketIntelligenceScreen2>
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
        final fallback = _getItemsForTab(tab, sizeClass);
        return fallback;
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
          {'id': 'Filter Bar', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12},
          {'id': 'Unified Feed', 'x': 0, 'y': 2, 'w': 8, 'h': 5, 'minW': 8},
          {
            'id': 'Narrative Momentum Heatmap',
            'x': 8,
            'y': 2,
            'w': 4,
            'h': 5,
            'minW': 4
          },
          {
            'id': 'Capital Flow Sankey',
            'x': 0,
            'y': 7,
            'w': 12,
            'h': 4,
            'minW': 12
          },
          {'id': 'AI Quick Tip', 'x': 0, 'y': 11, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Market Weather', 'x': 6, 'y': 11, 'w': 4, 'h': 4, 'minW': 4},
          {'id': 'Macro Insights', 'x': 0, 'y': 15, 'w': 12, 'h': 4, 'minW': 4},
          {
            'id': 'Correlation Matrix',
            'x': 0,
            'y': 19,
            'w': 12,
            'h': 5,
            'minW': 4
          },
          {'id': 'Asset Flow', 'x': 0, 'y': 24, 'w': 12, 'h': 4, 'minW': 4},
          {
            'id': 'Performance Compare',
            'x': 0,
            'y': 29,
            'w': 12,
            'h': 4,
            'minW': 4
          },
          {
            'id': 'Sector Dominance',
            'x': 0,
            'y': 33,
            'w': 4,
            'h': 4,
            'minW': 4,
            'minH': 3
          },
        ]);
      case 'Smart Money':
        return createItems([
          {
            'id': 'Wallet Leaderboard',
            'x': 0,
            'y': 0,
            'w': 12,
            'h': 4,
            'minW': 12
          },
          {'id': 'Mirror Strategy', 'x': 0, 'y': 4, 'w': 4, 'h': 3, 'minW': 4},
          {
            'id': 'Wallet Strategy Holdings',
            'x': 4,
            'y': 4,
            'w': 4,
            'h': 4,
            'minW': 4
          },
          {
            'id': 'Wallet Strategy Trades',
            'x': 8,
            'y': 4,
            'w': 4,
            'h': 4,
            'minW': 4
          },
          {
            'id': 'Smart Trades Ticker',
            'x': 0,
            'y': 8,
            'w': 4,
            'h': 4,
            'minW': 4
          },
          {'id': 'Drift vs You', 'x': 4, 'y': 8, 'w': 4, 'h': 4, 'minW': 4},
        ]);
      case 'Signals':
        return createItems([
          {'id': 'Signal Feed', 'x': 0, 'y': 0, 'w': 12, 'h': 4, 'minW': 12},
          {
            'id': 'Top Gainers / Losers',
            'x': 0,
            'y': 4,
            'w': 8,
            'h': 4,
            'minW': 8
          },
          {
            'id': 'My Relevant Alerts',
            'x': 8,
            'y': 4,
            'w': 4,
            'h': 4,
            'minW': 4
          },
          {
            'id': 'Correlation Matrix',
            'x': 0,
            'y': 8,
            'w': 8,
            'h': 4,
            'minW': 8
          },
          {
            'id': 'Playground Strategy Tryout',
            'x': 8,
            'y': 8,
            'w': 4,
            'h': 4,
            'minW': 4
          },
          {
            'id': 'Signal Feed',
            'x': 0,
            'y': 12,
            'w': 12,
            'h': 3,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Smart Money Insight Cards',
            'x': 0,
            'y': 15,
            'w': 10,
            'h': 4,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Smart Money Feed',
            'x': 0,
            'y': 19,
            'w': 6,
            'h': 12,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Sector Movers',
            'x': 0,
            'y': 23,
            'w': 12,
            'h': 6,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Smart News Strip',
            'x': 0,
            'y': 29,
            'w': 12,
            'h': 5,
            'minW': 4,
            'minH': 2
          },
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
              title: 'Market Intelligence - $tabKey',
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
                        final isHidden = !controller.isVisible(id);
                        if (!_isEditing && isHidden)
                          return const SizedBox.shrink();

                        // Inject specific widgets based on identifier
                        Widget resolvedChild;
                        switch (id) {
                          case 'Market Weather':
                            resolvedChild = const MarketWeather();
                            break;
                          case 'Macro Insights':
                            resolvedChild =
                                const MarketSignalsMacroIntelligenceCardsWidget();
                            break;
                          case 'Asset Flow':
                            resolvedChild = const SmartMoneyFeedFlowDiagram();
                            break;
                          case 'Performance Compare':
                            resolvedChild = const PerformanceOverTimeChart();
                            break;
                          case 'Correlation Matrix':
                            resolvedChild = const CorrelationMatrixWidget();
                            break;

                          case 'Signal Feed':
                            resolvedChild = const SignalFeed();
                            break;
                          case 'Insight Cards':
                            resolvedChild = const SmartMoneyFeedInsightCards();
                            break;
                          case 'Insights Feeder':
                            resolvedChild =
                                const SmartMoneyWidgetInsightsFeeder();
                            break;
                          case 'Sector Movers':
                            resolvedChild = MarketSignalsSectorMoversWidget();
                            break;
                          case 'Smart News Strip':
                            resolvedChild = MarketSignalsSmartNewsStripWidget();
                            break;

                          case 'Sector Dominance':
                            resolvedChild = const DynamicSectorDominanceCard();
                            break;

                          default:
                            resolvedChild = Text(
                              'Widget $id\n'
                              'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                              'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                              textAlign: TextAlign.center,
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
                          modalTitle: 'Widget $id',
                          modalSize: WidgetModalSize.medium,
                        );
                      });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
