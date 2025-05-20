// lib\screens\dashboard\legacy_widgets.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
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

enum DeviceSizeClass { mobile, tablet, desktop }

class _LegacyWidgetsScreenState extends State<LegacyWidgetsScreen> {
  late DashboardItemController<DashboardItem> _controller;
  late List<DashboardItem> _currentItems;
  DeviceSizeClass? _currentSizeClass;
  bool _isEditing = false;
  final Map<String, bool> _visibility = {};
  String selectedPreset = "Default";

  @override
  void initState() {
    super.initState();
    _currentItems = [];
    _controller = DashboardItemController<DashboardItem>(items: []);
  }

  DeviceSizeClass _getSizeClass(BuildContext context) {
    if (Responsive.isMobile(context)) return DeviceSizeClass.mobile;
    if (Responsive.isTablet(context)) return DeviceSizeClass.tablet;
    return DeviceSizeClass.desktop;
  }

  List<DashboardItem> _getItemsForSize(DeviceSizeClass sizeClass) {
    final config = <String, Map<String, int>>{
      'Portfolio Plus': {
        'width': 4,
        'height': 3,
        'minWidth': 4,
        'minHeight': 3
      },
      'Smart Money Drift': {
        'width': 4,
        'height': 3,
        'minWidth': 4,
        'minHeight': 3
      },
      'Market Weather': {
        'width': 4,
        'height': 3,
        'minWidth': 4,
        'minHeight': 2
      },
      'Performance Over Time': {
        'width': 12,
        'height': 6,
        'minWidth': 4,
        'minHeight': 3
      },
      'Sector Dominance': {
        'width': 4,
        'height': 4,
        'minWidth': 4,
        'minHeight': 3
      },
      'Signal Feed': {'width': 12, 'height': 3, 'minWidth': 4, 'minHeight': 3},
      'Portfolio Metrics Radar': {
        'width': 4,
        'height': 3,
        'minWidth': 4,
        'minHeight': 3
      },
      'Compare to My Portfolio': {
        'width': 4,
        'height': 4,
        'minWidth': 4,
        'minHeight': 2
      },
      'Portfolio Filters': {
        'width': 12,
        'height': 3,
        'minWidth': 4,
        'minHeight': 2
      },
      'Portfolio Strategies': {
        'width': 12,
        'height': 6,
        'minWidth': 4,
        'minHeight': 3
      },
      'Live Whale Ticker': {
        'width': 12,
        'height': 2,
        'minWidth': 4,
        'minHeight': 2
      },
      'Smart Money Flow Diagram': {
        'width': 8,
        'height': 4,
        'minWidth': 4,
        'minHeight': 3
      },
      'Smart Money Insight Cards': {
        'width': 10,
        'height': 4,
        'minWidth': 4,
        'minHeight': 3
      },
      'Smart Money Feed': {
        'width': 6,
        'height': 12,
        'minWidth': 4,
        'minHeight': 3
      },
      'Correlation Matrix': {
        'width': 12,
        'height': 8,
        'minWidth': 4,
        'minHeight': 3
      },
      'Macro Intelligence Cards': {
        'width': 12,
        'height': 6,
        'minWidth': 4,
        'minHeight': 3
      },
      'Sector Movers': {
        'width': 12,
        'height': 6,
        'minWidth': 4,
        'minHeight': 3
      },
      'Smart News Strip': {
        'width': 12,
        'height': 5,
        'minWidth': 4,
        'minHeight': 2
      },
      'Mirror Strategy Builder': {
        'width': 12,
        'height': 1,
        'minWidth': 4,
        'minHeight': 1
      },
      'Mirror Suggestion Tile': {
        'width': 12,
        'height': 5,
        'minWidth': 4,
        'minHeight': 3
      },
      'Profit Line Chart': {
        'width': 12,
        'height': 4,
        'minWidth': 4,
        'minHeight': 3
      },
      'Wallet Tile List': {
        'width': 12,
        'height': 5,
        'minWidth': 4,
        'minHeight': 3
      },
    };

    return config.entries.map((entry) {
      final id = entry.key;
      final dims = entry.value;
      return DashboardItem(
        width: dims['width']!,
        height: dims['height']!,
        minWidth: dims['minWidth']!,
        minHeight: dims['minHeight']!,
        identifier: id,
      );
    }).toList();
  }

  void _resetPreset() {
    if (_currentSizeClass == null) return;
    final items = _getItemsForSize(_currentSizeClass!);
    _currentItems = items;
    final newController = DashboardItemController<DashboardItem>(items: items);
    setState(() {
      _controller = newController;
      _visibility
        ..clear()
        ..addEntries(items.map((i) => MapEntry(i.identifier, true)));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.isEditing = _isEditing;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSizeClass = _getSizeClass(context);
    if (_currentSizeClass != newSizeClass) {
      _currentSizeClass = newSizeClass;
      _resetPreset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legacy Widgets'),
        actions: [
          DropdownButton<String>(
            value: selectedPreset,
            underline: const SizedBox.shrink(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedPreset = value;
                _resetPreset();
              });
            },
            items: const [
              DropdownMenuItem(value: "Default", child: Text("Default")),
            ],
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.lock_open : Icons.lock),
            tooltip: _isEditing ? "Lock Layout" : "Unlock Layout",
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                _controller = DashboardItemController<DashboardItem>(
                    items: _currentItems);
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _controller.isEditing = _isEditing;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Preset",
            onPressed: _isEditing ? _resetPreset : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Dashboard<DashboardItem>(
          key: ValueKey('$selectedPreset|$_isEditing|$_currentSizeClass'),
          dashboardItemController: _controller,
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
            final isHidden = !(_visibility[id] ?? true);
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
                  'x:\${item.layoutData?.startX} y:\${item.layoutData?.startY}\n'
                  'w:\${item.layoutData?.width} h:\${item.layoutData?.height}',
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
                setState(() {
                  _visibility[id] = !(_visibility[id] ?? true);
                });
              },
              modalTitle: 'Widget $id',
              modalSize: WidgetModalSize.medium,
            );
          },
        ),
      ),
    );
  }
}
