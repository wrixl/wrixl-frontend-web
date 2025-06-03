// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\smart_trades_ticker.dart


import 'package:flutter/material.dart';

class SmartTradesTickerWidget extends StatefulWidget {
  const SmartTradesTickerWidget({super.key});

  @override
  State<SmartTradesTickerWidget> createState() => _SmartTradesTickerWidgetState();
}

class _SmartTradesTickerWidgetState extends State<SmartTradesTickerWidget> {
  final List<Map<String, dynamic>> trades = [
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
    return Card(
      color: Colors.black.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Smart Trades Ticker',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                Icon(Icons.filter_list, color: Colors.white70),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: trades.length,
                itemBuilder: (context, index) {
                  final trade = trades[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: trade['type'] == 'buy'
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              child: Text(trade['token'],
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.black)),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${trade['wallet']}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  '${trade['type'] == 'buy' ? 'Bought' : 'Sold'} ${trade['amount']}',
                                  style: TextStyle(
                                      color: trade['type'] == 'buy'
                                          ? Colors.greenAccent
                                          : Colors.redAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(trade['time'],
                                style: const TextStyle(color: Colors.white54)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (trade['tag'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(trade['tag'],
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white)),
                                  ),
                                const SizedBox(width: 6),
                                Icon(Icons.remove_red_eye,
                                    size: 16, color: Colors.white54),
                                const SizedBox(width: 4),
                                Icon(Icons.notifications_none,
                                    size: 16, color: Colors.white54),
                                const SizedBox(width: 4),
                                Icon(Icons.trending_up,
                                    size: 16, color: Colors.white54),
                              ],
                            )
                          ],
                        )
                      ],
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
}
