// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\stablecoin_flow.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class StablecoinFlowWidget extends StatefulWidget {
  const StablecoinFlowWidget({super.key});

  @override
  State<StablecoinFlowWidget> createState() => _StablecoinFlowWidgetState();
}

class _StablecoinFlowWidgetState extends State<StablecoinFlowWidget> {
  String _selectedRange = '7D';

  final Map<String, List<Map<String, double>>> _mockData = {
    '7D': List.generate(7, (i) => {
          'inflow': 200 + Random().nextDouble() * 300,
          'outflow': 100 + Random().nextDouble() * 250,
        }),
    '30D': List.generate(30, (i) => {
          'inflow': 150 + Random().nextDouble() * 400,
          'outflow': 120 + Random().nextDouble() * 350,
        }),
    '90D': List.generate(90, (i) => {
          'inflow': 100 + Random().nextDouble() * 500,
          'outflow': 150 + Random().nextDouble() * 400,
        }),
  };

  double get _netDelta {
    final data = _mockData[_selectedRange]!;
    final inflow = data.map((e) => e['inflow']!).reduce((a, b) => a + b);
    final outflow = data.map((e) => e['outflow']!).reduce((a, b) => a + b);
    return inflow - outflow;
  }

  bool get _isRiskOn => _netDelta > 0;

  List<String> get _narratives => ['Memecoins', 'AI', 'Launchpads'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _mockData[_selectedRange]!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '🧊 Dry Powder Tracker: Stablecoin Inflow/Outflow',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Tooltip(
                  message:
                      'Tracks daily stablecoin movements to/from exchanges — a signal of market readiness or retreat.',
                  child: const Icon(Icons.info_outline, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 600,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (_selectedRange == '7D') ? 1 : (_selectedRange == '30D') ? 5 : 15,
                        getTitlesWidget: (value, _) => Text('Day ${value.toInt() + 1}'),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (v, _) => Text('\$${v.toInt()}M'),
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(data.length, (i) {
                    final inflow = data[i]['inflow']!;
                    final outflow = data[i]['outflow']!;
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: inflow,
                        color: Colors.greenAccent,
                        width: 6,
                      ),
                      BarChartRodData(
                        toY: outflow,
                        color: Colors.redAccent,
                        width: 6,
                      ),
                    ]);
                  }),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isRiskOn ? Colors.greenAccent : Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _isRiskOn ? '↑ Risk Appetite Increasing' : '↓ Risk-Off Sentiment',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Net Change: \$${_netDelta.abs().toStringAsFixed(0)}M ($_selectedRange)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Most Impacted: ${_narratives.join(', ')}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: ['7D', '30D', '90D'].map((range) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(range),
                    selected: _selectedRange == range,
                    onSelected: (_) => setState(() => _selectedRange = range),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
