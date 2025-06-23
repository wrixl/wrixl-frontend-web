// lib/widgets/screen_specific_widgets/current_widgets/positions/position_next_best_action.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class PositionNextBestAction extends StatelessWidget {
  final NextBestAction action;
  final VoidCallback? onAct;
  final VoidCallback? onSnooze;

  const PositionNextBestAction({
    super.key,
    required this.action,
    this.onAct,
    this.onSnooze,
  });

  void _showActionModal(BuildContext context) {
    final theme = Theme.of(context);
    final urgencyColor = _urgencyColor(action.urgency, theme);
    showNewReusableModal(
      context,
      title: 'Next Best Action',
      size: WidgetModalSize.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            action.title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(action.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _tag(context, action.urgency, urgencyColor),
              _tag(context, 'Confidence: ${(action.confidence * 100).toStringAsFixed(0)}%'),
              _tag(context, action.window),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Snooze',
                onPressed: () {
                  Navigator.of(context).pop();
                  onSnooze?.call();
                },
                icon: Icon(Icons.snooze_rounded, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onAct?.call();
                },
                child: const Text('Act Now'),
              ),
            ],
          ),
          if (action.simulatedOutcome != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.simulatedOutcome!.impact,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.simulatedOutcome!.details,
                    style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String label, [Color? color]) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? theme.dividerColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color ?? theme.colorScheme.onSurface),
      ),
    );
  }

  Color _urgencyColor(String urgency, ThemeData theme) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
        return Colors.green;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgencyColor = _urgencyColor(action.urgency, theme);

    return GestureDetector(
      onTap: () => _showActionModal(context),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('📌 Next Best Action', style: theme.textTheme.titleMedium),
                  Icon(Icons.auto_fix_high_rounded, color: urgencyColor),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                action.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(action.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _tag(context, action.urgency, urgencyColor),
                      const SizedBox(width: 8),
                      _tag(context, 'Confidence: ${(action.confidence * 100).toStringAsFixed(0)}%'),
                      const SizedBox(width: 8),
                      _tag(context, action.window),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Snooze',
                        onPressed: onSnooze,
                        icon: const Icon(Icons.snooze_rounded),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: onAct,
                        child: const Text('Act Now'),
                      ),
                    ],
                  ),
                ],
              ),
              if (action.simulatedOutcome != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.simulatedOutcome!.impact,
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action.simulatedOutcome!.details,
                        style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NextBestAction {
  final String title;
  final String description;
  final String urgency;
  final double confidence;
  final String window;
  final SimulatedOutcome? simulatedOutcome;

  const NextBestAction({
    required this.title,
    required this.description,
    required this.urgency,
    required this.confidence,
    required this.window,
    this.simulatedOutcome,
  });
}

class SimulatedOutcome {
  final String impact;
  final String details;

  const SimulatedOutcome({
    required this.impact,
    required this.details,
  });
}

// Example dummy data
final NextBestAction dummyNextBestAction = NextBestAction(
  title: 'Rebalance Portfolio',
  description: 'You’re overexposed to volatile L1s. Redistribute to reduce downside risk.',
  urgency: 'High',
  confidence: 0.87,
  window: 'Act within 3h',
  simulatedOutcome: SimulatedOutcome(
    impact: '+3.2% projected delta',
    details:
        'Improves Sharpe ratio and reduces downside risk by 20% if rebalanced now.',
  ),
);
