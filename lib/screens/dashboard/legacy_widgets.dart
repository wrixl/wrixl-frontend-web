// Refactored LegacyWidgetsScreen using modern dashboard scaffold

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/portfolio_pulse.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/smart_money_feed_widgets/smart_money_drift.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/market_weather.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/dashboard_overview_sector_dominance_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/dashboard_overview_line_graph.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/portfolios_widgets/portfolio_comparison_radar_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/portfolios_widgets/portfolio_comparison_to_own_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/portfolios_widgets/portfolio_sidebar_filters.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/portfolios_widgets/portfolio_tiles_grid.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/live_ticker.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/smart_money_feed_widgets/smart_money_feed_flow_diagram.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/smart_money_feed_widgets/smart_money_feed_insight_cards.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/smart_money_feed_widgets/smart_money_widget_insights_feeder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/market_signals_widgets/market_signals_correlation_matrix.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/market_signals_widgets/market_signals_macro_intelligence_cards_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/market_signals_widgets/market_signals_sector_movers_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/market_signals_widgets/market_signals_smart_news_strip_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/miror_insights_widgets/mirror_strategy_builder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/miror_insights_widgets/mirror_suggestion_tile.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/miror_insights_widgets/profit_line_chart.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/miror_insights_widgets/wallet_tile.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/legacy_widgets/dashboard_overview_widgets/signal_feed.dart';

class LegacyWidgetsScreen extends StatefulWidget {
  const LegacyWidgetsScreen({super.key});

  @override
  State<LegacyWidgetsScreen> createState() => _LegacyWidgetsScreenState();
}

class _LegacyWidgetsScreenState extends State<LegacyWidgetsScreen> {
  late DashboardScreenController _controller;
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
    _controller.controller.isEditing = _isEditing;
  }

  Future<void> _initController() async {
    _controller = DashboardScreenController(
      screenId: 'legacy_widgets',
      preset: selectedPreset,
      context: context,
      getDefaultItems: _getItemsForSize,
    );
    await _controller.initialize();
    _syncEditingState();
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    List<DashboardItem> createItems(List<Map<String, dynamic>> configs) {
      return configs
          .map((c) => DashboardItem(
                identifier: c['id'],
                width: c['w'],
                height: c['h'],
                minWidth: c['minW'],
                minHeight: c['minH'],
                startX: c['x'] ?? 0,
                startY: c['y'] ?? 0,
              ))
          .toList();
    }

    switch (selectedPreset) {
      case 'Alt':
        return createItems([
          {'id': 'Smart News Strip', 'w': 12, 'h': 5, 'minW': 4, 'minH': 2},
          {'id': 'Smart Money Drift', 'w': 4, 'h': 3, 'minW': 4, 'minH': 3},
          {'id': 'Correlation Matrix', 'w': 12, 'h': 8, 'minW': 4, 'minH': 3},
        ]);
      default:
        return createItems([
          {'id': 'Portfolio Plus', 'w': 4, 'h': 3, 'minW': 4, 'minH': 3},
          {'id': 'Smart Money Drift', 'w': 4, 'h': 3, 'minW': 4, 'minH': 3},
          {'id': 'Market Weather', 'w': 4, 'h': 3, 'minW': 4, 'minH': 2},
          {
            'id': 'Performance Over Time',
            'w': 12,
            'h': 6,
            'minW': 4,
            'minH': 3
          },
          {'id': 'Sector Dominance', 'w': 4, 'h': 4, 'minW': 4, 'minH': 3},
          {'id': 'Signal Feed', 'w': 12, 'h': 3, 'minW': 4, 'minH': 3},
          {
            'id': 'Portfolio Metrics Radar',
            'w': 4,
            'h': 3,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Compare to My Portfolio',
            'w': 4,
            'h': 4,
            'minW': 4,
            'minH': 2
          },
          {'id': 'Portfolio Filters', 'w': 12, 'h': 3, 'minW': 4, 'minH': 2},
          {'id': 'Portfolio Strategies', 'w': 12, 'h': 6, 'minW': 4, 'minH': 3},
          {'id': 'Live Whale Ticker', 'w': 12, 'h': 2, 'minW': 4, 'minH': 2},
          {
            'id': 'Smart Money Flow Diagram',
            'w': 8,
            'h': 4,
            'minW': 4,
            'minH': 3
          },
          {
            'id': 'Smart Money Insight Cards',
            'w': 10,
            'h': 4,
            'minW': 4,
            'minH': 3
          },
          {'id': 'Smart Money Feed', 'w': 6, 'h': 12, 'minW': 4, 'minH': 3},
          {'id': 'Correlation Matrix', 'w': 12, 'h': 8, 'minW': 4, 'minH': 3},
          {
            'id': 'Macro Intelligence Cards',
            'w': 12,
            'h': 6,
            'minW': 4,
            'minH': 3
          },
          {'id': 'Sector Movers', 'w': 12, 'h': 6, 'minW': 4, 'minH': 3},
          {'id': 'Smart News Strip', 'w': 12, 'h': 5, 'minW': 4, 'minH': 2},
          {
            'id': 'Mirror Strategy Builder',
            'w': 12,
            'h': 1,
            'minW': 4,
            'minH': 1
          },
          {
            'id': 'Mirror Suggestion Tile',
            'w': 12,
            'h': 5,
            'minW': 4,
            'minH': 3
          },
          {'id': 'Profit Line Chart', 'w': 12, 'h': 4, 'minW': 4, 'minH': 3},
          {'id': 'Wallet Tile List', 'w': 12, 'h': 5, 'minW': 4, 'minH': 3},
        ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      title: 'Legacy Widgets',
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
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _syncEditingState());
        }
      },
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Dashboard<DashboardItem>(
            key: ValueKey('$selectedPreset|$_isEditing'),
            dashboardItemController: _controller.controller,
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
              final isHidden = !_controller.isVisible(id);
              if (!_isEditing && isHidden) return const SizedBox.shrink();

              Widget child;
              switch (id) {
                case 'Portfolio Plus':
                  child = const PortfolioPulse();
                  break;
                case 'Smart Money Drift':
                  child = const SmartMoneyDrift();
                  break;
                case 'Market Weather':
                  child = const MarketWeather();
                  break;
                case 'Performance Over Time':
                  child = const PerformanceOverTimeChart();
                  break;
                case 'Sector Dominance':
                  child = const DynamicSectorDominanceCard();
                  break;
                case 'Signal Feed':
                  child = const SignalFeed();
                  break;
                case 'Portfolio Metrics Radar':
                  child = PortfolioComparisonRadar();
                  break;
                case 'Compare to My Portfolio':
                  child = const PortfolioComparisonToOwn();
                  break;
                case 'Portfolio Filters':
                  child = PortfolioSidebarFilters(
                    riskTolerances: const ['Low', 'Medium', 'High'],
                    timeframes: const ['1M', '3M', '6M'],
                    themes: const ['DeFi', 'AI', 'NFT'],
                    selectedRisks: {},
                    selectedTimeframes: {},
                    selectedThemes: {},
                    onRiskSelected: (_) {},
                    onTimeframeSelected: (_) {},
                    onThemeSelected: (_) {},
                    minAIConfidence: 70,
                    minSharpeRatio: 1.5,
                    minSmartMoneyOverlap: 20,
                    hideVolatile: false,
                    onMinAIConfidenceChanged: (_) {},
                    onMinSharpeRatioChanged: (_) {},
                    onMinSmartMoneyOverlapChanged: (_) {},
                    onHideVolatileChanged: (_) {},
                    showModelPortfolios: true,
                    onToggle: (_) {},
                  );
                  break;
                case 'Portfolio Strategies':
                  child = const PortfolioTilesGrid();
                  break;
                case 'Live Whale Ticker':
                  child = const LiveWhaleTicker();
                  break;
                case 'Smart Money Flow Diagram':
                  child = const SmartMoneyFeedFlowDiagram();
                  break;
                case 'Smart Money Insight Cards':
                  child = const SmartMoneyFeedInsightCards();
                  break;
                case 'Smart Money Feed':
                  child = const SmartMoneyWidgetInsightsFeeder();
                  break;
                case 'Correlation Matrix':
                  child = CorrelationMatrixWidget();
                  break;
                case 'Macro Intelligence Cards':
                  child = MarketSignalsMacroIntelligenceCardsWidget();
                  break;
                case 'Sector Movers':
                  child = MarketSignalsSectorMoversWidget();
                  break;
                case 'Smart News Strip':
                  child = MarketSignalsSmartNewsStripWidget();
                  break;
                case 'Mirror Strategy Builder':
                  child = MirrorStrategyBuilder(
                    walletStrategies: ['Conservative', 'Aggressive'],
                    holdingThemes: ['DeFi', 'AI', 'NFT'],
                    selectedStrategy: 'Conservative',
                    selectedTheme: 'DeFi',
                    onStrategyChanged: (_) {},
                    onThemeChanged: (_) {},
                  );
                  break;
                case 'Mirror Suggestion Tile':
                  child = MirrorSuggestionTile();
                  break;
                case 'Profit Line Chart':
                  child = const ProfitLineChart();
                  break;
                case 'Wallet Tile List':
                  child = WalletTileListWidget();
                  break;
                default:
                  child = Text(
                    'Widget $id\n'
                    'x:${item.layoutData?.startX} y:${item.layoutData?.startY}\n'
                    'w:${item.layoutData?.width} h:${item.layoutData?.height}',
                    textAlign: TextAlign.center,
                  );
                  break;
              }

              return WidgetCard(
                item: item,
                child: child,
                isEditMode: _isEditing,
                isHidden: isHidden,
                onToggleVisibility: () {
                  setState(() => _controller.toggleVisibility(id));
                },
                modalTitle: 'Widget $id',
                modalSize: WidgetModalSize.medium,
              );
            },
          );
        },
      ),
    );
  }
}
