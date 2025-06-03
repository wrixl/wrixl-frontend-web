// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\ai_next_step.dart

// lib/widgets/screen_specific_widgets/current_widgets/activity_&_alerts/ai_next_step.dart

import 'package:flutter/material.dart';

class AINextStepWidget extends StatefulWidget {
  const AINextStepWidget({super.key});

  @override
  State<AINextStepWidget> createState() => _AINextStepWidgetState();
}

class _AINextStepWidgetState extends State<AINextStepWidget> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_dismissed) {
      return Center(
        child: Text(
          'No current suggestions. ✅',
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.secondary,
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_outlined, size: 28, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'AI Next Step',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Rebalance 12% from ARB into ENA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your portfolio is drifting from top-performing wallets.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Confidence: 87%',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Act within 3h ⏱️',
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.auto_graph_outlined),
                  onPressed: () {
                    // Simulate modal logic here
                  },
                  label: const Text('Simulate'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to action or strategy page
                  },
                  child: const Text('Take Action'),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Dismiss Suggestion',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() {
                      _dismissed = true;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
