// lib\widgets\screen_specific_widgets\legacy_widgets\portfolio_comparison_radar_widget.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class PortfolioComparisonRadar extends StatelessWidget {
  const PortfolioComparisonRadar({super.key});

  @override
  Widget build(BuildContext context) {
    // Self-contained dummy radar data
    final List<Map<String, dynamic>> radarData = [
      {"metric": "Volatility", "value": 0.6},
      {"metric": "Momentum", "value": 0.85},
      {"metric": "Drawdown", "value": 0.3},
      {"metric": "Smart Score", "value": 0.95},
      {"metric": "Liquidity", "value": 0.75},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & toggle buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Portfolio Metrics Radar",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.accentColor,
                      ),
                ),
              ),
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
          ),
        ),
        const SizedBox(height: 8),

        // Radar chart
        SizedBox(
          height: 240,
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  dataEntries: radarData
                      .map((data) =>
                          RadarEntry(value: (data['value'] as num).toDouble()))
                      .toList(),
                  fillColor: AppConstants.accentColor.withOpacity(0.3),
                  borderColor: AppConstants.accentColor,
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
                final metric = radarData[index]['metric'] ?? '';
                return RadarChartTitle(text: metric, angle: angle);
              },
              titlePositionPercentageOffset: 0.2,
              radarBackgroundColor: Colors.transparent,
              radarShape: RadarShape.circle,
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
      ],
    );
  }
}
