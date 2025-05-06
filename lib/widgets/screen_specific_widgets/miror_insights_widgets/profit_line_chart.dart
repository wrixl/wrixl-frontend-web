// lib/widgets/screen_specific_widgets/miror_insights_widgets/profit_line_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

/// A styled chart widget comparing user vs mirrored wallet performance.
class ProfitLineChart extends StatelessWidget {
  const ProfitLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> userSpots = [
      FlSpot(0, 1),
      FlSpot(1, 1.5),
      FlSpot(2, 1.2),
      FlSpot(3, 1.8),
      FlSpot(4, 2.2),
    ];
    final List<FlSpot> mirrorSpots = [
      FlSpot(0, 1.2),
      FlSpot(1, 1.7),
      FlSpot(2, 1.4),
      FlSpot(3, 2.0),
      FlSpot(4, 2.5),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            "Comparative Profit Chart",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.accentColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 16),

          /// Chart with constrained height to prevent overflow
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 240,
              maxHeight: 300,
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) => Text(
                        "T${value.toInt()}",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 0.5,
                      getTitlesWidget: (value, _) => Text(
                        value.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: userSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: AppConstants.accentColor,
                    dotData: FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: mirrorSpots,
                    isCurved: true,
                    barWidth: 3,
                    color: AppConstants.neonGreen,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
