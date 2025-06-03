// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/rotations_map.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSectorTiles(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Rotations Map',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ToggleButtons(
          isSelected: timeframes.map((t) => t == selectedTimeframe).toList(),
          onPressed: (index) {
            setState(() {
              selectedTimeframe = timeframes[index];
            });
          },
          children: timeframes.map((t) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(t),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSectorTiles() {
    return Column(
      children: sectors.map((sector) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: _buildSectorTile(sector),
      )).toList(),
    );
  }

  Widget _buildSectorTile(Map<String, dynamic> sector) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: sector['color'].withOpacity(0.1),
        border: Border.all(color: sector['color'], width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sector['label'],
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text('${sector['inflow']}% net flow • ${sector['wallets']} wallets'),
          const SizedBox(height: 4),
          Text(
            sector['behavior'],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: false),
                titlesData: FlTitlesData(show: false),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      sector['sparkline'].length,
                      (i) => FlSpot(i.toDouble(), sector['sparkline'][i]),
                    ),
                    isCurved: true,
                    color: sector['color'],
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
