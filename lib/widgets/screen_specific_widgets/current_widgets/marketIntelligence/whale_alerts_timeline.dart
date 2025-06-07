// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\whale_alerts_timeline.dart

import 'package:flutter/material.dart';
import 'dart:math';

class WhaleAlertsTimelineWidget extends StatefulWidget {
  const WhaleAlertsTimelineWidget({super.key});

  @override
  State<WhaleAlertsTimelineWidget> createState() => _WhaleAlertsTimelineWidgetState();
}

class _WhaleSignal {
  final DateTime time;
  final String token;
  final String action;
  final double amount;
  final double price;
  final double priceChange;
  final String tag;
  final String emoji;
  final String confidenceTag;
  final Color color;

  const _WhaleSignal({
    required this.time,
    required this.token,
    required this.action,
    required this.amount,
    required this.price,
    required this.priceChange,
    required this.tag,
    required this.emoji,
    required this.confidenceTag,
    required this.color,
  });
}

class _WhaleAlertsTimelineWidgetState extends State<WhaleAlertsTimelineWidget> {
  final List<_WhaleSignal> _signals = List.generate(8, (i) {
    final now = DateTime.now();
    final t = now.subtract(Duration(minutes: i * 47));
    final token = ['WIF', 'PYTH', 'JUP', 'ARB'][i % 4];
    final emoji = ['🐳', '🧠', '🔥', '📢'][i % 4];
    final tag = ['Exit', 'Buy Cluster', 'Sent to CEX', 'Whale Buy'][i % 4];
    final confidence = ['Strong Conviction', 'Slow Wallet', 'Fast Mover', 'High Confidence'][i % 4];
    return _WhaleSignal(
      time: t,
      token: token,
      action: i % 2 == 0 ? 'buy' : 'send',
      amount: Random().nextDouble() * 1.5 + 0.5,
      price: 0.25 + i * 0.03,
      priceChange: Random().nextDouble() * 4 - 2,
      tag: tag,
      emoji: emoji,
      confidenceTag: confidence,
      color: i % 2 == 0 ? Colors.greenAccent : Colors.redAccent,
    );
  });

  String _selectedDuration = '4h';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Whale Alerts Timeline", style: theme.textTheme.titleMedium),
                DropdownButton<String>(
                  value: _selectedDuration,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedDuration = val);
                  },
                  items: ['1h', '4h', '24h'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _signals.length,
                itemBuilder: (_, i) {
                  final s = _signals[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: s.color.withOpacity(0.06),
                        border: Border.all(color: s.color.withOpacity(0.4)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: s.color.withOpacity(0.2),
                            child: Text(s.emoji, style: const TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${s.token} — ${s.amount.toStringAsFixed(2)} ${s.action} @ \$${s.price.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${s.confidenceTag} • ${s.tag} • ${_formatTime(s.time)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${s.priceChange > 0 ? '+' : ''}${s.priceChange.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: s.priceChange > 0 ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],
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

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
