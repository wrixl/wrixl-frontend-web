// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\my_activity_log.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ActivityType { trade, simulation, signal, vote }

class MyActivityLogWidget extends StatefulWidget {
  const MyActivityLogWidget({super.key});

  @override
  State<MyActivityLogWidget> createState() => _MyActivityLogWidgetState();
}

class _MyActivityLogWidgetState extends State<MyActivityLogWidget> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedActivities = _groupActivities(_dummyActivityData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Activity Log',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedFilter,
              items: ['All', 'Trades', 'Simulations', 'Signals', 'Votes']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedFilter = val!),
            )
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView(
            children: groupedActivities.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(entry.key,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.secondary)),
                  ),
                  ...entry.value
                      .where((a) =>
                          _selectedFilter == 'All' ||
                          a['typeLabel'] == _selectedFilter)
                      .map((activity) => _buildActivityCard(activity))
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final iconData = _getIcon(activity['type']);
    final color = _getColor(activity['type']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(iconData, color: color),
        ),
        title: Text(activity['title'],
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(activity['description']),
        trailing: TextButton(
          onPressed: () {
            // Navigate to view details
          },
          child: const Text('View'),
        ),
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupActivities(
      List<Map<String, dynamic>> activities) {
    final now = DateTime.now();
    final today = <Map<String, dynamic>>[];
    final yesterday = <Map<String, dynamic>>[];
    final thisWeek = <Map<String, dynamic>>[];
    final earlier = <Map<String, dynamic>>[];

    for (var activity in activities) {
      final ts = activity['timestamp'] as DateTime;
      final diff = now.difference(ts);

      if (diff.inDays == 0 && ts.day == now.day) {
        today.add(activity);
      } else if (diff.inDays == 1 || (diff.inDays == 0 && ts.day != now.day)) {
        yesterday.add(activity);
      } else if (diff.inDays <= 7) {
        thisWeek.add(activity);
      } else {
        earlier.add(activity);
      }
    }

    return {
      if (today.isNotEmpty) 'Today': today,
      if (yesterday.isNotEmpty) 'Yesterday': yesterday,
      if (thisWeek.isNotEmpty) 'This Week': thisWeek,
      if (earlier.isNotEmpty) 'Earlier': earlier,
    };
  }

  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.trade:
        return Icons.swap_horiz_rounded;
      case ActivityType.simulation:
        return Icons.auto_graph_rounded;
      case ActivityType.signal:
        return Icons.campaign_rounded;
      case ActivityType.vote:
        return Icons.how_to_vote_rounded;
    }
  }

  Color _getColor(ActivityType type) {
    switch (type) {
      case ActivityType.trade:
        return Colors.green;
      case ActivityType.simulation:
        return Colors.blue;
      case ActivityType.signal:
        return Colors.deepPurple;
      case ActivityType.vote:
        return Colors.orange;
    }
  }
}

final List<Map<String, dynamic>> _dummyActivityData = [
  {
    'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
    'type': ActivityType.simulation,
    'typeLabel': 'Simulations',
    'title': 'Simulated “L2 Yield Rotator”',
    'description': 'Projected gain: +3.2% at 85% confidence.',
  },
  {
    'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
    'type': ActivityType.trade,
    'typeLabel': 'Trades',
    'title': 'Traded ARB for ENA',
    'description': 'Rebalanced 12% of portfolio.',
  },
  {
    'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    'type': ActivityType.vote,
    'typeLabel': 'Votes',
    'title': 'Voted on “Signal DAO L2 Drift”',
    'description': 'Supported risk rotation proposal.',
  },
  {
    'timestamp': DateTime.now().subtract(const Duration(days: 4)),
    'type': ActivityType.signal,
    'typeLabel': 'Signals',
    'title': 'Activated “Narrative AI Surge”',
    'description': 'Signal added to mirrored portfolio.',
  },
];
