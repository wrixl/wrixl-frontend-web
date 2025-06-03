// lib\widgets\screen_specific_widgets\current_widgets\positions\position_next_best_action.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgencyColor = _urgencyColor(action.urgency, theme);
    final formatter = NumberFormat.compactCurrency(symbol: '\$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_fix_high_rounded, size: 28, color: urgencyColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.description,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _tag(context, action.urgency, urgencyColor),
                  const SizedBox(width: 8),
                  _tag(context,
                      'Confidence: ${(action.confidence * 100).toStringAsFixed(0)}%'),
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
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.simulatedOutcome!.details,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )
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
        color: color?.withOpacity(0.1) ?? theme.dividerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall
            ?.copyWith(color: color ?? theme.colorScheme.onSurface),
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

final NextBestAction dummyNextBestAction = NextBestAction(
  title: 'Rebalance Portfolio',
  description:
      'You’re overexposed to volatile L1s. Redistribute to reduce downside risk.',
  urgency: 'High',
  confidence: 0.87,
  window: 'Act within 3h',
  simulatedOutcome: SimulatedOutcome(
    impact: '+3.2% projected delta',
    details:
        'Improves Sharpe ratio and reduces downside risk by 20% if rebalanced now.',
  ),
);
