// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\my_activity_log.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

enum ActivityType { trade, simulation, signal, vote }

class MyActivityLogWidget extends StatefulWidget {
  const MyActivityLogWidget({super.key});

  @override
  State<MyActivityLogWidget> createState() => _MyActivityLogWidgetState();
}

class _MyActivityLogWidgetState extends State<MyActivityLogWidget> {
  String _selectedFilter = 'All';

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

  Map<String, List<Map<String, dynamic>>> _groupActivities() {
    final now = DateTime.now();
    final todayList = <Map<String, dynamic>>[];
    final yesterdayList = <Map<String, dynamic>>[];
    final thisWeekList = <Map<String, dynamic>>[];
    final earlierList = <Map<String, dynamic>>[];

    for (var a in _dummyActivityData) {
      final ts = a['timestamp'] as DateTime;
      final diff = now.difference(ts);

      if (diff.inDays == 0 && ts.day == now.day) {
        todayList.add(a);
      } else if (diff.inDays == 1 ||
          (diff.inDays == 0 && ts.day != now.day)) {
        yesterdayList.add(a);
      } else if (diff.inDays <= 7) {
        thisWeekList.add(a);
      } else {
        earlierList.add(a);
      }
    }

    final Map<String, List<Map<String, dynamic>>> result = {};
    if (todayList.isNotEmpty) result['Today'] = todayList;
    if (yesterdayList.isNotEmpty) result['Yesterday'] = yesterdayList;
    if (thisWeekList.isNotEmpty) result['This Week'] = thisWeekList;
    if (earlierList.isNotEmpty) result['Earlier'] = earlierList;
    return result;
  }

  IconData _getIcon(ActivityType t) {
    switch (t) {
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

  Color _getColor(ActivityType t) {
    switch (t) {
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

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(dt.year, dt.month, dt.day);

    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat.yMMMd().format(dt);
  }

  void _openActivityModal(Map<String, dynamic> a) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: a['title'],
        size: WidgetModalSize.small,
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_getIcon(a['type']), size: 48, color: _getColor(a['type'])),
            const SizedBox(height: 12),
            Text(a['description'], style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(_formatDate(a['timestamp']),
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: details action
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grouped = _groupActivities();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header + filter dropdown
            Row(
              children: [
                Expanded(
                  child: Text('My Activity Log',
                      style: theme.textTheme.titleMedium),
                ),
                DropdownButton<String>(
                  value: _selectedFilter,
                  style: theme.textTheme.bodyMedium,
                  dropdownColor: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  underline: const SizedBox(),
                  items: const [
                    'All',
                    'Trades',
                    'Simulations',
                    'Signals',
                    'Votes'
                  ]
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedFilter = v!),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Grouped list
            Expanded(
              child: ListView(
                children: grouped.entries.expand((e) {
                  return [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(e.key,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondary)),
                    ),
                    ...e.value.where((a) =>
                        _selectedFilter == 'All' ||
                        a['typeLabel'] == _selectedFilter)
                      .map((a) => _buildActivityCard(a))
                  ];
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> act) {
    final icon = _getIcon(act['type']);
    final color = _getColor(act['type']);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openActivityModal(act),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          title:
              Text(act['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(act['description']),
          trailing: TextButton(
            onPressed: () => _openActivityModal(act),
            child: const Text('View'),
          ),
        ),
      ),
    );
  }
}
