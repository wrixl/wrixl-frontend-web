// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\narrative_velocity_tracker.dart

import 'dart:math';
import 'package:flutter/material.dart';

class NarrativeVelocityTracker extends StatefulWidget {
  const NarrativeVelocityTracker({Key? key}) : super(key: key);

  @override
  State<NarrativeVelocityTracker> createState() => _NarrativeVelocityTrackerState();
}

class _NarrativeVelocityTrackerState extends State<NarrativeVelocityTracker> {
  String _selectedTimeframe = '1H';

  final List<String> timeframes = ['1H', '4H', '24H', '7D'];

  final Map<String, List<Map<String, dynamic>>> _mockData = {
    '1H': [
      {'tag': 'AI', 'delta': 138, 'trend': '🔥 Trending Everywhere'},
      {'tag': 'Real World Assets', 'delta': 92, 'trend': '↗ Breaking Out'},
      {'tag': 'Telegram Coins', 'delta': 75, 'trend': '↗ Meme + Network Combo'},
      {'tag': 'Liquid Staking', 'delta': 58, 'trend': '⬆ Momentum Building'},
      {'tag': 'Bitcoin Layer 2s', 'delta': 41, 'trend': '⬆ Infrastructure Buzz'},
    ],
    '4H': [
      {'tag': 'AI', 'delta': 110, 'trend': '🔥 Trending Everywhere'},
      {'tag': 'DePIN', 'delta': 82, 'trend': '↗ Infra + Real World'},
      {'tag': 'Solana Memes', 'delta': 68, 'trend': '⬆ Community Surge'},
      {'tag': 'Tokenized RWAs', 'delta': 55, 'trend': '⬆ Institutional Interest'},
      {'tag': 'Base Ecosystem', 'delta': 43, 'trend': '⬆ Building Buzz'},
    ],
    '24H': [
      {'tag': 'AI', 'delta': 89, 'trend': '↗ Strong Momentum'},
      {'tag': 'Memecoins', 'delta': 74, 'trend': '↗ Reddit + Telegram Fuel'},
      {'tag': 'ETH Restaking', 'delta': 61, 'trend': '⬆ LST Buzz'},
      {'tag': 'Privacy Tokens', 'delta': 47, 'trend': '⬆ ZK Chatter Rising'},
      {'tag': 'ETH L2s', 'delta': 35, 'trend': '↗ Scaled Deployments'},
    ],
    '7D': [
      {'tag': 'AI', 'delta': 220, 'trend': '🔥 Dominating Week'},
      {'tag': 'RWAs', 'delta': 144, 'trend': '↗ Institutional Trend'},
      {'tag': 'GameFi', 'delta': 108, 'trend': '⬆ Revival Buzz'},
      {'tag': 'Telegram Coins', 'delta': 97, 'trend': '↗ Emerging'},
      {'tag': 'ETH ETF', 'delta': 88, 'trend': '⬆ Headlines + Bets'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _mockData[_selectedTimeframe]!;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header with title, tooltip, and toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    '🚀 Narrative Velocity Tracker',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Tracks how fast each narrative is gaining mentions across social and news platforms.',
                  child: const Icon(Icons.info_outline, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Timeframe toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: timeframes.map((tf) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(tf),
                    selected: _selectedTimeframe == tf,
                    onSelected: (_) {
                      setState(() {
                        _selectedTimeframe = tf;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            /// List of narrative entries
            ...data.map((narrative) {
              final int delta = narrative['delta'];
              final String tag = narrative['tag'];
              final String trend = narrative['trend'];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Text(
                        tag,
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '+$delta%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: delta > 100
                            ? Colors.deepOrange
                            : delta > 60
                                ? Colors.orange
                                : Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Text(
                        trend,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 16),
            Text(
              'Source: Twitter, Telegram, News (Real-Time)',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
