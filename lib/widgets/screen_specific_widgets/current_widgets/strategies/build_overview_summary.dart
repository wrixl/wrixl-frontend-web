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
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📊 Build Overview Summary", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              runSpacing: 12,
              spacing: 12,
              children: [
                _buildMetricTile("Total Strategies Built", "$totalStrategies", Icons.layers),
                _buildMetricTile("WRX Burned (Total)", "$wrxBurned WRX", Icons.local_fire_department, color: Colors.orange),
                _buildMetricTile("Avg Sharpe Ratio", avgSharpe.toStringAsFixed(2), Icons.trending_up, color: Colors.green),
                _buildMetricTile("AI-Guided Builds", "$aiGuidedBuilds / $totalStrategies", Icons.smart_toy_outlined),
                _buildMetricTile("Top Theme", '"$topTheme"', Icons.star, color: Colors.purple),
                _buildMetricTile("Success Rate", "${((strategiesMinted / totalStrategies) * 100).round()}% ($strategiesMinted/$totalStrategies Minted)", Icons.emoji_events, color: Colors.amber),
              ],
            ),
            const Divider(height: 32),
            Text("🔍 Custom Tags Used", style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: customTags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 16),
            Text("📅 Last Strategy Created: ${DateFormat.yMMMMd().format(lastCreated)}", style: textStyle),
            const SizedBox(height: 24),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color ?? Colors.blueGrey),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
