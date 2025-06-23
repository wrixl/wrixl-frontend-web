// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/rotations_map.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class RotationsMapWidget extends StatefulWidget {
  const RotationsMapWidget({Key? key}) : super(key: key);

  @override
  State<RotationsMapWidget> createState() => _RotationsMapWidgetState();
}

class _RotationsMapWidgetState extends State<RotationsMapWidget> {
  String selectedTimeframe = '3D';
  final List<String> timeframes = ['1D', '3D', '7D'];

  final List<Map<String, dynamic>> sectors = [
    {
      'label': 'RWA',
      'inflow': 13.2,
      'wallets': 47,
      'behavior': 'Accumulating aggressively',
      'color': Colors.green,
      'sparkline': [3.2, 5.6, 7.1, 9.4, 13.2],
    },
    {
      'label': 'AI',
      'inflow': -9.7,
      'wallets': 32,
      'behavior': 'Distributing slowly',
      'color': Colors.red,
      'sparkline': [10.1, 9.4, 8.5, 7.3, 5.8],
    },
    {
      'label': 'L2s',
      'inflow': 4.5,
      'wallets': 18,
      'behavior': 'Mild inflow',
      'color': Colors.amber,
      'sparkline': [2.0, 2.5, 3.1, 3.7, 4.5],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            ...sectors.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _buildSectorTile(s),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Rotations Map", style: theme.textTheme.titleMedium),
        ToggleButtons(
          isSelected: timeframes.map((t) => t == selectedTimeframe).toList(),
          onPressed: (index) {
            setState(() => selectedTimeframe = timeframes[index]);
          },
          borderRadius: BorderRadius.circular(8),
          selectedColor: theme.colorScheme.primary,
          fillColor: theme.colorScheme.primary.withOpacity(0.1),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          children: timeframes
              .map((t) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(t),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSectorTile(Map<String, dynamic> sector) {
    final theme = Theme.of(context);
    final color = sector['color'] as Color;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // open modal with full details
        showNewReusableModal(
          context,
          title: sector['label'],
          size: WidgetModalSize.small,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${sector['inflow']}% net flow",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "${sector['wallets']} wallets moving",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                sector['behavior'],
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(enabled: false),
                    titlesData: const FlTitlesData(show: false),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: (sector['sparkline'] as List<double>)
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: color,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.06),
          border: Border.all(color: color, width: 1.25),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sector['label'],
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: color, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${sector['inflow']}% net flow • ${sector['wallets']} wallets',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              sector['behavior'],
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: LineChart(
                LineChartData(
                  lineTouchData: const LineTouchData(enabled: false),
                  titlesData: const FlTitlesData(show: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: (sector['sparkline'] as List<double>)
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: color,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      barWidth: 2.5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
