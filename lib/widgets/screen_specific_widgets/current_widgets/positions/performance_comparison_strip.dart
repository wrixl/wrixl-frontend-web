// lib\widgets\screen_specific_widgets\current_widgets\positions\performance_comparison_strip.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PerformanceComparisonStrip extends StatelessWidget {
  final List<BenchmarkPerformance> benchmarks;
  final double userPerformance;

  const PerformanceComparisonStrip({
    super.key,
    required this.benchmarks,
    required this.userPerformance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedBenchmarks = [...benchmarks]..sort((a, b) => b
        .relativePerformance(userPerformance)
        .compareTo(a.relativePerformance(userPerformance)));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Relative Performance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text(
                'Compared to Benchmarks',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: sortedBenchmarks
                        .map((b) => b.relativePerformance(userPerformance))
                        .reduce((a, b) => a > b ? a : b) +
                    10,
                minY: sortedBenchmarks
                        .map((b) => b.relativePerformance(userPerformance))
                        .reduce((a, b) => a < b ? a : b) -
                    10,
                barGroups:
                    _buildBarGroups(sortedBenchmarks, userPerformance, theme),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Transform.rotate(
                        angle: -0.8,
                        child: Text(
                          sortedBenchmarks[value.toInt()].label,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(
    List<BenchmarkPerformance> benchmarks,
    double userPerformance,
    ThemeData theme,
  ) {
    return List.generate(benchmarks.length, (index) {
      final benchmark = benchmarks[index];
      final relative = benchmark.relativePerformance(userPerformance);
      final isOutperform = relative >= 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: relative,
            width: 20,
            color: benchmark.label == 'You'
                ? theme.colorScheme.primary
                : (isOutperform ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 0,
              color: theme.dividerColor.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }
}

class BenchmarkPerformance {
  final String label;
  final double performance;

  BenchmarkPerformance({required this.label, required this.performance});

  double relativePerformance(double userPerformance) =>
      performance - userPerformance;
}

final List<BenchmarkPerformance> dummyBenchmarks = [
  BenchmarkPerformance(label: 'BTC', performance: 3.2),
  BenchmarkPerformance(label: 'ETH', performance: 1.1),
  BenchmarkPerformance(label: 'S&P500', performance: 2.0),
  BenchmarkPerformance(label: 'Top 5%', performance: 6.8),
  BenchmarkPerformance(label: 'You', performance: 4.0),
  BenchmarkPerformance(label: 'WRX Index', performance: 5.2),
  BenchmarkPerformance(label: 'Simulated', performance: 3.5),
];
