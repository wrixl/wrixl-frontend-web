// lib/widgets/screen_specific_widgets/miror_insights_widgets/profit_line_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class ProfitLineChart extends StatelessWidget {
  const ProfitLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Title and Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profit Comparison",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.show_chart_rounded,
                        color: Colors.greenAccent),
                  ],
                ),
                const SizedBox(height: 16),

                /// Chart
                SizedBox(
                  height: 260,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 0.5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: scheme.outline.withOpacity(0.1),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                            color: scheme.outline.withOpacity(0.2), width: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.5,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) => Text(
                              value.toStringAsFixed(1),
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) => Text(
                              "T${value.toInt()}",
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
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

                const SizedBox(height: 12),

                /// Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _legendDot("You", AppConstants.accentColor, theme),
                    _legendDot("Mirror Wallet", AppConstants.neonGreen, theme),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _legendDot(String label, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}
