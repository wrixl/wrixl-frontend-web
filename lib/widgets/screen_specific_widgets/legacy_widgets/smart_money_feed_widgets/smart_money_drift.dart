// lib\widgets\screen_specific_widgets\dashboard_overview_widgets\smart_money_drift.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart'; // Provides AppConstants.

class SmartMoneyDrift extends StatefulWidget {
  const SmartMoneyDrift({Key? key}) : super(key: key);

  @override
  State<SmartMoneyDrift> createState() => _SmartMoneyDriftState();
}

class _SmartMoneyDriftState extends State<SmartMoneyDrift> {
  int? touchedIndex;
  int selectedTimeFrame = 0; // 0 = Today, 1 = This Week, 2 = This Month

  final List<_BubbleData> bubbleData = [
    _BubbleData('SOL', 17, 23),
    _BubbleData('INJ', 45, 22),
    _BubbleData('ETH', 15, 35),
    _BubbleData('XRP', 6, 15),
    _BubbleData('BNB', 20, 16),
  ];

  void _toggleTimeFrame() {
    setState(() {
      selectedTimeFrame = (selectedTimeFrame + 1) % 3;
    });
  }

  String get timeFrameLabel {
    if (selectedTimeFrame == 0) return "Today";
    if (selectedTimeFrame == 1) return "This Week";
    return "This Month";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Title and Options Button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Smart Money Drift",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showDetailsModal,
                ),
              ],
            ),
            const SizedBox(height: 6),

            /// Time Frame Toggle — styled to match MarketWeather
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _toggleTimeFrame,
                  child: Text(
                    timeFrameLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Text(
                  "SOL, INJ, ETH, XRP, BNB",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Bubble Chart - fully constrained in layout.
            Expanded(
              child: ScatterChart(
                ScatterChartData(
                  minX: 0,
                  maxX: (bubbleData.length + 1) * 2.0, // horizontal spacing
                  minY: 0,
                  maxY: 10, // generous top for visual comfort
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  scatterTouchData: ScatterTouchData(
                    enabled: true,
                    handleBuiltInTouches: true,
                    touchCallback:
                        (FlTouchEvent event, ScatterTouchResponse? response) {
                      if (response == null || response.touchedSpot == null) {
                        setState(() => touchedIndex = null);
                      } else {
                        final int idx =
                            ((response.touchedSpot!.spot.x / 2.0) - 1).round();
                        setState(() => touchedIndex = idx);
                      }
                    },
                    touchTooltipData: ScatterTouchTooltipData(
                      getTooltipItems: (ScatterSpot spot) {
                        final int idx = ((spot.x / 2.0) - 1).round();
                        final token = bubbleData[idx];
                        return ScatterTooltipItem(
                          "${token.symbol}\n${token.percentChange.toStringAsFixed(1)}%",
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),

                  /// Bubbles
                  scatterSpots: List.generate(bubbleData.length, (i) {
                    final token = bubbleData[i];
                    final isExpansion = token.percentChange >= 0;

                    // 🎯 Scaled radius between 6.0 - 14.0 visually
                    const double minRadius = 6.0;
                    const double maxRadius = 18.0;

                    final double normalized =
                        ((token.endSize - 15) / (25 - 15)).clamp(0.0, 1.0);
                    final double radius =
                        minRadius + (maxRadius - minRadius) * normalized;

                    return ScatterSpot(
                      (i + 1) * 2.0,
                      5 +
                          (i % 2 == 0
                              ? 1
                              : -1), // visually pleasing staggered Y
                      dotPainter: FlDotCirclePainter(
                        radius: radius,
                        color: isExpansion
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        strokeWidth: 4,
                        strokeColor: isExpansion
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Bottom Forecast Text.
            Center(
              child: Text(
                "SOL, INJ, and ETH attracting big inflows",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showDetailsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Detailed Smart Money Drift",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text("This view displays asset-level flows and trends."),
            ],
          ),
        );
      },
    );
  }
}

/// Bubble data model
class _BubbleData {
  final String symbol;
  final double baseSize;
  final double endSize;

  double get percentChange => endSize - baseSize;

  _BubbleData(this.symbol, this.baseSize, this.endSize);
}
