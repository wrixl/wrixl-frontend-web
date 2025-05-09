// lib/widgets/screen_specific_widgets/portfolios_widgets/portfolio_comparison_radar_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class PortfolioComparisonRadar extends StatelessWidget {
  final List<dynamic> radarData;
  final bool showRadarChart;
  final bool showOwnPortfolio;
  final VoidCallback toggleChart;
  final VoidCallback onReset;
  final VoidCallback onToggleOwn;

  const PortfolioComparisonRadar({
    Key? key,
    required this.radarData,
    required this.showRadarChart,
    required this.toggleChart,
    required this.onReset,
    required this.onToggleOwn,
    required this.showOwnPortfolio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Title + Two Icon Buttons
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
                onPressed: onReset,
              ),
              IconButton(
                icon: Icon(
                  showOwnPortfolio ? Icons.visibility : Icons.visibility_off,
                ),
                tooltip: showOwnPortfolio
                    ? "Hide My Portfolio"
                    : "Show My Portfolio",
                onPressed: onToggleOwn,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Chart
        SizedBox(
          height: 240,
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  dataEntries: radarData
                      .map((data) => RadarEntry(value: data['value'] ?? 0.0))
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
