// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_trades_ticker.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

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
            // ── Header ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smart Trades Ticker', style: textTheme.titleMedium),
                Icon(Icons.trending_up, color: scheme.primary),
              ],
            ),
            const SizedBox(height: 12),

            // ── Trades List ────────────────────────────────────────
            ...trades.map((trade) {
              final isBuy = trade['type'] == 'buy';
              final avatarColor =
                  isBuy ? Colors.greenAccent : Colors.redAccent;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  showNewReusableModal(
                    context,
                    title: '${trade['type'] == 'buy' ? 'Bought' : 'Sold'} ${trade['token']}',
                    size: WidgetModalSize.small,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Token & Wallet
                        Text(
                          'Token: ${trade['token']}',
                          style: textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Wallet: ${trade['wallet']}',
                            style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        // Amount & Type
                        Text(
                          'Amount: ${trade['amount']}',
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type: ${isBuy ? 'Buy' : 'Sell'}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: isBuy ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Time & Tag
                        Text('Time: ${trade['time']}', style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        if (trade['tag'] != null)
                          Text('Tag: ${trade['tag']}', style: textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        // Actions
                        Wrap(
                          spacing: 12,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.remove_red_eye),
                              label: const Text('View on Explorer'),
                              onPressed: () {},
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.notifications),
                              label: const Text('Alert on Trade'),
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: avatarColor,
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
                            Text(trade['wallet'],
                                style: textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(
                              '${isBuy ? 'Bought' : 'Sold'} ${trade['amount']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: avatarColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(trade['time'],
                              style: textTheme.bodySmall
                                  ?.copyWith(
                                      color: scheme.onSurface
                                          .withOpacity(0.6))),
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
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              Icon(Icons.remove_red_eye,
                                  size: 16,
                                  color:
                                      scheme.onSurface.withOpacity(0.5)),
                              const SizedBox(width: 4),
                              Icon(Icons.notifications_none,
                                  size: 16,
                                  color:
                                      scheme.onSurface.withOpacity(0.5)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
