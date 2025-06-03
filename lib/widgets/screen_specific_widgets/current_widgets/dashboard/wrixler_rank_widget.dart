// lib\widgets\screen_specific_widgets\current_widgets\wrixler_rank_widget.dart

// lib\widgets\screen_specific_widgets\current_widgets\wrixler_rank_widget.dart

import 'package:flutter/material.dart';

class WrixlerRankWidget extends StatelessWidget {
  const WrixlerRankWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final double currentPercentile = 0.88; // top 12%
    final double progressDelta = 0.02; // +2% this week
    final bool isImproving = progressDelta > 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Modal Trigger
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Wrixler Rank",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    )),
                IconButton(
                  icon: const Icon(Icons.leaderboard_outlined),
                  tooltip: "View full leaderboard",
                  onPressed: () => _showRankModal(context),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Rank Summary Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 66,
                      width: 66,
                      child: CircularProgressIndicator(
                        value: currentPercentile,
                        strokeWidth: 6,
                        backgroundColor: scheme.surfaceVariant,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(scheme.primary),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.emoji_events_outlined, size: 22),
                        Text("Top ${((1 - currentPercentile) * 100).round()}%",
                            style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Status & Tags
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Label
                      Text("Alpha Seeker",
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface)),
                      const SizedBox(height: 2),

                      // Momentum Indicator
                      Text(
                        isImproving
                            ? "📈 Climbing +${(progressDelta * 100).round()}% this week"
                            : "⏸ Holding steady",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isImproving
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Behavior Tags
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _tag("7-Day Streak 🔥", Colors.orange),
                          _tag("Consistent Gainer", Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  void _showRankModal(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            const Icon(Icons.emoji_events_outlined, size: 24),
            const SizedBox(width: 6),
            Text("Your Wrixler Rank", style: theme.textTheme.titleLarge),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text("🏅 You're currently in the top 12% of Wrixlers."),
              const SizedBox(height: 12),
              Text("📊 Peer Percentiles", style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              _comparisonRow("You", 21.2),
              _comparisonRow("Median", 13.4),
              _comparisonRow("Top 1%", 42.1),
              const SizedBox(height: 16),
              Text("📈 How to Improve", style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              const Text("• Simulate 2 more AI strategies this week."),
              const Text("• Participate in 3 signal votes."),
              const Text("• Maintain your streak above 7 days."),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"))
        ],
      ),
    );
  }

  Widget _comparisonRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 50,
              minHeight: 6,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                label == "You" ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text("${value.toStringAsFixed(1)}%")
        ],
      ),
    );
  }
}
