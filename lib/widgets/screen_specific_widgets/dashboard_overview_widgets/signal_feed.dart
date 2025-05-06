// lib\widgets\screen_specific_widgets\dashboard_overview_widgets\signal_feed.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants.dart';

class SignalFeed extends StatelessWidget {
  const SignalFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedItems = [
      _SignalItem(category: "Top Wallet Move", message: "Whale X moved 2M USDC to DEX Y", sentiment: "Bullish", tags: ["Whale", "Movers", "Insight"]),
      _SignalItem(category: "AI Rebalance", message: "Rotate 12% to LINK based on current trends", sentiment: "Neutral", tags: ["Smart News", "Sentiment"]),
      _SignalItem(category: "Watchlist Mover", message: "BTC surged 5% in the last hour", sentiment: "Bullish", tags: ["Movers", "Trend"]),
      _SignalItem(category: "Trend Insight", message: "XRP is trending in social media sentiment today", sentiment: "Bearish", tags: ["Sentiment", "News"]),
      // repeated for scrolling effect
      _SignalItem(category: "Top Wallet Move", message: "Whale X moved 2M USDC to DEX Y", sentiment: "Bullish", tags: ["Whale", "Movers", "Insight"]),
      _SignalItem(category: "AI Rebalance", message: "Rotate 12% to LINK based on current trends", sentiment: "Neutral", tags: ["Smart News", "Sentiment"]),
      _SignalItem(category: "Watchlist Mover", message: "BTC surged 5% in the last hour", sentiment: "Bullish", tags: ["Movers", "Trend"]),
      _SignalItem(category: "Trend Insight", message: "XRP is trending in social media sentiment today", sentiment: "Bearish", tags: ["Sentiment", "News"]),
    ];

    return Card(
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Signal Feed",
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppConstants.accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: 12),
                  itemCount: feedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 40),
                  itemBuilder: (context, index) {
                    final item = feedItems[index];
                    return GestureDetector(
                      onTap: () => _showDetailModal(context, item),
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppConstants.accentColor.withOpacity(0.25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(_getCategoryIcon(item.category), color: AppConstants.accentColor, size: 22),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.category,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getSentimentColor(item.sentiment).withOpacity(0.15),
                                    border: Border.all(color: _getSentimentColor(item.sentiment)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    item.sentiment,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getSentimentColor(item.sentiment),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.message,
                              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: item.tags.map((tag) {
                                final tagColor = _getTagColor(context, tag);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: tagColor),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: tagColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context, _SignalItem item) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getCategoryIcon(item.category), size: 32, color: AppConstants.accentColor),
              const SizedBox(height: 12),
              Text(
                item.category,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppConstants.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.message,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: item.tags.map((tag) {
                  final tagColor = _getTagColor(context, tag);
                  return Chip(
                    label: Text(tag),
                    backgroundColor: tagColor.withOpacity(0.2),
                    labelStyle: TextStyle(color: tagColor, fontWeight: FontWeight.bold),
                    shape: StadiumBorder(side: BorderSide(color: tagColor)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getSentimentColor(item.sentiment).withOpacity(0.1),
                  border: Border.all(color: _getSentimentColor(item.sentiment)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.sentiment,
                  style: TextStyle(
                    color: _getSentimentColor(item.sentiment),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Top Wallet Move": return Icons.account_balance_wallet;
      case "AI Rebalance": return Icons.auto_awesome;
      case "Watchlist Mover": return Icons.trending_up;
      case "Trend Insight": return Icons.insights;
      default: return Icons.signal_cellular_alt;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case "Bullish": return Colors.greenAccent.shade400;
      case "Bearish": return Colors.redAccent.shade200;
      default: return Colors.amberAccent.shade200;
    }
  }

  Color _getTagColor(BuildContext context, String tag) {
    switch (tag) {
      case "Whale": return Colors.blueAccent;
      case "Movers": return Colors.deepPurpleAccent;
      case "Trend": return Colors.tealAccent.shade400;
      case "Insight": return Colors.cyanAccent.shade400;
      case "Smart News": return Colors.orangeAccent.shade200;
      case "Sentiment": return Colors.pinkAccent.shade100;
      case "News": return Colors.lightBlueAccent.shade100;
      default: return Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
    }
  }
}

class _SignalItem {
  final String category;
  final String message;
  final String sentiment;
  final List<String> tags;

  _SignalItem({
    required this.category,
    required this.message,
    required this.sentiment,
    this.tags = const [],
  });
}
