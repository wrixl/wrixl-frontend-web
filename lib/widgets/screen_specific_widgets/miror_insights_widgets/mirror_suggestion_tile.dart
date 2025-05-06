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
  final MirrorSuggestionData data;

  const MirrorSuggestionTile({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dateFormatted =
        "${data.initialRecommendationDate.month}/${data.initialRecommendationDate.day}/${data.initialRecommendationDate.year}";

    return Container(
      width: 360,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 40),
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
          // Header
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

          // Strategy Name & Tag
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

          // Similarity & Confidence
          Row(
            children: [
              _badge("Similarity: ${data.similarityScore}", theme, scheme),
              const SizedBox(width: 8),
              Expanded(child: _confidenceBar(data.confidence, scheme)),
            ],
          ),
          const SizedBox(height: 12),

          // ROI / Volatility / Sharpe
          Row(
            children: [
              Expanded(child: _statBlock("ROI", data.projectedRoi, theme, scheme)),
              Expanded(child: _statBlock("Volatility", data.volatility, theme, scheme)),
              Expanded(child: _statBlock("Sharpe", data.sharpe, theme, scheme)),
            ],
          ),
          const SizedBox(height: 10),

          // Holdings / Chain / Mix
          _statBlock("Top Holdings", data.topHoldings.join(", "), theme, scheme),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _statBlock("Chain", data.dominantChain, theme, scheme)),
              Expanded(child: _statBlock("Asset Mix", data.assetTypeMix, theme, scheme)),
            ],
          ),
          const SizedBox(height: 10),

          // Investment Goal
          _statBlock("Goal", data.investmentGoal, theme, scheme),
          const SizedBox(height: 6),

          // Timeline row
          Row(
            children: [
              Expanded(child: _statBlock("Since", dateFormatted, theme, scheme)),
              Expanded(child: _statBlock("Achieved", data.goalAchieved, theme, scheme)),
              Expanded(child: _statBlock("Horizon", data.horizon, theme, scheme)),
            ],
          ),
          const SizedBox(height: 12),

          // CTA Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: data.onPreview,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: scheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    "Preview",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.primary,
                      fontSize: 12,
                    ),
                  ),
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
                  child: Text(
                    "Adopt Strategy",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBlock(String label, String value, ThemeData theme, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface)),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface.withOpacity(0.6)),
          ),
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
