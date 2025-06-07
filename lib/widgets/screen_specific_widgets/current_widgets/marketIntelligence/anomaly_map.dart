
// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/anomaly_map.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnomalyMapWidget extends StatefulWidget {
  const AnomalyMapWidget({Key? key}) : super(key: key);

  @override
  State<AnomalyMapWidget> createState() => _AnomalyMapWidgetState();
}

class _AnomalyMapWidgetState extends State<AnomalyMapWidget> {
  String selectedTimeframe = '4h';
  String selectedFilter = 'All';
  String selectedSort = 'Impact';

  final List<Map<String, dynamic>> anomalies = [
    {
      'token': 'ARB',
      'change': '+45% TVL',
      'type': '🧬 On-chain',
      'badge': '🔥 Bridge Surge',
      'color': Colors.blueAccent,
    },
    {
      'token': 'JUP',
      'change': '+3.2K Tweets',
      'type': '📢 Social',
      'badge': '🧠 Social Spike',
      'color': Colors.purpleAccent,
    },
    {
      'token': 'SOL',
      'change': '>12M Moved',
      'type': '⛓️ Bridge',
      'badge': '🐳 Exit Signals',
      'color': Colors.grey,
    },
    {
      'token': 'PEPE',
      'change': 'Risk Flag',
      'type': '🔐 Security',
      'badge': '⚠️ Access Control Risk',
      'color': Colors.redAccent,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Anomaly Map", style: theme.textTheme.titleMedium),
                Row(
                  children: [
                    _buildDropdown(['1h', '4h', '24h'], selectedTimeframe,
                        (val) => setState(() => selectedTimeframe = val)),
                    const SizedBox(width: 8),
                    _buildDropdown(
                        ['All', 'On-chain', 'Social', 'Bridge', 'Security'],
                        selectedFilter,
                        (val) => setState(() => selectedFilter = val)),
                    const SizedBox(width: 8),
                    _buildDropdown(['Impact', 'Severity', 'Time'],
                        selectedSort, (val) => setState(() => selectedSort = val)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: anomalies.length,
                itemBuilder: (context, index) {
                  final anomaly = anomalies[index];
                  return _buildAnomalyTile(anomaly).animate().fadeIn().slideY();
                },
              ),
            ),
            const SizedBox(height: 8),
            // Insight Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.secondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.insights, size: 18),
                  const SizedBox(width: 8),
                  Text("🧠 Insight: Bridge volume to L2s +69% in past 4h",
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      List<String> options, String value, Function(String) onChanged) {
    return DropdownButton<String>(
      value: value,
      underline: Container(),
      style: Theme.of(context).textTheme.bodySmall,
      dropdownColor: Theme.of(context).cardColor,
      onChanged: (val) => onChanged(val!),
      items: options
          .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
          .toList(),
    );
  }

  Widget _buildAnomalyTile(Map<String, dynamic> anomaly) {
    final theme = Theme.of(context);
    final color = anomaly['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(anomaly['type'],
              style: theme.textTheme.labelLarge?.copyWith(color: color)),
          const SizedBox(height: 6),
          Text("\$${anomaly['token']} — ${anomaly['change']}",
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(anomaly['badge'],
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8))),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.visibility, size: 16),
              SizedBox(width: 8),
              Icon(Icons.track_changes, size: 16),
            ],
          ),
        ],
      ),
    );
  }
}
