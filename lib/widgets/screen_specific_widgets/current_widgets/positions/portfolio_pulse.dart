// lib\widgets\screen_specific_widgets\current_widgets\positions\portfolio_pulse.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../../utils/constants.dart';

class PortfolioPulse extends StatefulWidget {
  const PortfolioPulse({Key? key}) : super(key: key);

  @override
  _PortfolioPulseState createState() => _PortfolioPulseState();
}

class _PortfolioPulseState extends State<PortfolioPulse> {
  /// Time frame states:
  /// 0 = This week, 1 = 1 month, 2 = 3 months.
  int selectedTimeFrame = 0;

  /// Hardcoded performer names (for demo purposes)
  final Map<int, String> topPerformers = {0: "ETH", 1: "LTC", 2: "BTC"};
  final Map<int, String> worstPerformers = {0: "XRP", 1: "ADA", 2: "DOGE"};

  /// Hardcoded percentage change for best/worst performers.
  final Map<int, String> topPerformerChange = {
    0: "+5.0%",
    1: "+7.2%",
    2: "+4.3%"
  };
  final Map<int, String> worstPerformerChange = {
    0: "-3.5%",
    1: "-2.8%",
    2: "-3.2%"
  };

  /// 14-point data arrays for each time frame (values are assumed to be % profit/loss)
  final List<double> weeklyPnL = [
    20,
    -22,
    14,
    -12,
    -19,
    28,
    1,
    11,
    5,
    -10,
    15,
    -4,
    8,
    0
  ];
  final List<double> monthlyPnL = [
    10,
    12,
    15,
    -18,
    -20,
    19,
    -22,
    -24,
    -23,
    25,
    27,
    30,
    14,
    -5
  ];
  final List<double> threeMonthPnL = [
    5,
    -3,
    10,
    -7,
    2,
    0,
    -1,
    8,
    -4,
    6,
    11,
    -2,
    3,
    -9
  ];

  /// Selects the appropriate data based on the time frame.
  List<double> get currentData {
    if (selectedTimeFrame == 0) return weeklyPnL;
    if (selectedTimeFrame == 1) return monthlyPnL;
    return threeMonthPnL;
  }

  /// Returns the label for the toggle button.
  String get timeFrameLabel {
    if (selectedTimeFrame == 0) return "This week";
    if (selectedTimeFrame == 1) return "1 month";
    return "3 months";
  }

  /// Computes the overall percentage change for the current period.
  String get percentageChange {
    final data = currentData;
    final first = data.first;
    final last = data.last;
    if (first == 0) return "0%";
    final change = ((last - first) / first) * 100;
    final sign = change >= 0 ? "+" : "";
    return "$sign${change.toStringAsFixed(1)}%";
  }

  /// When tapped, cycle the time frame among the three states.
  void _toggleTimeFrame() {
    setState(() {
      selectedTimeFrame = (selectedTimeFrame + 1) % 3;
    });
  }

  /// Opens a modal displaying detailed returns and asset contributions.
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
              Text(
                "Detailed Portfolio Pulse",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const Text(
                "This view displays returns and asset-level contributions. (Placeholder content)",
              ),
              // Additional charts, lists, or asset breakdowns go here.
            ],
          ),
        );
      },
    );
  }

  /// Builds bar groups for the chart.
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(currentData.length, (index) {
      final double yValue = currentData[index];
      final bool isPositive = yValue >= 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: yValue,
            color: isPositive ? Colors.green : Colors.red,
            width: 6, // narrower bar width for closer spacing
          ),
        ],
      );
    });
  }

  /// Custom bottom axis labels based on the time frame.
  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    String text = "";
    int index = value.toInt();
    if (index < 0 || index >= 14) return Container(); // out-of-range guard

    if (selectedTimeFrame == 0) {
      // This week: total of 12 hours over 13 intervals.
      double increment = 12 / 13;
      double hour = index * increment;
      if (index == 0 || index == 7 || index == 13) {
        text = "${hour.toStringAsFixed(0)}h";
      }
    } else if (selectedTimeFrame == 1) {
      // 1 month: each bar represents 2 days.
      int day = index * 2;
      if (index == 0 || index == 7 || index == 13) {
        text = "${day}d";
      }
    } else {
      // 3 months: each bar represents 1 week.
      int week = index;
      if (index == 0 || index == 7 || index == 13) {
        text = "${week}w";
      }
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  /// Custom left axis labels – display only the highest and lowest marks with a "%" suffix.
  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    final data = currentData;
    final double yMin = data.reduce(min);
    final double yMax = data.reduce(max);
    const tolerance = 0.01;
    if ((value - yMin).abs() < tolerance || (value - yMax).abs() < tolerance) {
      return Text("${value.toStringAsFixed(0)}%",
          style: const TextStyle(fontSize: 10));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = currentData;
    final double yMin = data.reduce(min);
    final double yMax = data.reduce(max);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // compact padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Widget Title and Options Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Portfolio Pulse",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showDetailsModal,
                  tooltip: "Options",
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Row for Time Frame Toggle and Overall Percentage Change Display.
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
                Text(
                  percentageChange,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: percentageChange.startsWith("+")
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// The Bar Chart (tap to open modal)
            Flexible(
              child: GestureDetector(
                onTap: _showDetailsModal,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: BarChart(
                    BarChartData(
                      groupsSpace: 4,
                      minY: yMin,
                      maxY: yMax,
                      barGroups: _buildBarGroups(),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: _leftTitleWidgets,
                          ),
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: _bottomTitleWidgets,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Bottom Row to highlight Top and Worst Performers, including their percentage change.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Top: ${topPerformers[selectedTimeFrame]} (${topPerformerChange[selectedTimeFrame]})",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Worst: ${worstPerformers[selectedTimeFrame]} (${worstPerformerChange[selectedTimeFrame]})",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
