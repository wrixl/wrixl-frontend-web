// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\signal_accuracy_leaderboard.dart

import 'package:flutter/material.dart';

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
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(theme),
            const SizedBox(height: 12),
            ...signalData.map((d) => _buildSignalRow(d, theme, scheme)),
            const SizedBox(height: 16),
            _buildSummaryBar(theme, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Signal Accuracy Leaderboard", style: theme.textTheme.titleMedium),
        Row(
          children: [
            DropdownButton<String>(
              value: selectedTimeframe,
              onChanged: (v) => setState(() => selectedTimeframe = v!),
              borderRadius: BorderRadius.circular(8),
              items: timeframeOptions
                  .map((e) => DropdownMenuItem(value: e, child: Text("⏱ $e")))
                  .toList(),
            ),
            const SizedBox(width: 8),
            ToggleButtons(
              isSelected: [viewAccuracy, !viewAccuracy],
              onPressed: (i) => setState(() => viewAccuracy = i == 0),
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Accuracy %")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("ROI Δ")),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignalRow(_SignalData d, ThemeData theme, ColorScheme scheme) {
    final Color labelColor = d.accuracy >= 0.7
        ? scheme.secondary
        : d.accuracy >= 0.5
            ? Colors.orangeAccent
            : scheme.error;

    final String labelText = viewAccuracy
        ? "✅ ${(d.accuracy * 100).toStringAsFixed(1)}%"
        : "${d.avgReturn >= 0 ? "📈" : "📉"} ${d.avgReturn.toStringAsFixed(1)}% avg";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(d.icon, color: labelColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.label, style: theme.textTheme.bodyLarge),
                Row(
                  children: [
                    Text(labelText,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                    const SizedBox(width: 8),
                    Text("(${d.sampleCount} samples)",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6))),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("View"),
            style: TextButton.styleFrom(
              foregroundColor: scheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(ThemeData theme, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "🧠 Summary: Whale alerts outperform across all timeframes",
        style: theme.textTheme.bodyMedium?.copyWith(
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
