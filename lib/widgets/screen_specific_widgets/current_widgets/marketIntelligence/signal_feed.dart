// lib\widgets\screen_specific_widgets\dashboard_overview_widgets\signal_feed.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart';

class SignalFeed extends StatelessWidget {
  const SignalFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final feedItems = [
      _SignalItem(category: "Top Wallet Move", message: "Whale X moved 2M USDC to DEX Y", sentiment: "Bullish", tags: ["Whale", "Movers", "Insight"]),
      _SignalItem(category: "AI Rebalance", message: "Rotate 12% to LINK based on current trends", sentiment: "Neutral", tags: ["Smart News", "Sentiment"]),
      _SignalItem(category: "Watchlist Mover", message: "BTC surged 5% in the last hour", sentiment: "Bullish", tags: ["Movers", "Trend"]),
      _SignalItem(category: "Trend Insight", message: "XRP is trending in social media sentiment today", sentiment: "Bearish", tags: ["Sentiment", "News"]),
      _SignalItem(category: "AI Rebalance", message: "Rotate 12% to LINK based on current trends", sentiment: "Neutral", tags: ["Smart News", "Sentiment"]),
      _SignalItem(category: "Watchlist Mover", message: "BTC surged 5% in the last hour", sentiment: "Bullish", tags: ["Movers", "Trend"]),
      _SignalItem(category: "Trend Insight", message: "XRP is trending in social media sentiment today", sentiment: "Bearish", tags: ["Sentiment", "News"]),
    ];

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
                Text("Signal Feed", style: theme.textTheme.titleMedium),
                const Icon(Icons.flash_on, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 16),

            // Scrollable feed
            SizedBox(
              height: 200,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: feedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 24),
                  itemBuilder: (context, index) {
                    final item = feedItems[index];
                    return GestureDetector(
                      onTap: () => _showDetailModal(context, item),
                      child: Container(
                        width: 240,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: scheme.outline.withOpacity(0.15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row with category and sentiment badge
                            Row(
                              children: [
                                Icon(_getCategoryIcon(item.category), size: 20, color: scheme.primary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.category,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onSurface.withOpacity(0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _buildSentimentBadge(item.sentiment),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Message
                            Text(
                              item.message,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            // Tags
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: item.tags.map((tag) {
                                final tagColor = _getTagColor(context, tag);
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: tagColor.withOpacity(0.1),
                                    border: Border.all(color: tagColor),
                                    borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 8),
            Text(
              "📡 Signals are curated from AI models, wallet tracking, and social sentiment.",
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentBadge(String sentiment) {
    final color = _getSentimentColor(sentiment);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        sentiment,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  void _showDetailModal(BuildContext context, _SignalItem item) {
    final theme = Theme.of(context);
    final tagColor = _getSentimentColor(item.sentiment);

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
              Icon(_getCategoryIcon(item.category), size: 32, color: tagColor),
              const SizedBox(height: 12),
              Text(item.category, style: theme.textTheme.titleLarge?.copyWith(color: tagColor, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(item.message, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17), textAlign: TextAlign.center),
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
                  color: tagColor.withOpacity(0.1),
                  border: Border.all(color: tagColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.sentiment,
                  style: TextStyle(color: tagColor, fontWeight: FontWeight.bold, fontSize: 14),
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
      case "Top Wallet Move":
        return Icons.account_balance_wallet;
      case "AI Rebalance":
        return Icons.auto_awesome;
      case "Watchlist Mover":
        return Icons.trending_up;
      case "Trend Insight":
        return Icons.insights;
      default:
        return Icons.signal_cellular_alt;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case "Bullish":
        return Colors.greenAccent.shade400;
      case "Bearish":
        return Colors.redAccent.shade200;
      default:
        return Colors.amberAccent.shade200;
    }
  }

  Color _getTagColor(BuildContext context, String tag) {
    switch (tag) {
      case "Whale":
        return Colors.blueAccent;
      case "Movers":
        return Colors.deepPurpleAccent;
      case "Trend":
        return Colors.tealAccent.shade400;
      case "Insight":
        return Colors.cyanAccent.shade400;
      case "Smart News":
        return Colors.orangeAccent.shade200;
      case "Sentiment":
        return Colors.pinkAccent.shade100;
      case "News":
        return Colors.lightBlueAccent.shade100;
      default:
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
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
