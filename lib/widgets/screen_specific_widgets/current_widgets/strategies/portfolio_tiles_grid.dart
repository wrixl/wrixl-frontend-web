// lib\widgets\screen_specific_widgets\legacy_widgets\portfolio_tiles_grid.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/responsive.dart';

class PortfolioTilesGridData {
  final String name;
  final double confidence;
  final String similarityScore;
  final String projectedRoi;
  final String volatility;
  final String strategyTag;
  final String sharpe;
  final List<String> topHoldings;
  final String dominantChain;
  final String assetTypeMix;
  final DateTime initialRecommendationDate;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onPreview;
  final VoidCallback onAdopt;
  final String investmentGoal;
  final String goalAchieved;
  final String horizon;

  PortfolioTilesGridData({
    required this.name,
    required this.confidence,
    required this.similarityScore,
    required this.projectedRoi,
    required this.volatility,
    required this.strategyTag,
    required this.sharpe,
    required this.topHoldings,
    required this.dominantChain,
    required this.assetTypeMix,
    required this.initialRecommendationDate,
    required this.isBookmarked,
    required this.onBookmark,
    required this.onPreview,
    required this.onAdopt,
    required this.investmentGoal,
    required this.goalAchieved,
    required this.horizon,
  });
}

class PortfolioTilesGrid extends StatelessWidget {
  const PortfolioTilesGrid({super.key});

  static List<PortfolioTilesGridData> _dummyData() => [
        PortfolioTilesGridData(
          name: "AI Growth Engine",
          confidence: 0.95,
          similarityScore: "92%",
          projectedRoi: "+17%",
          volatility: "Low",
          strategyTag: "L2 Focused",
          sharpe: "1.20",
          topHoldings: ["ETH", "OP", "ARB"],
          dominantChain: "Ethereum",
          assetTypeMix: "80% Token / 20% LP",
          initialRecommendationDate: DateTime(2023, 6, 12),
          isBookmarked: false,
          onBookmark: () => debugPrint("Bookmark AI Growth Engine"),
          onPreview: () => debugPrint("Preview AI Growth Engine"),
          onAdopt: () => debugPrint("Adopt AI Growth Engine"),
          investmentGoal: "Growth",
          goalAchieved: "52%",
          horizon: "Mid-Term",
        ),
        PortfolioTilesGridData(
          name: "DeFi Income Fund",
          confidence: 0.92,
          similarityScore: "88%",
          projectedRoi: "+13%",
          volatility: "Medium",
          strategyTag: "Yield Farming",
          sharpe: "1.37",
          topHoldings: ["CRV", "LDO", "CVX"],
          dominantChain: "Optimism",
          assetTypeMix: "70%/30% Token/Stable",
          initialRecommendationDate: DateTime(2023, 5, 9),
          isBookmarked: true,
          onBookmark: () => debugPrint("Bookmark DeFi Income Fund"),
          onPreview: () => debugPrint("Preview DeFi Income Fund"),
          onAdopt: () => debugPrint("Adopt DeFi Income Fund"),
          investmentGoal: "Passive Yield",
          goalAchieved: "36%",
          horizon: "Long-Term",
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = _dummyData();

    final int columns = Responsive.isDesktop(context)
        ? 3
        : Responsive.isTablet(context)
            ? 2
            : 1;

    final double aspectRatio = columns == 1
        ? 0.75
        : columns == 2
            ? 0.65
            : 0.60;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Portfolio Strategies",
                    style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.filter_list, color: scheme.primary),
                      onPressed: () => debugPrint("Filter button pressed"),
                    ),
                    IconButton(
                      icon: Icon(Icons.sort, color: scheme.primary),
                      onPressed: () => debugPrint("Sort button pressed"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: columns == 1 ? 0 : 8,
                vertical: 8,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (context, index) => _PortfolioCard(
                portfolio: data[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final PortfolioTilesGridData portfolio;

  const _PortfolioCard({Key? key, required this.portfolio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateFormatted =
        "${portfolio.initialRecommendationDate.month}/${portfolio.initialRecommendationDate.day}/${portfolio.initialRecommendationDate.year}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Based on Your Holdings",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    )),
                IconButton(
                  icon: Icon(
                    portfolio.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: scheme.primary,
                    size: 20,
                  ),
                  onPressed: portfolio.onBookmark,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(portfolio.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            Text(portfolio.strategyTag,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: scheme.onSurface.withOpacity(0.6),
                )),
            const SizedBox(height: 10),
            Row(
              children: [
                _badge("Similarity: ${portfolio.similarityScore}", context),
                const SizedBox(width: 8),
                Expanded(
                    child: _confidenceBar(context, portfolio.confidence)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _statBlock("ROI", portfolio.projectedRoi, context)),
                Expanded(
                    child: _statBlock(
                        "Volatility", portfolio.volatility, context)),
                Expanded(
                    child: _statBlock("Sharpe", portfolio.sharpe, context)),
              ],
            ),
            _statBlock("Top Holdings",
                portfolio.topHoldings.join(", "), context),
            _statBlock("Chain", portfolio.dominantChain, context),
            _statBlock("Mix", portfolio.assetTypeMix, context),
            _statBlock("Goal", portfolio.investmentGoal, context),
            Row(
              children: [
                Expanded(
                    child: _statBlock("Since", dateFormatted, context)),
                Expanded(
                    child:
                        _statBlock("Achieved", portfolio.goalAchieved, context)),
                Expanded(
                    child:
                        _statBlock("Horizon", portfolio.horizon, context)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: portfolio.onPreview,
                    child: const Text("Preview", style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: portfolio.onAdopt,
                    child: const Text("Adopt", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBlock(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
              )),
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurface.withOpacity(0.6),
              )),
        ],
      ),
    );
  }

  Widget _badge(String text, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _confidenceBar(BuildContext context, double score) {
    final scheme = Theme.of(context).colorScheme;

    return LinearProgressIndicator(
      value: score,
      backgroundColor: scheme.primary.withOpacity(0.25),
      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
      minHeight: 6,
    );
  }
}
