// lib\widgets\screen_specific_widgets\current_widgets\all_eyes_widget.dart

// lib\widgets\screen_specific_widgets\current_widgets\all_eyes_widget.dart

import 'package:flutter/material.dart';

class AllEyesWidget extends StatefulWidget {
  const AllEyesWidget({super.key});

  @override
  State<AllEyesWidget> createState() => _AllEyesWidgetState();
}

class _AllEyesWidgetState extends State<AllEyesWidget> {
  final List<String> _ranges = ["1h", "12h", "24h", "7d"];
  int _rangeIndex = 2;

  String get _selectedRange => _ranges[_rangeIndex];

  void _cycleRange() {
    setState(() => _rangeIndex = (_rangeIndex + 1) % _ranges.length);
  }

  List<_AllEyesEvent> _getEventsForRange(String range) {
    switch (range) {
      case "1h":
        return [
          _event(Icons.remove_red_eye, "WIF", "Attention", "+180%", "Now",
              "View Token"),
          _event(Icons.bolt, "OP Short", "Signal", "+7%", "12m ago", "Mirror"),
          _event(Icons.pie_chart, "L2 Index Fund", "Portfolio", "+12",
              "24m ago", "Compare"),
        ];
      case "12h":
        return [
          _event(Icons.remove_red_eye, "ETH", "Attention", "+260%", "Now",
              "View Token"),
          _event(
              Icons.bolt, "AAVE Long", "Signal", "+18%", "11m ago", "Mirror"),
          _event(Icons.swap_horiz, "Smart LPs → WIF", "Smart", "↗️", "30m ago",
              "View Shift"),
        ];
      case "24h":
        return [
          _event(Icons.trending_down, "L2 Summer", "Trend", "↘️", "2h ago",
              "Review"),
          _event(Icons.emoji_events, "Your Wrixl Rank", "User", "Top 5% ↑",
              "6h ago", "View"),
          _event(Icons.remove_red_eye, "USDC", "Attention", "+320%", "9h ago",
              "View Token"),
        ];
      case "7d":
        return [
          _event(Icons.pie_chart, "MegaCap Mix", "Portfolio", "+8.2%", "2d ago",
              "Track"),
          _event(Icons.star, "AI Portfolio Launch", "Alert", "Live", "3d ago",
              "Explore"),
          _event(Icons.emoji_events, "Wrixl User Count", "Platform", "+12%",
              "6d ago", "See Stats"),
        ];
      default:
        return [];
    }
  }

  _AllEyesEvent _event(IconData icon, String label, String category,
      String change, String timestamp, String cta) {
    return _AllEyesEvent(
      icon: icon,
      label: label,
      category: category,
      change: change,
      timestamp: timestamp,
      cta: cta,
    );
  }

  Color _getBadgeColor(String category) {
    switch (category.toLowerCase()) {
      case 'attention':
        return Colors.orange;
      case 'signal':
        return Colors.blueAccent;
      case 'smart':
        return Colors.purple;
      case 'trend':
        return Colors.red;
      case 'portfolio':
        return Colors.teal;
      case 'platform':
        return Colors.indigo;
      case 'user':
        return Colors.amber;
      case 'alert':
      default:
        return Colors.deepOrangeAccent;
    }
  }

  void _showEventModal(_AllEyesEvent event) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(event.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${event.category}"),
            Text("Change: ${event.change}"),
            Text("When: ${event.timestamp}"),
            const SizedBox(height: 12),
            Text("Suggested Action: ${event.cta}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                )),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")),
        ],
      ),
    );
  }

  Widget _pulseDot() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.7),
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final events = _getEventsForRange(_selectedRange);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧠 Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("All Eyes 👁",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: _cycleRange,
                icon: const Icon(Icons.schedule, size: 18),
                label: Text(_selectedRange),
                style: TextButton.styleFrom(
                  backgroundColor: scheme.surfaceVariant.withOpacity(0.15),
                  foregroundColor: scheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          const SizedBox(height: 14),

          // 📈 Event List
          ...events.map((event) {
            final isHot =
                event.timestamp == "Now" || event.change.contains("+");
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                key: ValueKey("${event.label}|$_selectedRange"),
                onTap: () => _showEventModal(event),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.surfaceVariant.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(event.icon, color: scheme.primary, size: 20),
                      const SizedBox(width: 12),
                      if (isHot) _pulseDot(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.label,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getBadgeColor(event.category)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(event.category,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: _getBadgeColor(event.category),
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                const SizedBox(width: 8),
                                Text(event.change,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 12,
                                      color: event.change.contains('+')
                                          ? Colors.greenAccent
                                          : event.change.contains('-')
                                              ? Colors.redAccent
                                              : scheme.onSurface
                                                  .withOpacity(0.6),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(event.timestamp,
                              style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 11,
                                  color: scheme.onSurface.withOpacity(0.5))),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () => _showEventModal(event),
                            style: TextButton.styleFrom(
                              backgroundColor: scheme.primary.withOpacity(0.15),
                              foregroundColor: scheme.primary,
                              minimumSize: const Size(48, 30),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                            child: Text(event.cta,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AllEyesEvent {
  final IconData icon;
  final String label;
  final String category;
  final String change;
  final String timestamp;
  final String cta;

  _AllEyesEvent({
    required this.icon,
    required this.label,
    required this.category,
    required this.change,
    required this.timestamp,
    required this.cta,
  });
}
