// lib\widgets\screen_specific_widgets\current_widgets\live_ticker_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';
import 'package:tiny_charts/tiny_charts.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class LiveTickerStreamer extends StatefulWidget {
  const LiveTickerStreamer({Key? key}) : super(key: key);

  @override
  State<LiveTickerStreamer> createState() => _LiveTickerStreamerState();
}

class _LiveTickerStreamerState extends State<LiveTickerStreamer> {
  String activeTickerType = 'all';
  String searchQuery = '';

  final List<String> filters = [
    'all',
    'whale',
    'fund',
    'degen',
    'fresh wallets',
    'smart lps',
    'defi',
    'rotation',
    'ai',
    'sell',
    'l2',
  ];

  final Map<String, IconData> filterIcons = {
    'all': Icons.all_inclusive,
    'whale': Icons.waves,
    'fund': Icons.pie_chart,
    'degen': Icons.flash_on,
    'fresh wallets': Icons.new_releases,
    'smart lps': Icons.science,
    'defi': Icons.auto_graph,
    'rotation': Icons.swap_horiz,
    'ai': Icons.memory,
    'sell': Icons.trending_down,
    'l2': Icons.device_hub,
  };

  final List<String> tickerMessages = [
    'Whale 0xA1B bought 2.5M USDT on Base',
    'Fund Alpha rotated from L2s into BTC',
    'Fresh wallet deposited 200K into Curve',
    'Smart LP added 1M liquidity to Uniswap v3',
    'Degen wallet YOLO’d into PEPE options',
    'Whale 0xF22 moved 5K ETH to Coinbase',
    'AI Wallet bought AGIX and FET aggressively',
    'Rotation detected from stablecoins to meme tokens',
    'L2 activity spike: 3.2M bridged to Optimism',
    'Sell-off: Wallet 0x88D dumped 10M ARB tokens',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Header row with filters and search
// 🔥 Header row with title → filters → search (right-aligned)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 12,
              spacing: 20,
              children: [
                // Title section
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up,
                        color: colorScheme.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "Live Ticker Streamer",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Toggle filters
                ToggleFilterIconRowWidget(
                  options: filters,
                  optionIcons: filterIcons,
                  activeOption: activeTickerType,
                  onSelected: (option) {
                    setState(() => activeTickerType = option);
                  },
                ),

                // Search bar aligned right
                SizedBox(
                  width: 200,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Activity",
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceVariant.withOpacity(0.2),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                    ),
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🌀 Ticker stream
            SizedBox(
              height: 80,
              child: Marqueer.builder(
                itemCount: tickerMessages.length,
                pps: 40,
                direction: MarqueerDirection.rtl,
                interaction: true,
                restartAfterInteraction: true,
                restartAfterInteractionDuration: const Duration(seconds: 3),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                separatorBuilder: (_, __) => const SizedBox(width: 40),
                itemBuilder: (context, index) {
                  final message = tickerMessages[index];
                  final category = _randomCategory();
                  final timestamp = _formattedNow();
                  final trend = _generateTrend();
                  final isPositive = trend.last > trend.first;

                  if (activeTickerType != 'all' &&
                      !category.toLowerCase().contains(activeTickerType)) {
                    return const SizedBox.shrink();
                  }
                  if (!message
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase())) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () => _showTickerModal(context, message),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorScheme.surface.withOpacity(0.9),
                          border: Border.all(
                            color: isPositive
                                ? AppConstants.neonGreen
                                : AppConstants.neonRed,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isPositive
                                      ? AppConstants.neonGreen
                                      : AppConstants.neonRed)
                                  .withOpacity(0.12),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color:
                                      colorScheme.onSurface.withOpacity(0.95),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppConstants.accentColor
                                        .withOpacity(0.12),
                                  ),
                                  child: Text(
                                    category,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                        color: colorScheme.onSurface),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  timestamp,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 22,
                                  width: 80,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 600),
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.2, 0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    ),
                                    child: TinyColumnChart(
                                      key: ValueKey(index),
                                      data: trend,
                                      width: 80,
                                      height: 22,
                                      options: TinyColumnChartOptions(
                                        positiveColor: AppConstants.neonGreen,
                                        negativeColor: AppConstants.neonRed,
                                        showAxis: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  void _showTickerModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Wallet Activity Details'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formattedNow() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} • ${now.month}/${now.day}";
  }

  String _randomCategory() {
    const categories = [
      'Whale',
      'DeFi',
      'Rotation',
      'AI Wallet',
      'Sell-Off',
      'L2 Shift',
    ];
    return categories[Random().nextInt(categories.length)];
  }

  List<double> _generateTrend() {
    final rng = Random();
    double value = 0;
    return List.generate(7, (_) {
      value += rng.nextDouble() * 4 - 2;
      return value.clamp(-10, 10);
    });
  }
}
