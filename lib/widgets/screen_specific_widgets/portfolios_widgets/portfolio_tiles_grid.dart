// lib\widgets\screen_specific_widgets\portfolios_widgets\portfolio_tiles_card.dart

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
  final List<PortfolioTilesGridData> data;

  const PortfolioTilesGrid({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // how many columns?
    final int columns = Responsive.isDesktop(context)
        ? 3
        : Responsive.isTablet(context)
            ? 2
            : 1;

    // tweak these to control height = width / ratio
    final double aspectRatio = columns == 1
        ? 0.75  // mobile: height ≈ width / 0.75  (taller)
        : columns == 2
            ? 0.65  // tablet
            : 0.60; // desktop

    return Column(
      children: [
        // header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Portfolio Strategies",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
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
        ),

        // the grid itself
        GridView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: columns == 1 ? 0 : 16,
            vertical: 8,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) => _PortfolioCard(portfolio: data[index]),
        ),
      ],
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(  // this Column now has enough space
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Based on Your Holdings",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.primary.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                  )),
              IconButton(
                icon: Icon(
                  portfolio.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 20,
                  color: scheme.primary,
                ),
                onPressed: portfolio.onBookmark,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            portfolio.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          Text(
            portfolio.strategyTag,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: scheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _badge("Similarity: ${portfolio.similarityScore}", context),
              const SizedBox(width: 8),
              Expanded(child: _confidenceBar(context, portfolio.confidence)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statBlock("ROI", portfolio.projectedRoi, context)),
              Expanded(child: _statBlock("Volatility", portfolio.volatility, context)),
              Expanded(child: _statBlock("Sharpe", portfolio.sharpe, context)),
            ],
          ),
          _statBlock("Top Holdings", portfolio.topHoldings.join(", "), context),
          _statBlock("Chain", portfolio.dominantChain, context),
          _statBlock("Mix", portfolio.assetTypeMix, context),
          _statBlock("Goal", portfolio.investmentGoal, context),
          Row(
            children: [
              Expanded(child: _statBlock("Since", dateFormatted, context)),
              Expanded(child: _statBlock("Achieved", portfolio.goalAchieved, context)),
              Expanded(child: _statBlock("Horizon", portfolio.horizon, context)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: portfolio.onPreview,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text("Preview", style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: portfolio.onAdopt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text("Adopt", style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
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
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface)),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface.withOpacity(0.6))),
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
