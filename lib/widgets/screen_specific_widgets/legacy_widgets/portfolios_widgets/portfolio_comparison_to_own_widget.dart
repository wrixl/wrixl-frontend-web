// lib/widgets/screen_specific_widgets/legacy_widgets/portfolio_comparison_to_own_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class PortfolioComparisonToOwn extends StatelessWidget {
  const PortfolioComparisonToOwn({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy radar input
    final List<Map<String, dynamic>> radarData = [
      {"metric": "Risk", "value": 0.7},
      {"metric": "Return", "value": 0.8},
      {"metric": "Sharpe", "value": 1.2},
      {"metric": "Overlap", "value": 0.4},
      {"metric": "AI Score", "value": 0.9},
    ];

    // Convert to compareData with casted doubles
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
      color: AppConstants.primaryColor,
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AppBar-style row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compare to My Portfolio",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: "Reset Comparison",
                  onPressed: () {
                    debugPrint("Reset tapped");
                  },
                  color: AppConstants.neonGreen,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Subheading (Selected model name)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedModelForComparison['name'] ?? 'Unnamed Model',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppConstants.textColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),

            const SizedBox(height: 20),

            // Radar Chart
            SizedBox(
              height: 240,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: compareData
                          .map((d) => RadarEntry(
                              value: (d['modelValue'] as num).toDouble()))
                          .toList(),
                      fillColor: AppConstants.accentColor.withOpacity(0.3),
                      borderColor: AppConstants.accentColor,
                      borderWidth: 2,
                      entryRadius: 4,
                    ),
                    RadarDataSet(
                      dataEntries: compareData
                          .map((d) => RadarEntry(
                              value: (d['personalValue'] as num).toDouble()))
                          .toList(),
                      fillColor: AppConstants.neonGreen.withOpacity(0.3),
                      borderColor: AppConstants.neonGreen,
                      borderWidth: 2,
                      entryRadius: 4,
                    ),
                  ],
                  tickCount: 5,
                  gridBorderData: BorderSide(
                    color: AppConstants.accentColor.withOpacity(0.4),
                    width: 1,
                  ),
                  tickBorderData:
                      const BorderSide(color: Colors.grey, width: 1),
                  getTitle: (index, angle) {
                    final metric = compareData[index]['metric'] ?? '';
                    return RadarChartTitle(
                      text: metric,
                      angle: angle,
                    );
                  },
                  titlePositionPercentageOffset: 0.2,
                  radarBackgroundColor: Colors.transparent,
                  radarShape: RadarShape.circle,
                ),
                swapAnimationDuration: const Duration(milliseconds: 150),
                swapAnimationCurve: Curves.linear,
              ),
            ),

            const SizedBox(height: 20),

            // CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Adopt tapped");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
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
