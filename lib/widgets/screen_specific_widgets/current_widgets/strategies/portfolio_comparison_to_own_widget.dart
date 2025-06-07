// lib/widgets/screen_specific_widgets/legacy_widgets/portfolio_comparison_to_own_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class PortfolioComparisonToOwn extends StatelessWidget {
  const PortfolioComparisonToOwn({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Dummy radar input
    final List<Map<String, dynamic>> radarData = [
      {"metric": "Risk", "value": 0.7},
      {"metric": "Return", "value": 0.8},
      {"metric": "Sharpe", "value": 1.2},
      {"metric": "Overlap", "value": 0.4},
      {"metric": "AI Score", "value": 0.9},
    ];

    final compareData = radarData.map((entry) {
      final double value = (entry["value"] as num).toDouble();
      return {
        "metric": entry["metric"],
        "modelValue": value,
        "personalValue": (value - 0.25).clamp(0.0, 1.5),
      };
    }).toList();

    final selectedModelForComparison = {
      "name": "Alpha AI Strategy v2.1",
    };

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
                Text(
                  "Compare to My Portfolio",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: "Reset Comparison",
                  onPressed: () {
                    debugPrint("Reset tapped");
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              selectedModelForComparison['name'] ?? 'Unnamed Model',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 260,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: compareData
                          .map((d) => RadarEntry(
                              value: (d['modelValue'] as num).toDouble()))
                          .toList(),
                      fillColor: scheme.primary.withOpacity(0.25),
                      borderColor: scheme.primary,
                      borderWidth: 2,
                      entryRadius: 3,
                    ),
                    RadarDataSet(
                      dataEntries: compareData
                          .map((d) => RadarEntry(
                              value: (d['personalValue'] as num).toDouble()))
                          .toList(),
                      fillColor: scheme.tertiary.withOpacity(0.25),
                      borderColor: scheme.tertiary,
                      borderWidth: 2,
                      entryRadius: 3,
                    ),
                  ],
                  tickCount: 5,
                  gridBorderData: BorderSide(
                    color: scheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                  tickBorderData: BorderSide(
                    color: scheme.onSurface.withOpacity(0.15),
                    width: 1,
                  ),
                  getTitle: (index, angle) {
                    final metric = compareData[index]['metric'] ?? '';
                    return RadarChartTitle(text: metric, angle: angle);
                  },
                  titlePositionPercentageOffset: 0.2,
                  radarBackgroundColor: Colors.transparent,
                  radarShape: RadarShape.circle,
                ),
                swapAnimationDuration: const Duration(milliseconds: 300),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "📊 Overlap, Sharpe, and risk profile measured against your current holdings.",
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Adopt tapped");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Adopt Strategy",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
