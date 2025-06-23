// lib/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/alerts_center.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class AlertsCenterWidget extends StatefulWidget {
  const AlertsCenterWidget({super.key});

  @override
  State<AlertsCenterWidget> createState() => _AlertsCenterWidgetState();
}

class _AlertsCenterWidgetState extends State<AlertsCenterWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['Active', 'Acknowledged', 'Cleared'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAlertModal(Map<String, dynamic> alert) {
    final Color urgencyColor = _urgencyColor(alert['urgency']);
    showNewReusableModal(
      context,
      title: alert['title'],
      size: WidgetModalSize.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and time
          Row(
            children: [
              Icon(alert['icon'], color: urgencyColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alert['title'],
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(alert['timeAgo'],
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(alert['description'],
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          // Urgency badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              alert['urgency'],
              style: TextStyle(color: urgencyColor, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: implement simulate logic
                },
                child: const Text('Simulate'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: implement remind-me logic
                },
                child: const Text('Remind Me'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    alert['status'] = 'Acknowledged';
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Acknowledge'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title & settings button
            Row(
              children: [
                Expanded(
                  child: Text('Alerts Center',
                      style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    // TODO: open preferences
                  },
                )
              ],
            ),
            const SizedBox(height: 8),
            // Tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.disabledColor,
                indicatorColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: tabs.map((tab) {
                  final alerts =
                      _dummyAlerts.where((a) => a['status'] == tab).toList();
                  if (alerts.isEmpty) {
                    return const Center(
                      child: Text("You're clear for now ✅",
                          style: TextStyle(fontSize: 16)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 4),
                    itemCount: alerts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return GestureDetector(
                        onTap: () => _showAlertModal(alert),
                        child: _buildAlertCard(alert),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final Color urgencyColor = _urgencyColor(alert['urgency']);
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: urgencyColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Icon(alert['icon'], color: urgencyColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(alert['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Text(alert['timeAgo'],
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                // Description
                Text(alert['description'],
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                // Inline action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _showAlertModal(alert);
                      },
                      child: const Text('Simulate'),
                    ),
                    TextButton(
                      onPressed: () {
                        _showAlertModal(alert);
                      },
                      child: const Text('Remind Me'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          alert['status'] = 'Acknowledged';
                        });
                      },
                      child: const Text('Acknowledge'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Critical':
        return Colors.redAccent;
      case 'High':
        return Colors.orange;
      case 'Moderate':
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }
}

// Dummy alert data
final List<Map<String, dynamic>> _dummyAlerts = [
  {
    'title': 'Whale Wallet Exit Alert',
    'description': 'Wallet 0xAbc... just moved 90% out of your L1 assets.',
    'timeAgo': '2m ago',
    'urgency': 'Critical',
    'icon': Icons.warning_amber_outlined,
    'status': 'Active',
  },
  {
    'title': 'Strategy Signal Risk',
    'description': 'Signal “AI L2 Edge” has dropped in confidence by 30%.',
    'timeAgo': '10m ago',
    'urgency': 'High',
    'icon': Icons.bolt_outlined,
    'status': 'Active',
  },
  {
    'title': 'Smart Money Reallocation',
    'description':
        'Multiple top wallets are rotating into Stable Yield tokens.',
    'timeAgo': '30m ago',
    'urgency': 'Moderate',
    'icon': Icons.trending_up_outlined,
    'status': 'Acknowledged',
  },
  {
    'title': 'No active alerts',
    'description': 'You recently acknowledged all alerts. 🎉',
    'timeAgo': '1h ago',
    'urgency': 'FYI',
    'icon': Icons.check_circle_outline,
    'status': 'Cleared',
  },
];
