// lib\widgets\screen_specific_widgets\current_widgets\strategies\backtest_performance_results.dart


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BacktestPerformanceResults extends StatelessWidget {
  final bool isLogScale;
  final VoidCallback onToggleScale;
  final VoidCallback onReRunBacktest;

  const BacktestPerformanceResults({
    super.key,
    this.isLogScale = false,
    required this.onToggleScale,
    required this.onReRunBacktest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Backtest Performance Results',
                style: Theme.of(context).textTheme.titleLarge),
            Row(
              children: [
                Text('Log Scale'),
                Switch(value: isLogScale, onChanged: (_) => onToggleScale()),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 1),
                    FlSpot(1, 1.5),
                    FlSpot(2, 2),
                    FlSpot(3, 1.8),
                    FlSpot(4, 2.4),
                    FlSpot(5, 2.9),
                  ],
                  isCurved: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            _kpiCard('Sharpe Ratio', '1.45'),
            _kpiCard('CAGR', '22.3%'),
            _kpiCard('Max Drawdown', '-18.6%'),
            _kpiCard('Volatility', '14.2%'),
            _kpiCard('WRX Mint Cost', '125 WRX'),
          ],
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: onReRunBacktest,
            icon: const Icon(Icons.refresh),
            label: const Text('Re-run Backtest'),
          ),
        ),
      ],
    );
  }

  Widget _kpiCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
