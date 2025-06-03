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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Featured Strategies",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
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
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final _DemoPortfolio portfolio;

  const _PortfolioCard({required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  portfolio.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Icon(Icons.trending_up, color: Colors.green),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: portfolio.tags
                  .map((tag) => Chip(label: Text(tag), padding: EdgeInsets.zero))
                  .toList(),
            ),
            const SizedBox(height: 8),
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
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text("Sharpe: ${portfolio.sharpe.toStringAsFixed(2)}  "),
                Text("CAGR: ${(portfolio.cagr * 100).toStringAsFixed(1)}%"),
              ],
            ),
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
