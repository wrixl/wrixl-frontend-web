// lib\widgets\screen_specific_widgets\legacy_widgets\portfolio_comparison_radar_widget.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioComparisonRadar extends StatelessWidget {
  const PortfolioComparisonRadar({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Dummy radar data
    final List<Map<String, dynamic>> radarData = [
      {"metric": "Volatility", "value": 0.6},
      {"metric": "Momentum", "value": 0.85},
      {"metric": "Drawdown", "value": 0.3},
      {"metric": "Smart Score", "value": 0.95},
      {"metric": "Liquidity", "value": 0.75},
    ];

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
                Text(
                  "Portfolio Metrics Radar",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: "Reset Metrics",
                      onPressed: () => debugPrint("Radar reset tapped"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility_off),
                      tooltip: "Toggle My Portfolio",
                      onPressed: () => debugPrint("Radar toggle tapped"),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 260,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: radarData
                          .map((data) => RadarEntry(
                              value: (data['value'] as num).toDouble()))
                          .toList(),
                      fillColor: scheme.primary.withOpacity(0.2),
                      borderColor: scheme.primary,
                      borderWidth: 2,
                      entryRadius: 3,
                    ),
                  ],
                  tickCount: 5,
                  titlePositionPercentageOffset: 0.2,
                  radarBackgroundColor: Colors.transparent,
                  radarShape: RadarShape.circle,
                  borderData: FlBorderData(show: false),
                  gridBorderData:
                      BorderSide(color: scheme.primary.withOpacity(0.3), width: 1),
                  tickBorderData:
                      BorderSide(color: scheme.onSurface.withOpacity(0.15), width: 1),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                  getTitle: (index, _) {
                    final metric = radarData[index]['metric'] ?? '';
                    return RadarChartTitle(text: metric);
                  },
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "🧠 Compare risk-adjusted metrics across selected portfolios.",
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
