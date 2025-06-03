// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\signal_accuracy_leaderboard.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignalAccuracyLeaderboard extends StatefulWidget {
  const SignalAccuracyLeaderboard({Key? key}) : super(key: key);

  @override
  State<SignalAccuracyLeaderboard> createState() =>
      _SignalAccuracyLeaderboardState();
}

class _SignalData {
  final String label;
  final IconData icon;
  final double accuracy; // 0 to 1
  final double avgReturn; // in percentage
  final int sampleCount;

  const _SignalData({
    required this.label,
    required this.icon,
    required this.accuracy,
    required this.avgReturn,
    required this.sampleCount,
  });
}

class _SignalAccuracyLeaderboardState extends State<SignalAccuracyLeaderboard> {
  String selectedTimeframe = "4h";
  bool viewAccuracy = true;

  final List<String> timeframeOptions = ["1h", "4h", "24h", "7d"];

  final List<_SignalData> signalData = const [
    _SignalData(
      label: "Whale Buys",
      icon: Icons.ssid_chart,
      accuracy: 0.84,
      avgReturn: 2.7,
      sampleCount: 122,
    ),
    _SignalData(
      label: "Bridge Drains",
      icon: Icons.lock_open,
      accuracy: 0.78,
      avgReturn: -3.2,
      sampleCount: 41,
    ),
    _SignalData(
      label: "Social Volume Spikes",
      icon: Icons.campaign,
      accuracy: 0.51,
      avgReturn: -0.9,
      sampleCount: 89,
    ),
    _SignalData(
      label: "AI Pattern Signals",
      icon: Icons.psychology_alt,
      accuracy: 0.71,
      avgReturn: 1.8,
      sampleCount: 64,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(theme),
            const Divider(),
            ...signalData.map((d) => _buildSignalRow(d, theme)),
            const SizedBox(height: 12),
            _buildSummaryBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("🎯 Signal Accuracy Leaderboard", style: theme.textTheme.titleMedium),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedTimeframe,
              onChanged: (v) => setState(() => selectedTimeframe = v!),
              items: timeframeOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text("⏱ $e")))
                  .toList(),
            ),
            const SizedBox(width: 12),
            ToggleButtons(
              isSelected: [viewAccuracy, !viewAccuracy],
              onPressed: (i) => setState(() => viewAccuracy = i == 0),
              children: const [Text("Accuracy %"), Text("ROI Δ")],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignalRow(_SignalData d, ThemeData theme) {
    final color = d.accuracy > 0.7
        ? Colors.greenAccent
        : d.accuracy > 0.5
            ? Colors.orangeAccent
            : Colors.redAccent;

    final labelText = viewAccuracy
        ? "✅ ${(d.accuracy * 100).toStringAsFixed(1)}%"
        : "${d.avgReturn >= 0 ? "📈" : "📉"} ${d.avgReturn.toStringAsFixed(1)}% avg";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(d.icon, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(d.label, style: theme.textTheme.bodyLarge)),
          Text(labelText),
          const SizedBox(width: 12),
          Text("(${d.sampleCount} samples)", style: theme.textTheme.bodySmall),
          const SizedBox(width: 12),
          TextButton(onPressed: () {}, child: const Text("[View]")),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "🧠 Summary: Whale alerts outperform across all timeframes",
        textAlign: TextAlign.center,
      ),
    );
  }
}