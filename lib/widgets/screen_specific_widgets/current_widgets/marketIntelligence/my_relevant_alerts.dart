// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\my_relevant_alerts.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyRelevantAlertsWidget extends StatefulWidget {
  const MyRelevantAlertsWidget({super.key});

  @override
  State<MyRelevantAlertsWidget> createState() => _MyRelevantAlertsWidgetState();
}

class _MyRelevantAlertsWidgetState extends State<MyRelevantAlertsWidget> {
  final List<_Alert> alerts = [
    _Alert(
      emoji: '🐳',
      token: 'WIF',
      context: 'Whale Exit @ \$0.28',
      confidence: 92,
      exposure: 'High',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      actions: ['View Signal', 'Ignore', 'Add Note'],
    ),
    _Alert(
      emoji: '🧠',
      token: 'PYTH',
      context: 'AI Buy Cluster Detected',
      confidence: 86,
      exposure: 'In Portfolio',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      actions: ['Simulate Impact', 'Add to Watchlist'],
    ),
    _Alert(
      emoji: '📢',
      token: 'JUP',
      context: 'Trending Social Momentum',
      confidence: 61,
      exposure: 'Watching',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      actions: ['Open Chart', 'Dismiss'],
    ),
  ];

  String selectedTimeframe = '24h';
  String selectedSource = 'All';
  String selectedSort = 'Urgency';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('⚠️ My Relevant Alerts', style: theme.textTheme.headlineSmall),
            const Spacer(),
            _buildDropdown('Timeframe', selectedTimeframe, ['1h', '4h', '24h', '7d'], (v) => setState(() => selectedTimeframe = v!)),
            const SizedBox(width: 12),
            _buildDropdown('Source', selectedSource, ['All', 'Holdings', 'Watchlist'], (v) => setState(() => selectedSource = v!)),
            const SizedBox(width: 12),
            _buildDropdown('Sort', selectedSort, ['Urgency', 'Confidence', 'Time'], (v) => setState(() => selectedSort = v!)),
          ],
        ),
        const SizedBox(height: 16),
        ...alerts.map((alert) => _buildAlertCard(alert)).toList(),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: value,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    );
  }

  Widget _buildAlertCard(_Alert alert) {
    final theme = Theme.of(context);
    final confidenceColor = alert.confidence >= 80
        ? Colors.green
        : alert.confidence >= 60
            ? Colors.orange
            : Colors.red;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${alert.emoji} \$${alert.token} — ${alert.context}', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Confidence: ${alert.confidence}%  |  Exposure: ${alert.exposure}  |  ${_formatTimestamp(alert.timestamp)}',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: alert.confidence / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(confidenceColor),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: alert.actions.map((action) => ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action, style: const TextStyle(fontSize: 12)),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(dt);
  }
}

class _Alert {
  final String emoji;
  final String token;
  final String context;
  final int confidence;
  final String exposure;
  final DateTime timestamp;
  final List<String> actions;

  _Alert({
    required this.emoji,
    required this.token,
    required this.context,
    required this.confidence,
    required this.exposure,
    required this.timestamp,
    required this.actions,
  });
}
