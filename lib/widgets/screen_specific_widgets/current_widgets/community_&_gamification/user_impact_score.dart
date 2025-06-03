// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\user_impact_score.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserImpactScoreWidget extends StatefulWidget {
  const UserImpactScoreWidget({super.key});

  @override
  State<UserImpactScoreWidget> createState() => _UserImpactScoreWidgetState();
}

class _UserImpactScoreWidgetState extends State<UserImpactScoreWidget> {
  int touchedIndex = -1;
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

    return Column(
      children: [
        Text('Impact Score',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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
                  color: theme.colorScheme.primary,
                  title: '${(score * 100).toStringAsFixed(0)}%',
                  radius: 64,
                  titleStyle: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: (1 - score) * 100,
                  color: theme.colorScheme.surfaceVariant,
                  title: '',
                  radius: 64,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(scoreLevel,
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
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
                Icon(icon, size: 28, color: theme.colorScheme.primary),
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
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.info_outline),
          label: const Text('How to Increase Impact'),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
