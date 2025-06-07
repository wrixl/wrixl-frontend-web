// lib\widgets\screen_specific_widgets\current_widgets\strategies\compare_portfolio_models.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ComparePortfolioModels extends StatelessWidget {
  final List<Map<String, dynamic>> portfolios;

  const ComparePortfolioModels({super.key, this.portfolios = const []});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Compare Portfolio Models",
                    style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.compare_arrows, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 16),
            portfolios.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Drag or select up to 3 portfolios to compare.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          portfolios.map((p) => _buildPortfolioColumn(context, p)).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioColumn(BuildContext context, Map<String, dynamic> p) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: scheme.background,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(p['name'],
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                const Icon(Icons.star_border, size: 20, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children:
                  List.generate(p['tags'].length, (i) => Chip(label: Text(p['tags'][i]))),
            ),
            const SizedBox(height: 12),
            _statRow("Sharpe Ratio", p['sharpe'].toStringAsFixed(2), Colors.teal),
            _statRow("CAGR", "${(p['cagr'] * 100).toStringAsFixed(1)}%", Colors.indigo),
            _statRow("Volatility", "${(p['volatility'] * 100).toStringAsFixed(1)}%", Colors.red),
            _statRow("WRX Cost", "${p['wrx_cost']} WRX", Colors.deepPurple),
            _statRow("Mint Count", "${p['mint_count']}", Colors.orange),
            const SizedBox(height: 12),
            Text("Allocation", style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            _buildMiniPieChart(),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Simulate"),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value,
              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildMiniPieChart() {
    return SizedBox(
      height: 100,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 24,
          sections: [
            PieChartSectionData(value: 40, color: Colors.blue, radius: 12),
            PieChartSectionData(value: 30, color: Colors.green, radius: 12),
            PieChartSectionData(value: 20, color: Colors.orange, radius: 12),
            PieChartSectionData(value: 10, color: Colors.purple, radius: 12),
          ],
        ),
      ),
    );
  }
}
