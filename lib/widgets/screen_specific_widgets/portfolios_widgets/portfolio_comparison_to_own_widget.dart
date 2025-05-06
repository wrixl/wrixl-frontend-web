// lib/widgets/screen_specific_widgets/portfolios_widgets/portfolio_comparison_to_own_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class PortfolioComparisonToOwn extends StatelessWidget {
  final List<dynamic> compareData;
  final dynamic selectedModelForComparison;
  final VoidCallback onAdoptStrategy;
  final VoidCallback onReset;

  const PortfolioComparisonToOwn({
    Key? key,
    required this.compareData,
    required this.selectedModelForComparison,
    required this.onAdoptStrategy,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  onPressed: onReset,
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
                          .map((d) => RadarEntry(value: d['modelValue'] ?? 0.0))
                          .toList(),
                      fillColor: AppConstants.accentColor.withOpacity(0.3),
                      borderColor: AppConstants.accentColor,
                      borderWidth: 2,
                      entryRadius: 4,
                    ),
                    RadarDataSet(
                      dataEntries: compareData
                          .map((d) => RadarEntry(value: d['personalValue'] ?? 0.0))
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
                  tickBorderData: const BorderSide(color: Colors.grey, width: 1),
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
                onPressed: onAdoptStrategy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Adopt Strategy", style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
