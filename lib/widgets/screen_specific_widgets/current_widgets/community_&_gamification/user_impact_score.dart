// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\user_impact_score.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserImpactScoreWidget extends StatefulWidget {
  const UserImpactScoreWidget({super.key});

  @override
  State<UserImpactScoreWidget> createState() => _UserImpactScoreWidgetState();
}

class _UserImpactScoreWidgetState extends State<UserImpactScoreWidget> {
  final double score = 0.76;
  final String scoreLevel = 'Influencer';

  final List<Map<String, dynamic>> metrics = [
    {'label': 'Votes', 'value': 58, 'delta': -4, 'icon': Icons.how_to_vote},
    {'label': 'Predictions', 'value': 72, 'delta': 12, 'icon': Icons.trending_up},
    {'label': 'Referrals', 'value': 4, 'delta': 1, 'icon': Icons.group_add},
    {'label': 'Badges', 'value': 6, 'delta': 0, 'icon': Icons.emoji_events},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Impact Score', style: theme.textTheme.titleMedium),
                const Icon(Icons.star_rate, color: Colors.amber)
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.2,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 48,
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  borderData: FlBorderData(show: false),
                  sections: [
                    PieChartSectionData(
                      value: score * 100,
                      color: colorScheme.primary,
                      title: '${(score * 100).toStringAsFixed(0)}%',
                      radius: 64,
                      titleStyle: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: (1 - score) * 100,
                      color: colorScheme.surfaceVariant,
                      title: '',
                      radius: 64,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(scoreLevel,
                  style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: metrics.map((metric) {
                final int delta = metric['delta'] as int;
                final IconData icon = metric['icon'] as IconData;
                final Color deltaColor = delta > 0
                    ? Colors.green
                    : delta < 0
                        ? Colors.red
                        : theme.hintColor;
                final String deltaSymbol = delta > 0
                    ? '▲'
                    : delta < 0
                        ? '▼'
                        : '●';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 28, color: colorScheme.primary),
                    const SizedBox(height: 4),
                    Text('${metric['value']}',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text(metric['label'],
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    Text('$deltaSymbol ${delta.abs()}%',
                        style: theme.textTheme.bodySmall?.copyWith(color: deltaColor)),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline),
                label: const Text('How to Increase Impact'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
