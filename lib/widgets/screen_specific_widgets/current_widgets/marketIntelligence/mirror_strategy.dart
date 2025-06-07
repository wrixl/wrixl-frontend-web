// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/mirror_strategy.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MirrorStrategyWidget extends StatefulWidget {
  final String walletAlias;

  const MirrorStrategyWidget({super.key, required this.walletAlias});

  @override
  State<MirrorStrategyWidget> createState() => _MirrorStrategyWidgetState();
}

class _MirrorStrategyWidgetState extends State<MirrorStrategyWidget> {
  String selectedTimeframe = '1W';
  final List<String> timeframes = ['1W', '1M', '3M', 'YTD'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '📈 Mirror Strategy',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message:
                      'Preview your portfolio performance if you had mirrored ${widget.walletAlias}',
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedTimeframe,
                  items: timeframes
                      .map((val) =>
                          DropdownMenuItem(value: val, child: Text(val)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => selectedTimeframe = val ?? '1W'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.8,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [FlSpot(0, 10), FlSpot(1, 30), FlSpot(2, 40)],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: [FlSpot(0, 5), FlSpot(1, 15), FlSpot(2, 25)],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatTile(context, 'Net ROI', '+14.5%'),
                _buildStatTile(context, 'Drawdown', '5.2%'),
                _buildStatTile(context, 'Conviction', 'High'),
                _buildStatTile(context, 'Token Overlap', '78%'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showSimulateModal(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Simulate Mirror'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Save Strategy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey)),
      ],
    );
  }

  void _showSimulateModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Simulated Portfolio'),
        content:
            const Text('This is where a mirrored portfolio breakdown would go.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mirror Now'),
          ),
        ],
      ),
    );
  }
}
