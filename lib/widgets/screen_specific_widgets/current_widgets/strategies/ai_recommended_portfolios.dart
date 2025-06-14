// lib\widgets\screen_specific_widgets\current_widgets\strategies\ai_recommended_portfolios.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class AIRecommendedPortfolios extends StatelessWidget {
  final List<AIRecommendedPortfolio> portfolios;

  const AIRecommendedPortfolios({super.key, required this.portfolios});

  @override
  Widget build(BuildContext context) {
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
            /// App bar style
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI Recommended Portfolios',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
                const Icon(Icons.lightbulb_outline, size: 20),
              ],
            ),
            const SizedBox(height: 16),

            /// Scrollable card list
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: portfolios.length,
                itemBuilder: (context, index) {
                  return _buildRecommendationCard(context, portfolios[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, AIRecommendedPortfolio portfolio) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => showNewReusableModal(
        context,
        title: portfolio.name,
        size: WidgetModalSize.large,
        child: Text('Detailed modal content for ${portfolio.name}'),
      ),
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: scheme.surfaceVariant,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    portfolio.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${portfolio.fitScore}% Fit', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: portfolio.tags
                  .map((tag) => Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        backgroundColor: scheme.primary.withOpacity(0.15),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _metric("Sharpe", portfolio.sharpe.toStringAsFixed(2)),
                _metric("CAGR", '${(portfolio.cagr * 100).toStringAsFixed(1)}%'),
                _metric("Cost", '${portfolio.wrxCost} WRX'),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: portfolio.sparkline.asMap().entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      color: scheme.primary,
                      barWidth: 2,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Simulate'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Compare'),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AIRecommendedPortfolio {
  final String name;
  final double fitScore;
  final List<String> tags;
  final double sharpe;
  final double cagr;
  final int wrxCost;
  final List<double> sparkline;

  AIRecommendedPortfolio({
    required this.name,
    required this.fitScore,
    required this.tags,
    required this.sharpe,
    required this.cagr,
    required this.wrxCost,
    required this.sparkline,
  });
}
