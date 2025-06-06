// lib\screens\dashboard\portfolios.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_comparison_radar_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_sidebar_filters.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/strategies/portfolio_tiles_grid.dart';
import '../../utils/responsive.dart';

class PortfoliosScreen extends StatefulWidget {
  const PortfoliosScreen({Key? key}) : super(key: key);

  @override
  State<PortfoliosScreen> createState() => _PortfoliosScreenState();
}

class _PortfoliosScreenState extends State<PortfoliosScreen> {
  final List<String> riskTolerances = [
    "Conservative",
    "Balanced",
    "Aggressive"
  ];
  final List<String> timeframes = ["Short-Term", "Mid-Term", "Long-Term"];
  final List<String> themes = ["AI", "DeFi", "Meme", "NFTs", "Diversified"];

  final Set<String> selectedRisks = {};
  final Set<String> selectedTimeframes = {};
  final Set<String> selectedThemes = {};

  double minAIConfidence = 80;
  double minSharpeRatio = 1.0;
  double minSmartMoneyOverlap = 30;
  bool hideVolatile = false;
  bool showOwnPortfolio = false;

  @override
  void initState() {
    super.initState();
    selectedRisks.add("Aggressive");
    selectedTimeframes.add("Short-Term");
    selectedThemes.add("AI");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bool isMobile = Responsive.isMobile(context);

    final radarData = [
      {"metric": "Risk", "value": 0.7},
      {"metric": "Return", "value": 0.8},
      {"metric": "Sharpe", "value": 1.2},
      {"metric": "Overlap", "value": 0.4},
      {"metric": "AI Score", "value": 0.9},
    ];

    Widget filtersCard = _buildThemedCard(
      context,
      child: PortfolioSidebarFilters(
        riskTolerances: riskTolerances,
        timeframes: timeframes,
        themes: themes,
        selectedRisks: selectedRisks,
        selectedTimeframes: selectedTimeframes,
        selectedThemes: selectedThemes,
        onRiskSelected: (e) => setState(() {
          e.value ? selectedRisks.add(e.key) : selectedRisks.remove(e.key);
        }),
        onTimeframeSelected: (e) => setState(() {
          e.value
              ? selectedTimeframes.add(e.key)
              : selectedTimeframes.remove(e.key);
        }),
        onThemeSelected: (e) => setState(() {
          e.value ? selectedThemes.add(e.key) : selectedThemes.remove(e.key);
        }),
        minAIConfidence: minAIConfidence,
        minSharpeRatio: minSharpeRatio,
        minSmartMoneyOverlap: minSmartMoneyOverlap,
        hideVolatile: hideVolatile,
        onMinAIConfidenceChanged: (v) => setState(() => minAIConfidence = v),
        onMinSharpeRatioChanged: (v) => setState(() => minSharpeRatio = v),
        onMinSmartMoneyOverlapChanged: (v) =>
            setState(() => minSmartMoneyOverlap = v),
        onHideVolatileChanged: (v) => setState(() => hideVolatile = v),
        showModelPortfolios: true,
        onToggle: (_) {},
      ),
    );

    Widget contentColumn = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildThemedCard(
            context,
            child: PortfolioComparisonRadar(),
          ),
          const SizedBox(height: 24),
          _buildThemedCard(
            context,
            child: const PortfolioTilesGrid(),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? scheme.surface,
        elevation: theme.appBarTheme.elevation ?? 0,
        iconTheme: theme.appBarTheme.iconTheme,
        title: Text(
          "Model Portfolios",
          style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        ),
      ),
      body: isMobile
          // single‑column scroll on phones
          ? contentColumn
          // two‑pane on tablet/desktop
          : Row(
              children: [
                // filters on left
                SizedBox(width: 280, child: filtersCard),
                // vertical divider
                VerticalDivider(
                    color: scheme.primary.withOpacity(0.3), width: 1),
                // main content
                Expanded(child: contentColumn),
              ],
            ),
    );
  }

  Widget _buildThemedCard(BuildContext context, {required Widget child}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.primary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}
