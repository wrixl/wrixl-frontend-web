// lib/widgets/screen_specific_widgets/legacy_widgets/portfolio_tiles_grid.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/responsive.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

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
  const PortfolioTilesGrid({Key? key}) : super(key: key);

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
            // Header
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
            // Grid of cards
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
              itemBuilder: (context, index) {
                final portfolio = data[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      final date = portfolio.initialRecommendationDate;
                      final formattedDate =
                          "${date.month}/${date.day}/${date.year}";
                      showNewReusableModal(
                        context,
                        title: portfolio.name,
                        size: WidgetModalSize.medium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(portfolio.name,
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: portfolio.topHoldings
                                  .map((h) => Chip(label: Text(h)))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Text("Strategy: ${portfolio.strategyTag}"),
                            Text("Similarity: ${portfolio.similarityScore}"),
                            Text(
                                "Confidence: ${(portfolio.confidence * 100).toStringAsFixed(0)}%"),
                            const SizedBox(height: 8),
                            Text("Projected ROI: ${portfolio.projectedRoi}"),
                            Text("Volatility: ${portfolio.volatility}"),
                            Text("Sharpe Ratio: ${portfolio.sharpe}"),
                            const SizedBox(height: 8),
                            Text("Chain: ${portfolio.dominantChain}"),
                            Text("Asset Mix: ${portfolio.assetTypeMix}"),
                            const SizedBox(height: 8),
                            Text("Recommended on: $formattedDate"),
                            const SizedBox(height: 12),
                            _buildActionButtons(context, portfolio),
                          ],
                        ),
                      );
                    },
                    child: _PortfolioCard(portfolio: portfolio),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, PortfolioTilesGridData p) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: p.onPreview,
            child: const Text("Preview", style: TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: p.onAdopt,
            child: const Text("Adopt", style: TextStyle(fontSize: 12)),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            p.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: scheme.primary,
          ),
          onPressed: p.onBookmark,
        ),
      ],
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final PortfolioTilesGridData portfolio;

  const _PortfolioCard({Key? key, required this.portfolio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = portfolio.initialRecommendationDate;
    final dateFormatted = "${date.month}/${date.day}/${date.year}";

    Widget _stat(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurface)),
            Text(label,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.onSurface.withOpacity(0.6))),
          ],
        );

    Widget _badge(String text) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(text,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)),
        );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Based on Your Holdings",
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: scheme.primary, fontWeight: FontWeight.w600)),
                Icon(
                  portfolio.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: scheme.primary,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(portfolio.name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(portfolio.strategyTag,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurface.withOpacity(0.6))),
            const SizedBox(height: 10),
            Row(
              children: [
                _badge("Similarity: ${portfolio.similarityScore}"),
                const SizedBox(width: 8),
                Expanded(child: LinearProgressIndicator(
                  value: portfolio.confidence,
                  backgroundColor: scheme.primary.withOpacity(0.25),
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                  minHeight: 6,
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _stat("ROI", portfolio.projectedRoi)),
                Expanded(child: _stat("Volatility", portfolio.volatility)),
                Expanded(child: _stat("Sharpe", portfolio.sharpe)),
              ],
            ),
            _stat("Top Holdings", portfolio.topHoldings.join(", ")),
            _stat("Chain", portfolio.dominantChain),
            _stat("Mix", portfolio.assetTypeMix),
            _stat("Goal", portfolio.investmentGoal),
            Row(
              children: [
                Expanded(child: _stat("Since", dateFormatted)),
                Expanded(child: _stat("Achieved", portfolio.goalAchieved)),
                Expanded(child: _stat("Horizon", portfolio.horizon)),
              ],
            ),
            const Spacer(),
            // Footer buttons
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
}
