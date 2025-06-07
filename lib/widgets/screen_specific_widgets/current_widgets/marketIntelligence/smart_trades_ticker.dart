// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\smart_trades_ticker.dart

import 'package:flutter/material.dart';

class SmartTradesTickerWidget extends StatelessWidget {
  const SmartTradesTickerWidget({super.key});

  final List<Map<String, dynamic>> trades = const [
    {
      'token': 'JUP',
      'wallet': '@SmartVC',
      'amount': '120K',
      'type': 'buy',
      'time': '2m ago',
      'tag': 'Narrative Rotation',
    },
    {
      'token': 'WIF',
      'wallet': '@WhaleAlpha007',
      'amount': '85K',
      'type': 'sell',
      'time': '4m ago',
      'tag': 'Token Exit',
    },
    {
      'token': 'PYTH',
      'wallet': 'VCFund_B',
      'amount': '230K',
      'type': 'buy',
      'time': '7m ago',
      'tag': 'Dip Buy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Smart Trades Ticker',
                  style: textTheme.titleMedium,
                ),
                Icon(Icons.trending_up, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 12),
            // Ticker Body
            ...trades.map((trade) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: trade['type'] == 'buy'
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    child: Text(
                      trade['token'],
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trade['wallet'],
                          style: textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${trade['type'] == 'buy' ? 'Bought' : 'Sold'} ${trade['amount']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: trade['type'] == 'buy'
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        trade['time'],
                        style: textTheme.bodySmall!
                            .copyWith(color: scheme.onSurface.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (trade['tag'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                trade['tag'],
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Icon(Icons.remove_red_eye,
                              size: 16,
                              color: scheme.onSurface.withOpacity(0.5)),
                          const SizedBox(width: 4),
                          Icon(Icons.notifications_none,
                              size: 16,
                              color: scheme.onSurface.withOpacity(0.5)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
