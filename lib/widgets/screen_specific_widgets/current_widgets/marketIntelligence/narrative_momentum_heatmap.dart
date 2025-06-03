// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\narrative_momentum_heatmap.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class NarrativeMomentumHeatmap extends StatefulWidget {
  const NarrativeMomentumHeatmap({Key? key}) : super(key: key);

  @override
  State<NarrativeMomentumHeatmap> createState() => _NarrativeMomentumHeatmapState();
}

class _NarrativeData {
  final String label;
  final double velocity;
  final String trend;
  final List<String> topTokens;

  const _NarrativeData({
    required this.label,
    required this.velocity,
    required this.trend,
    required this.topTokens,
  });
}

class _NarrativeMomentumHeatmapState extends State<NarrativeMomentumHeatmap> {
  String selectedTimeframe = "1H";

  final List<String> timeframes = ["1H", "4H", "24H", "7D"];

  final List<_NarrativeData> dummyData = [
    _NarrativeData(label: "AI", velocity: 148, trend: "Exploding", topTokens: ["FET", "AGIX", "TAO"]),
    _NarrativeData(label: "Real World Assets", velocity: 92, trend: "Rising", topTokens: ["RWA", "CFG", "MKR"]),
    _NarrativeData(label: "Memecoins", velocity: -6, trend: "Cooling", topTokens: ["DOGE", "WIF", "BONK"]),
    _NarrativeData(label: "Liquid Staking", velocity: 28, trend: "Stable", topTokens: ["LDO", "RPL"]),
    _NarrativeData(label: "Ethereum Layer2s", velocity: 4, trend: "No Change", topTokens: ["ARB", "OP"]),
  ];

  Color _getColor(double velocity) {
    if (velocity >= 100) return Colors.redAccent;
    if (velocity >= 25) return Colors.amber;
    if (velocity >= 0) return Colors.blueAccent;
    return Colors.grey;
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case "Exploding":
        return Icons.whatshot;
      case "Rising":
        return Icons.trending_up;
      case "Cooling":
        return Icons.ac_unit;
      case "Stable":
        return Icons.stacked_line_chart;
      case "No Change":
      default:
        return Icons.horizontal_rule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text("🔥 Narrative Momentum Heatmap", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  Tooltip(message: "Visualizes velocity of narrative momentum", child: const Icon(Icons.info_outline, size: 16)),
                ]),
                DropdownButton<String>(
                  value: selectedTimeframe,
                  underline: const SizedBox(),
                  onChanged: (value) => setState(() => selectedTimeframe = value ?? "1H"),
                  items: timeframes.map((tf) => DropdownMenuItem(value: tf, child: Text(tf))).toList(),
                )
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: dummyData.map((data) {
                return InkWell(
                  onTap: () => _showNarrativeDetails(context, data),
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getColor(data.velocity).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getColor(data.velocity), width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(data.label,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Icon(_getTrendIcon(data.trend), size: 18, color: _getColor(data.velocity))
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text("${data.velocity > 0 ? "+" : ""}${data.velocity.toStringAsFixed(0)}%",
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(data.trend, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text("Tokens: ${data.topTokens.join(", ")}",
                            style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[700]))
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  void _showNarrativeDetails(BuildContext context, _NarrativeData data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(data.label),
        content: Text(
          "Velocity: ${data.velocity}%\nTrend: ${data.trend}\nTokens involved: ${data.topTokens.join(", ")}\n\nThis narrative is ${data.trend.toLowerCase()} with significant velocity shift."),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))],
      ),
    );
  }
}
