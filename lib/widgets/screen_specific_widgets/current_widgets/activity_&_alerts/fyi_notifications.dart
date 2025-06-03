// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\fyi_notifications.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FyiNotificationsWidget extends StatefulWidget {
  const FyiNotificationsWidget({super.key});

  @override
  State<FyiNotificationsWidget> createState() => _FyiNotificationsWidgetState();
}

class _FyiNotificationsWidgetState extends State<FyiNotificationsWidget> {
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> notifications = [
    {
      'type': 'Completed',
      'icon': '✅',
      'title': 'Simulation Complete',
      'message': 'Your “L2 Yield Rotator” sim has finished. Result: +3.2%',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      'cta': 'View Results'
    },
    {
      'type': 'Social',
      'icon': '🏅',
      'title': 'Badge Earned',
      'message':
          'You’ve reached 10 mirrored portfolios. “Strategist I” unlocked.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'cta': 'View Badge'
    },
    {
      'type': 'System',
      'icon': '🛠️',
      'title': 'System Update',
      'message':
          '“Smart Wallet Drift” signal engine improved. Confidence rates up to 7%.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'cta': 'Learn More'
    },
  ];

  List<String> categories = ['All', 'Completed', 'Social', 'System'];

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedCategory == 'All') return notifications;
    return notifications.where((n) => n['type'] == selectedCategory).toList();
  }

  String formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notifDay = DateTime(dt.year, dt.month, dt.day);

    if (notifDay == today) return 'Today';
    if (notifDay == yesterday) return 'Yesterday';
    return DateFormat.yMMMd().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('FYI Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredNotifications.length,
            itemBuilder: (context, index) {
              final notif = filteredNotifications[index];
              return Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  leading:
                      Text(notif['icon'], style: const TextStyle(fontSize: 24)),
                  title: Text(notif['title'],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif['message']),
                      const SizedBox(height: 4),
                      Text(formatDate(notif['timestamp']),
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text(notif['cta'] ?? 'View'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
