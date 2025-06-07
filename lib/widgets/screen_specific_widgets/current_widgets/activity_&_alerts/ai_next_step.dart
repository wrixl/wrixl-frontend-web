// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\ai_next_step.dart

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
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 3,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No current suggestions. ✅',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_outlined, size: 24, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'AI Next Step',
                  style: theme.textTheme.titleMedium,
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
            Wrap(
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Confidence: 87%',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Act within 3h ⏱️',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
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
                    // Simulate modal logic
                  },
                  label: const Text('Simulate'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Action logic
                  },
                  child: const Text('Take Action'),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Dismiss Suggestion',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    setState(() => _dismissed = true);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
