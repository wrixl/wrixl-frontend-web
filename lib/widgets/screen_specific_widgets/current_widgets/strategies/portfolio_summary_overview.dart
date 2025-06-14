// lib\widgets\screen_specific_widgets\current_widgets\strategies\portfolio_summary_overview.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class PortfolioSummaryOverview extends StatelessWidget {
  final String name;
  final List<String> tags;
  final DateTime created;
  final double sharpe;
  final double volatility;
  final double cagr;
  final double wrxCost;
  final int mintCount;
  final DateTime lastUpdated;
  final double smartOverlap;
  final double userFit;
  final List<double> sparklineData;

  const PortfolioSummaryOverview({
    super.key,
    required this.name,
    required this.tags,
    required this.created,
    required this.sharpe,
    required this.volatility,
    required this.cagr,
    required this.wrxCost,
    required this.mintCount,
    required this.lastUpdated,
    required this.smartOverlap,
    required this.userFit,
    required this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat.yMMMd();
    final now = DateTime.now();
    final daysAgo = now.difference(lastUpdated).inDays;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// App bar style header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Portfolio Summary",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const Icon(Icons.auto_graph_rounded, size: 20),
              ],
            ),

            const SizedBox(height: 12),

            /// Name & Last Updated
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      )),
                ),
                Text("Updated ${daysAgo == 0 ? "Today" : "$daysAgo days ago"}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.6),
                    )),
              ],
            ),

            const SizedBox(height: 4),

            /// Tags
            Wrap(
              spacing: 6,
              runSpacing: -6,
              children: tags
                  .map((t) => Chip(
                        label: Text(t),
                        padding: EdgeInsets.zero,
                        labelStyle: theme.textTheme.bodySmall,
                        backgroundColor: scheme.primary.withOpacity(0.1),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            /// KPI Metrics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metric("Sharpe", sharpe.toStringAsFixed(2), "Higher is better (risk-adjusted return)"),
                _metric("Volatility", "${(volatility * 100).toStringAsFixed(1)}%", "Portfolio price variability"),
                _metric("CAGR", "${(cagr * 100).toStringAsFixed(1)}%", "Compound Annual Growth Rate"),
                _metric("WRX Cost", "\${wrxCost.toStringAsFixed(2)}", "Cost to mint this strategy"),
                _metric("Mints", mintCount.toString(), "Number of users who minted this"),
              ],
            ),

            const SizedBox(height: 16),

            /// Smart Fit Progress Bars
            _scoreBar("Smart Wallet Overlap", smartOverlap, Colors.green),
            const SizedBox(height: 10),
            _scoreBar("Your Holdings Fit", userFit, Colors.blue),

            const SizedBox(height: 16),

            /// Sparkline
            SizedBox(
              height: 60,
              child: LineChart(LineChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: sparklineData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    color: scheme.primary,
                    barWidth: 2,
                  )
                ],
              )),
            ),

            const SizedBox(height: 16),

            /// Action Buttons
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Simulate"),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text("Compare"),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text("Bookmark"),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _scoreBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            color: color,
            backgroundColor: color.withOpacity(0.15),
          ),
        ),
      ],
    );
  }
}
