// lib\widgets\screen_specific_widgets\current_widgets\next_best_action_widget.dart

import 'package:flutter/material.dart';

class NextBestActionWidget extends StatefulWidget {
  const NextBestActionWidget({Key? key}) : super(key: key);

  @override
  State<NextBestActionWidget> createState() => _NextBestActionWidgetState();
}

class _NextBestActionWidgetState extends State<NextBestActionWidget> {
  bool _snoozed = false;

  final Map<String, dynamic> _dummyAction = {
    "title": "Rebalance Portfolio",
    "description":
        "You're overexposed to volatile L1s. Redistribute to reduce downside risk.",
    "urgency": "High",
    "confidence": 0.87,
    "window": "Act within 3h",
    "simulatedOutcome": {
      "impact": "+3.2% projected delta",
      "details":
          "If rebalanced now, projected improvement in Sharpe ratio and downside risk by 20%."
    }
  };

  Color _urgencyColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  void _showOutcomeModal(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = _dummyAction;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(data['title'], style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🧠 AI Rationale:",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(data['description'], style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text("🔍 Simulated Outcome:",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Text(data['simulatedOutcome']['impact'],
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: Colors.green)),
            Text(data['simulatedOutcome']['details'],
                style: theme.textTheme.bodyMedium),
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

  @override
  Widget build(BuildContext context) {
    if (_snoozed) {
      return Center(
        child: Text(
          "Next Best Action snoozed.",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final data = _dummyAction;

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt, color: scheme.primary, size: 20),
                      const SizedBox(width: 6),
                      Text("Next Best Action",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _urgencyColor(data['urgency']).withOpacity(0.1),
                      border: Border.all(
                          color: _urgencyColor(data['urgency']), width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      data['window'],
                      style: TextStyle(
                        color: _urgencyColor(data['urgency']),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.task_alt, size: 20, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['title'],
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(data['description'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurface.withOpacity(0.85),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: Colors.blue, size: 18),
                      const SizedBox(width: 4),
                      Text(
                          "Confidence: ${(data['confidence'] * 100).toStringAsFixed(0)}%",
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: Colors.blue)),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _showOutcomeModal(context),
                        icon: const Icon(Icons.analytics_outlined),
                        label: const Text("Simulate"),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => setState(() => _snoozed = true),
                        icon: const Icon(Icons.snooze),
                        label: const Text("Snooze"),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
