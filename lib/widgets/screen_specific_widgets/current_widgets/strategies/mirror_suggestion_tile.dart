// lib\widgets\screen_specific_widgets\miror_insights_widgets\mirror_suggestion_tile.dart

import 'package:flutter/material.dart';

class MirrorSuggestionData {
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

  MirrorSuggestionData({
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

class MirrorSuggestionTile extends StatelessWidget {
  const MirrorSuggestionTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MirrorSuggestionData> suggestions = _demoSuggestions;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      color: scheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// App bar-style section title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suggested Strategies",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.auto_graph_rounded, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            /// Horizontal scrollable cards
            SizedBox(
              height: 500,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 4),
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) =>
                    _MirrorSuggestionTileCard(data: suggestions[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MirrorSuggestionTileCard extends StatelessWidget {
  final MirrorSuggestionData data;

  const _MirrorSuggestionTileCard({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateFormatted =
        "${data.initialRecommendationDate.month}/${data.initialRecommendationDate.day}/${data.initialRecommendationDate.year}";

    return Container(
      width: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Based on Your Holdings",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.primary.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  data.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: scheme.primary,
                  size: 20,
                ),
                onPressed: data.onBookmark,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          Text(
            data.strategyTag,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: scheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _badge("Similarity: ${data.similarityScore}", theme, scheme),
              const SizedBox(width: 8),
              Expanded(child: _confidenceBar(data.confidence, scheme)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _stat("ROI", data.projectedRoi, theme, scheme)),
              Expanded(
                  child: _stat("Volatility", data.volatility, theme, scheme)),
              Expanded(child: _stat("Sharpe", data.sharpe, theme, scheme)),
            ],
          ),
          const SizedBox(height: 10),
          _stat("Top Holdings", data.topHoldings.join(", "), theme, scheme),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                  child: _stat("Chain", data.dominantChain, theme, scheme)),
              Expanded(
                  child: _stat("Asset Mix", data.assetTypeMix, theme, scheme)),
            ],
          ),
          const SizedBox(height: 10),
          _stat("Goal", data.investmentGoal, theme, scheme),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _stat("Since", dateFormatted, theme, scheme)),
              Expanded(
                  child: _stat("Achieved", data.goalAchieved, theme, scheme)),
              Expanded(child: _stat("Horizon", data.horizon, theme, scheme)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: data.onPreview,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text("Preview",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.primary, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: data.onAdopt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text("Adopt Strategy",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: scheme.onPrimary, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(
      String label, String value, ThemeData theme, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurface)),
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: scheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _badge(String text, ThemeData theme, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _confidenceBar(double score, ColorScheme scheme) {
    return LinearProgressIndicator(
      value: score,
      backgroundColor: scheme.primary.withOpacity(0.25),
      valueColor: AlwaysStoppedAnimation(scheme.primary),
      minHeight: 6,
    );
  }
}

final List<MirrorSuggestionData> _demoSuggestions = [
  MirrorSuggestionData(
    name: "L2 Diversifier",
    confidence: 0.82,
    similarityScore: "91%",
    projectedRoi: "+17.2%",
    volatility: "Medium",
    strategyTag: "Cross-L2 Blend",
    sharpe: "1.3",
    topHoldings: ["ARB", "OP", "BASE"],
    dominantChain: "Arbitrum",
    assetTypeMix: "50% L2 Tokens, 30% DeFi, 20% Stable",
    initialRecommendationDate: DateTime(2024, 11, 20),
    investmentGoal: "Exposure to emerging L2s",
    goalAchieved: "63%",
    horizon: "6–12 months",
    isBookmarked: false,
    onBookmark: () => debugPrint("Bookmarked L2 Diversifier"),
    onPreview: () => debugPrint("Preview L2 Diversifier"),
    onAdopt: () => debugPrint("Adopt L2 Diversifier"),
  ),
  MirrorSuggestionData(
    name: "Alt Season Signal",
    confidence: 0.88,
    similarityScore: "94%",
    projectedRoi: "+23.8%",
    volatility: "High",
    strategyTag: "Altcoin Sprinter",
    sharpe: "1.4",
    topHoldings: ["DOGE", "SHIB", "PEPE"],
    dominantChain: "Base",
    assetTypeMix: "60% Meme, 30% L2, 10% NFTs",
    initialRecommendationDate: DateTime(2025, 2, 14),
    investmentGoal: "Ride short-term alt surges",
    goalAchieved: "71%",
    horizon: "< 3 months",
    isBookmarked: true,
    onBookmark: () => debugPrint("Unbookmarked Alt Season Signal"),
    onPreview: () => debugPrint("Preview Alt Season Signal"),
    onAdopt: () => debugPrint("Adopt Alt Season Signal"),
  ),
];
