// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\alerts_center.dart

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Alerts Center',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // Open alert preferences modal
              },
            )
          ],
        ),
        TabBar(
          controller: _tabController,
          tabs: tabs.map((t) => Tab(text: t)).toList(),
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.disabledColor,
          indicatorColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((tab) => _buildAlertList(tab)).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildAlertList(String tab) {
    final alerts = _dummyAlerts.where((a) => a['status'] == tab).toList();
    if (alerts.isEmpty) {
      return const Center(
        child: Text("You're clear for now ✅", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      itemCount: alerts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final Color urgencyColor = _urgencyColor(alert['urgency']);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
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
                Row(
                  children: [
                    Icon(alert['icon'], color: urgencyColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alert['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      alert['timeAgo'],
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  alert['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Simulate outcome modal
                      },
                      child: const Text('Simulate'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Follow-up reminder logic
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
