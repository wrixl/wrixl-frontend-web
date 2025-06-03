// lib\widgets\screen_specific_widgets\current_widgets\alerts_widget.dart

// lib\widgets\screen_specific_widgets\current_widgets\alerts_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlertItem {
  final int id;
  final DateTime timestamp;
  final String status; // Active, Acknowledged, Cleared
  final String category; // Volatility, Security, Wallet, Signal
  final String summary;
  final Color color;
  final String suggestedAction;

  AlertItem({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.category,
    required this.summary,
    required this.color,
    required this.suggestedAction,
  });
}

class AlertsWidget extends StatefulWidget {
  const AlertsWidget({super.key});

  @override
  State<AlertsWidget> createState() => _AlertsWidgetState();
}

class _AlertsWidgetState extends State<AlertsWidget> {
  String _activeFilter = 'Active';

  final List<String> _statusFilters = ['Active', 'Acknowledged', 'Cleared'];
  final Map<String, IconData> _icons = {
    'Active': Icons.priority_high,
    'Acknowledged': Icons.check_circle_outline,
    'Cleared': Icons.done_all,
  };

  final List<AlertItem> _alerts = [
    AlertItem(
      id: 1001,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      status: 'Active',
      category: 'Volatility',
      summary: 'SOL +17% in 2h. Volume spike detected.',
      color: Colors.orange,
      suggestedAction: 'Simulate strategy impact',
    ),
    AlertItem(
      id: 1002,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      status: 'Active',
      category: 'Security',
      summary: 'Wallet drain alert: 0xAbc… flagged for abnormal outflow.',
      color: Colors.red,
      suggestedAction: 'View wallet details',
    ),
    AlertItem(
      id: 1003,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      status: 'Acknowledged',
      category: 'Signal',
      summary: 'Buy signal fired: AAVE Long Momentum (92% confidence)',
      color: Colors.green,
      suggestedAction: 'Review signal or mirror trade',
    ),
    AlertItem(
      id: 1004,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      status: 'Cleared',
      category: 'News',
      summary: 'LayerZero exploit patched, CVE disclosed.',
      color: Colors.deepPurple,
      suggestedAction: 'No action required',
    ),
  ];

  void _showAlertModal(AlertItem alert) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: alert.color),
            const SizedBox(width: 8),
            Text("Alert Details", style: theme.textTheme.titleLarge),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _modalLine("🗂 Category", alert.category),
            _modalLine("⏱ Timestamp",
                DateFormat('MMM d, HH:mm').format(alert.timestamp)),
            _modalLine("📋 Summary", alert.summary),
            const SizedBox(height: 12),
            Text("🔧 Suggested Action", style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text("→ ${alert.suggestedAction}",
                style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600, color: scheme.primary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _modalLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: '$label: ',
          style:
              const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final filtered = _alerts.where((a) => a.status == _activeFilter).toList();

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: scheme.primary, size: 20),
                    const SizedBox(width: 6),
                    Text("Alerts",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                ToggleButtons(
                  isSelected:
                      _statusFilters.map((s) => s == _activeFilter).toList(),
                  onPressed: (index) {
                    setState(() => _activeFilter = _statusFilters[index]);
                  },
                  borderRadius: BorderRadius.circular(10),
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 32),
                  selectedColor: Colors.white,
                  fillColor: scheme.primary,
                  children: _statusFilters
                      .map((s) => Icon(_icons[s], size: 18))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Alert List
            ...filtered.take(5).map((alert) => GestureDetector(
                  onTap: () => _showAlertModal(alert),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: alert.color.withOpacity(0.08),
                      border: Border.all(color: alert.color.withOpacity(0.4)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        Icon(Icons.circle, color: alert.color, size: 10),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.summary,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: scheme.onSurface)),
                              const SizedBox(height: 2),
                              Text(
                                "${alert.category} • ${DateFormat.Hm().format(alert.timestamp)}",
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white60, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right,
                            size: 20, color: Colors.white54),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
