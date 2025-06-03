// lib\screens\main_app_screens\strategies_screen.dart

import 'package:flutter/material.dart';
import 'package:dashboard/dashboard.dart';
import 'package:wrixl_frontend/utils/device_size_class.dart';
import 'package:wrixl_frontend/utils/dashboard_screen_controller.dart';
import 'package:wrixl_frontend/widgets/common/dashboard_scaffold.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_widget_card.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/ai_recommended_portfolios.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/ai_strategy_builder_prompt.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/backtest_performance_results.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/build_overview_summary.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/compare_portfolio_models.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/featured_portfolio_grid.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/mint_strategy_actions.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/mirrored_wallet_summary.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/mirroring_drift_radar.dart';

// Widgets
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_comparison_radar_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_comparison_to_own_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_sidebar_filters.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_summary_overview.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_tiles_grid.dart';

import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/mirror_strategy_builder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/mirror_suggestion_tile.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/profit_line_chart.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/published_strategy_hall_of_fame.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/risk_&_return_sliders.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/smart_money_ticker.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/smart_wallet_leaderboard.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/token_intelligence_filters.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/top_fit_wallets.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/wallet_tile.dart';

class StrategiesScreen extends StatefulWidget {
  const StrategiesScreen({Key? key}) : super(key: key);

  @override
  State<StrategiesScreen> createState() => _StrategiesScreenState();
}

class _StrategiesScreenState extends State<StrategiesScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _tabKeys = ['Mirror', 'Portfolios', 'Build'];
  late TabController _tabController;
  late String selectedTabKey;
  late String selectedPreset;
  bool _isEditing = false;

  final Map<String, List<String>> availablePresets = {
    'Mirror': ['Default', 'Alt', 'Custom'],
    'Portfolios': ['Default', 'Alt', 'Custom'],
    'Build': ['Default', 'Alt', 'Custom'],
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
      screenId: 'Strategies',
      preset: '${preset}_$tab',
      context: context,
      getDefaultItems: (DeviceSizeClass sizeClass) =>
          _getItemsForTab(tab, sizeClass),
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
      case 'Mirror':
        return createItems([
          {'id': 'Mirrored Wallet Summary', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12}, // was: Mirror Summary Strip
          {'id': 'Smart Wallet Leaderboard', 'x': 0, 'y': 2, 'w': 12, 'h': 4, 'minW': 12}, // was: Wallet Leaderboard
          {'id': 'Smart Money Ticker', 'x': 0, 'y': 6, 'w': 12, 'h': 2, 'minW': 12}, // was: Live Smart Money Ticker
          {'id': 'Top Fit Wallets', 'x': 0, 'y': 8, 'w': 12, 'h': 3, 'minW': 12}, // was: Mirror My Fit Recommender
          {'id': 'Mirroring Drift Radar', 'x': 0, 'y': 11, 'w': 12, 'h': 3, 'minW': 12}, // was: Drift vs You Radar
          {'id': 'Mirror Strategy Composer', 'x': 0, 'y': 14, 'w': 12, 'h': 1, 'minW': 4, 'minH': 1}, // was: Mirror Strategy Builder
          {'id': 'Top Wallet Today', 'x': 0, 'y': 16, 'w': 12, 'h': 5, 'minW': 4, 'minH': 3}, // was: Mirror Suggestion Tile
          {'id': 'Wallet Performance Tracker', 'x': 0, 'y': 21, 'w': 12, 'h': 4, 'minW': 4, 'minH': 3}, // was: Profit Line Chart
          {'id': 'Mirrorable Wallet Explorer', 'x': 0, 'y': 25, 'w': 12, 'h': 6, 'minW': 4, 'minH': 4}, // was: Wallet Tile List
        ]);

      case 'Portfolios':
        return createItems([
          {'id': 'Portfolio Summary Overview', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12}, // was: Portfolios Summary Strip
          {'id': 'AI Recommended Portfolios', 'x': 0, 'y': 2, 'w': 12, 'h': 2, 'minW': 12}, // was: AI Curation Card
          {'id': 'Portfolio Explorer Filters', 'x': 0, 'y': 4, 'w': 12, 'h': 3, 'minW': 12}, // was: Portfolio Filter Bar + Portfolio Filters
          {'id': 'Featured Portfolio Grid', 'x': 0, 'y': 7, 'w': 12, 'h': 5, 'minW': 12}, // was: Model Portfolio Grid
          {'id': 'Compare Portfolio Models', 'x': 0, 'y': 12, 'w': 12, 'h': 4, 'minW': 12}, // was: Compare Models Widget
          {'id': 'Portfolio Metrics Radar', 'x': 0, 'y': 16, 'w': 4, 'h': 3, 'minW': 4, 'minH': 3},
          {'id': 'Compare to My Holdings', 'x': 0, 'y': 19, 'w': 4, 'h': 4, 'minW': 4, 'minH': 2}, // was: Compare to My Portfolio
          {'id': 'Explore All Model Portfolios', 'x': 0, 'y': 23, 'w': 12, 'h': 6, 'minW': 4, 'minH': 3}, // was: Portfolio Strategies
        ]);

      case 'Build':
        return createItems([
          {'id': 'Build Overview Summary', 'x': 0, 'y': 0, 'w': 12, 'h': 2, 'minW': 12}, // was: Build Summary Strip
          {'id': 'AI Strategy Builder Prompt', 'x': 0, 'y': 2, 'w': 12, 'h': 2, 'minW': 12}, // was: Prompt Input AI Builder
          {'id': 'Token Intelligence Filters', 'x': 0, 'y': 4, 'w': 12, 'h': 3, 'minW': 12}, // was: Token Filter Panel
          {'id': 'Risk & Return Sliders', 'x': 0, 'y': 7, 'w': 12, 'h': 2, 'minW': 12}, // was: Risk Return Sliders
          {'id': 'Backtest Performance Results', 'x': 0, 'y': 9, 'w': 12, 'h': 4, 'minW': 12}, // was: Backtest Results Viewer
          {'id': 'Mint Strategy Actions', 'x': 0, 'y': 13, 'w': 12, 'h': 2, 'minW': 12}, // was: Save or Mint Strategy
          {'id': 'Published Strategy Hall of Fame', 'x': 0, 'y': 15, 'w': 12, 'h': 3, 'minW': 12}, // was: Published Strategy Leaderboard
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
          title: const Text("Strategies"),
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
              title: 'Strategies - $tabKey',
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
                        if (!_isEditing && isHidden) return const SizedBox.shrink();

                        Widget resolvedChild;
                        switch (id) {
                          // === Mirror Tab ===
                          case 'Mirrored Wallet Summary':
                            resolvedChild = MirroredWalletSummary();
                            break;

                          case 'Smart Wallet Leaderboard':
                            resolvedChild = SmartWalletLeaderboard();
                            break;

                          case 'Smart Money Ticker':
                            resolvedChild = SmartMoneyTicker();
                            break;

                          case 'Top Fit Wallets':
                            resolvedChild = TopFitWalletsWidget();
                            break;

                          case 'Mirroring Drift Radar':
                            resolvedChild = MirroringDriftRadar();
                            break;

                          case 'Mirror Strategy Composer':
                            resolvedChild = MirrorStrategyBuilder(
                              walletStrategies: ['Conservative', 'Aggressive'],
                              holdingThemes: ['DeFi', 'AI', 'NFT'],
                              selectedStrategy: 'Conservative',
                              selectedTheme: 'DeFi',
                              onStrategyChanged: (_) {},
                              onThemeChanged: (_) {},
                            );
                            break;

                          case 'Top Wallet Today':
                            resolvedChild = MirrorSuggestionTile();
                            break;

                          case 'Wallet Performance Tracker':
                            resolvedChild = const ProfitLineChart();
                            break;

                          case 'Mirrorable Wallet Explorer':
                            resolvedChild = WalletTileListWidget();
                            break;

                          // === Portfolios Tab ===
                          case 'Portfolio Summary Overview':
                            resolvedChild = PortfolioSummaryOverview(
                              name: "AI-Optimized Growth",
                              tags: ["DeFi", "AI", "Moderate Risk"],
                              created: DateTime(2024, 12, 15),
                              sharpe: 2.13,
                              volatility: 0.19,
                              cagr: 0.37,
                              wrxCost: 145.0,
                              mintCount: 82,
                              lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
                              smartOverlap: 0.78,
                              userFit: 0.64,
                              sparklineData: [1.0, 1.02, 1.03, 1.07, 1.1, 1.08, 1.15, 1.22, 1.18, 1.25],
                            );
                            break;

                          case 'AI Recommended Portfolios':
                            resolvedChild = AIRecommendedPortfolios(
                              portfolios: [
                                AIRecommendedPortfolio(
                                  name: "DeFi Momentum",
                                  fitScore: 87.5,
                                  tags: ["DeFi", "Momentum", "Medium Risk"],
                                  sharpe: 2.1,
                                  cagr: 0.35,
                                  wrxCost: 120,
                                  sparkline: [1.0, 1.05, 1.08, 1.12, 1.15, 1.20],
                                ),
                                AIRecommendedPortfolio(
                                  name: "AI Bluechip Blend",
                                  fitScore: 91.2,
                                  tags: ["AI", "Large Cap", "Low Vol"],
                                  sharpe: 2.7,
                                  cagr: 0.29,
                                  wrxCost: 135,
                                  sparkline: [1.0, 1.01, 1.03, 1.06, 1.10, 1.14],
                                ),
                                AIRecommendedPortfolio(
                                  name: "NFT Yield Vaults",
                                  fitScore: 78.4,
                                  tags: ["NFT", "Staking", "Aggressive"],
                                  sharpe: 1.6,
                                  cagr: 0.45,
                                  wrxCost: 95,
                                  sparkline: [1.0, 0.98, 1.02, 1.06, 1.03, 1.09],
                                ),
                              ],
                            );
                            break;


                          case 'Portfolio Explorer Filters':
                            resolvedChild = PortfolioSidebarFilters(
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

                          case 'Featured Portfolio Grid':
                            resolvedChild = FeaturedPortfolioGrid();
                            break;

                          case 'Compare Portfolio Models':
                            resolvedChild = ComparePortfolioModels();
                            break;

                          case 'Portfolio Metrics Radar':
                            resolvedChild = PortfolioComparisonRadar();
                            break;

                          case 'Compare to My Holdings':
                            resolvedChild = const PortfolioComparisonToOwn();
                            break;

                          case 'Explore All Model Portfolios':
                            resolvedChild = const PortfolioTilesGrid();
                            break;

                          // === Build Tab ===
                          case 'Build Overview Summary':
                            resolvedChild = BuildOverviewSummary();
                            break;

                          case 'AI Strategy Builder Prompt':
                            resolvedChild = AIStrategyBuilderPrompt();
                            break;

                          case 'Token Intelligence Filters':
                            resolvedChild = TokenIntelligenceFilters();
                            break;

                          case 'Risk & Return Sliders':
                            resolvedChild = RiskReturnSliders();
                            break;

                          case 'Backtest Performance Results':
                            resolvedChild = BacktestPerformanceResults(
                              isLogScale: false,
                              onToggleScale: () {
                                debugPrint('Log scale toggled (placeholder)');
                              },
                              onReRunBacktest: () {
                                debugPrint('Re-running backtest (placeholder)');
                              },
                            );
                            break;

                          case 'Mint Strategy Actions':
                            resolvedChild = MintStrategyActions();
                            break;

                          case 'Published Strategy Hall of Fame':
                            resolvedChild = PublishedStrategyHallOfFame();
                            break;

                          // === Default fallback ===
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
                      }
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
