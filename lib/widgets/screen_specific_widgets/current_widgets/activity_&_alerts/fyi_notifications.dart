// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\fyi_notifications.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

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
      'message': 'You’ve reached 10 mirrored portfolios. “Strategist I” unlocked.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'cta': 'View Badge'
    },
    {
      'type': 'System',
      'icon': '🛠️',
      'title': 'System Update',
      'message': '“Smart Wallet Drift” signal engine improved. Confidence rates up to 7%.',
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

  void _openNotificationModal(Map<String, dynamic> n) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: n['title'],
        size: WidgetModalSize.small,
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(n['icon'], style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(n['message'], style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(formatDate(n['timestamp']),
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: your CTA navigation logic here
                Navigator.of(context).pop();
              },
              child: Text(n['cta'] ?? 'OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header row: title + category filter
            Row(
              children: [
                Expanded(
                  child: Text('FYI Notifications',
                      style: theme.textTheme.titleMedium),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  style: theme.textTheme.bodyMedium,
                  dropdownColor: theme.cardColor,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(8),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedCategory = v);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // notification list
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotifications.length,
                itemBuilder: (ctx, i) {
                  final n = filteredNotifications[i];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: theme.colorScheme.surfaceVariant,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _openNotificationModal(n),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading:
                            Text(n['icon'], style: const TextStyle(fontSize: 24)),
                        title: Text(n['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n['message']),
                            const SizedBox(height: 4),
                            Text(formatDate(n['timestamp']),
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                        trailing: TextButton(
                          onPressed: () => _openNotificationModal(n),
                          child: Text(n['cta'] ?? 'View'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
