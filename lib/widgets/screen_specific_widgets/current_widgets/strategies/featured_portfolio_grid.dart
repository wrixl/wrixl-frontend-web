// lib\widgets\screen_specific_widgets\current_widgets\strategies\featured_portfolio_grid.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FeaturedPortfolioGrid extends StatelessWidget {
  const FeaturedPortfolioGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolios = _demoPortfolios;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final crossAxisCount = isMobile ? 1 : 2;
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
                Text("Featured Strategies",
                    style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.star, color: Colors.amberAccent),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: portfolios.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final portfolio = portfolios[index];
                return _PortfolioCard(portfolio: portfolio);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final _DemoPortfolio portfolio;

  const _PortfolioCard({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    portfolio.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.trending_up, color: Colors.green, size: 20),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: portfolio.tags
                  .map((tag) => Chip(
                        label: Text(tag,
                            style: const TextStyle(fontSize: 11)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: portfolio.sparkline,
                      isCurved: true,
                      color: Colors.blueAccent,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text("Sharpe: ${portfolio.sharpe.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.bodySmall),
            Text("CAGR: ${(portfolio.cagr * 100).toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  tooltip: "Simulate",
                  icon: const Icon(Icons.analytics),
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: "Compare",
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: () {},
                ),
                IconButton(
                  tooltip: "Bookmark",
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoPortfolio {
  final String name;
  final List<String> tags;
  final double sharpe;
  final double cagr;
  final List<FlSpot> sparkline;

  _DemoPortfolio({
    required this.name,
    required this.tags,
    required this.sharpe,
    required this.cagr,
    required this.sparkline,
  });
}

final _demoPortfolios = [
  _DemoPortfolio(
    name: "L2 Momentum",
    tags: ["Narrative", "Layer-2", "Trending"],
    sharpe: 1.76,
    cagr: 0.45,
    sparkline: [
      FlSpot(0, 1),
      FlSpot(1, 1.02),
      FlSpot(2, 1.1),
      FlSpot(3, 1.25),
      FlSpot(4, 1.3),
    ],
  ),
  _DemoPortfolio(
    name: "Stable Yield",
    tags: ["Yield", "Low Vol"],
    sharpe: 1.2,
    cagr: 0.22,
    sparkline: [
      FlSpot(0, 1),
      FlSpot(1, 1.01),
      FlSpot(2, 1.015),
      FlSpot(3, 1.02),
      FlSpot(4, 1.025),
    ],
  ),
  _DemoPortfolio(
    name: "AI Native",
    tags: ["AI", "Smart"],
    sharpe: 1.9,
    cagr: 0.53,
    sparkline: [
      FlSpot(0, 1),
      FlSpot(1, 1.05),
      FlSpot(2, 1.08),
      FlSpot(3, 1.13),
      FlSpot(4, 1.2),
    ],
  ),
];
