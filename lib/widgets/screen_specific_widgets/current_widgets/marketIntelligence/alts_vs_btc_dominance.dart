// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\alts_vs_btc_dominance.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AltsVsBTCDominanceWidget extends StatefulWidget {
  const AltsVsBTCDominanceWidget({super.key});

  @override
  State<AltsVsBTCDominanceWidget> createState() => _AltsVsBTCDominanceWidgetState();
}

class _AltsVsBTCDominanceWidgetState extends State<AltsVsBTCDominanceWidget> {
  String _selectedRange = '7D';

  final Map<String, List<FlSpot>> _mockedData = {
    '7D': List.generate(7, (i) => FlSpot(i.toDouble(), 0.06 + sin(i / 1.5) * 0.005)),
    '30D': List.generate(30, (i) => FlSpot(i.toDouble(), 0.06 + sin(i / 4) * 0.01)),
    '90D': List.generate(90, (i) => FlSpot(i.toDouble(), 0.065 + sin(i / 7) * 0.008)),
  };

  double get _currentRatio => _mockedData[_selectedRange]!.last.y;
  double get _previousRatio => _mockedData[_selectedRange]!.first.y;
  double get _delta => ((_currentRatio - _previousRatio) / _previousRatio) * 100;

  bool get _isRiskOn => _currentRatio >= 0.07;

  List<String> get _topNarratives => ['AI', 'Layer 2s', 'Memecoins'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                    'Risk-On vs Risk-Off: ETH/BTC Dominance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Tooltip(
                  message:
                      'ETH/BTC dominance is a proxy for market risk appetite. ETH rising = risk-on, BTC rising = risk-off.',
                  child: const Icon(Icons.info_outline, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _mockedData[_selectedRange]!,
                      isCurved: true,
                      color: _isRiskOn ? Colors.greenAccent : Colors.redAccent,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (_isRiskOn ? Colors.green : Colors.red)
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.005,
                        reservedSize: 40,
                        getTitlesWidget: (v, _) => Text('${(v * 100).toStringAsFixed(1)}%'),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: (_selectedRange == '7D') ? 1 : (_selectedRange == '30D') ? 5 : 15,
                        getTitlesWidget: (v, _) => Text('Day ${v.toInt()}'),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
                duration: const Duration(milliseconds: 250),
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
                    _isRiskOn ? '🟢 Risk-On Mode' : '🔴 Risk-Off Mode',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Δ ${_delta.toStringAsFixed(2)}% over $_selectedRange',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Narratives affected: ${_topNarratives.join(', ')}',
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
