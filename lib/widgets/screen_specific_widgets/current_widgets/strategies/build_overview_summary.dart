// lib\widgets\screen_specific_widgets\current_widgets\strategies\build_overview_summary.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildOverviewSummary extends StatelessWidget {
  final int totalStrategies = 24;
  final int wrxBurned = 1860;
  final double avgSharpe = 1.43;
  final int aiGuidedBuilds = 15;
  final String topTheme = "Modular AI & Infra";
  final int strategiesMinted = 9;
  final List<String> customTags = ['#AI', '#DeFi', '#Stables'];
  final DateTime lastCreated = DateTime(2025, 5, 29);

  BuildOverviewSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Build Overview Summary",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const Icon(Icons.analytics_outlined, color: Colors.deepPurpleAccent),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildMetricTile("Total Strategies Built", "$totalStrategies", Icons.layers, context),
                _buildMetricTile("WRX Burned (Total)", "$wrxBurned WRX", Icons.local_fire_department, context, color: Colors.orange),
                _buildMetricTile("Avg Sharpe Ratio", avgSharpe.toStringAsFixed(2), Icons.trending_up, context, color: Colors.green),
                _buildMetricTile("AI-Guided Builds", "$aiGuidedBuilds / $totalStrategies", Icons.smart_toy_outlined, context),
                _buildMetricTile("Top Theme", '"$topTheme"', Icons.star, context, color: Colors.purple),
                _buildMetricTile("Success Rate", "${((strategiesMinted / totalStrategies) * 100).round()}% ($strategiesMinted/$totalStrategies Minted)", Icons.emoji_events, context, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 24),
            Text("Custom Tags Used",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.primary,
                )),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: customTags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              "📅 Last Strategy Created: ${DateFormat.yMMMMd().format(lastCreated)}",
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text("View Full History"),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text("Export as JSON"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, BuildContext context, {Color? color}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 160, maxWidth: 200),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color ?? scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              )),
        ],
      ),
    );
  }
}
