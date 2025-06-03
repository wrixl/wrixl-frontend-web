// lib\widgets\screen_specific_widgets\current_widgets\strategies\mirroring_drift_radar.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class MirroringDriftRadar extends StatefulWidget {
  const MirroringDriftRadar({super.key});

  @override
  State<MirroringDriftRadar> createState() => _MirroringDriftRadarState();
}

class _MirroringDriftRadarState extends State<MirroringDriftRadar> {
  final List<String> _traits = [
    "Token Overlap",
    "Theme Exposure",
    "Volatility",
    "Trade Frequency",
    "Sector Allocation",
    "Avg Trade Size"
  ];

  final List<double> _userData = [80, 65, 40, 70, 55, 60];
  final List<double> _idealData = [60, 70, 60, 80, 60, 70];

  bool _showDetails = false;

  double get averageDrift {
    double total = 0;
    for (int i = 0; i < _userData.length; i++) {
      total += ( (_userData[i] - _idealData[i]).abs() / 100 );
    }
    return (total / _userData.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mirroring Drift Radar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open rebalance modal
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text("Rebalance"),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  radarBackgroundColor: Colors.transparent,
                  dataSets: [
                    RadarDataSet(
                      dataEntries: _userData.map((e) => RadarEntry(value: e)).toList(),
                      borderColor: Colors.blueAccent,
                      fillColor: Colors.blueAccent.withOpacity(0.3),
                      entryRadius: 2.5,
                      borderWidth: 2,
                    ),
                    RadarDataSet(
                      dataEntries: _idealData.map((e) => RadarEntry(value: e)).toList(),
                      borderColor: Colors.green,
                      fillColor: Colors.green.withOpacity(0.2),
                      entryRadius: 2.5,
                      borderWidth: 2,
                    ),
                  ],
                  titleTextStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  getTitle: (index, angle) => RadarChartTitle(
                    text: _traits[index],
                    angle: angle,
                  ),
                  tickCount: 5,
                  ticksTextStyle: const TextStyle(color: Colors.grey, fontSize: 10),
                  tickBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Average Drift: ${averageDrift.toStringAsFixed(1)}%",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                IconButton(
                  icon: Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _showDetails = !_showDetails),
                )
              ],
            ),
            if (_showDetails)
              Column(
                children: List.generate(_traits.length, (index) {
                  final drift = (_userData[index] - _idealData[index]).abs();
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_traits[index]),
                    subtitle: Text("Drift: ${drift.toStringAsFixed(1)}%"),
                    trailing: Icon(Icons.info_outline_rounded, size: 18, color: Colors.grey[600]),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}
