
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildDropdown('Timeframe', ['1h', '4h', '24h'], selectedTimeframe,
                  (val) => setState(() => selectedTimeframe = val)),
              const SizedBox(width: 8),
              _buildDropdown('Filter', ['All', 'On-chain', 'Social', 'Bridge', 'Security'],
                  selectedFilter, (val) => setState(() => selectedFilter = val)),
              const SizedBox(width: 8),
              _buildDropdown('Sort', ['Impact', 'Severity', 'Time'],
                  selectedSort, (val) => setState(() => selectedSort = val)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
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
        Container(
          color: theme.colorScheme.secondary.withOpacity(0.05),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.insights, size: 20),
              SizedBox(width: 8),
              Text("🧠 Insight: Bridge volume to L2s +69% in past 4h"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options, String value, Function(String) onChanged) {
    return DropdownButton<String>(
      value: value,
      underline: Container(height: 1, color: Colors.grey),
      onChanged: (val) => onChanged(val!),
      items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }

  Widget _buildAnomalyTile(Map<String, dynamic> anomaly) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: anomaly['color'].withOpacity(0.1),
        border: Border.all(color: anomaly['color'], width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(anomaly['type'], style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Text("\$${anomaly['token']} — ${anomaly['change']}",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(anomaly['badge'], style: theme.textTheme.bodyMedium),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.visibility, size: 18),
              SizedBox(width: 8),
              Icon(Icons.track_changes, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
