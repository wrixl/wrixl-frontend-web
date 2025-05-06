// lib\widgets\screen_specific_widgets\market_signals_widgets\market_signals_smart _news_strip_widget.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

/// Data model for a news item.
class NewsItem {
  final String headline;
  final String sentiment;
  final String source;
  final String category;

  NewsItem({
    required this.headline,
    required this.sentiment,
    required this.source,
    required this.category,
  });
}

/// Smart News Strip with filter toggles and a horizontal scroll.
class MarketSignalsSmartNewsStripWidget extends StatefulWidget {
  final List<NewsItem> newsItems;

  const MarketSignalsSmartNewsStripWidget({
    Key? key,
    required this.newsItems,
  }) : super(key: key);

  @override
  _MarketSignalsSmartNewsStripWidgetState createState() =>
      _MarketSignalsSmartNewsStripWidgetState();
}

class _MarketSignalsSmartNewsStripWidgetState
    extends State<MarketSignalsSmartNewsStripWidget> {
  String _selectedFilter = "All";

  final List<String> filters = [
    "All",
    "Only Bullish",
    "Only Bearish",
    "Dev-focused",
    "Regulatory",
    "ETF",
  ];

  final Map<String, IconData> filterIcons = {
    "All": Icons.all_inclusive,
    "Only Bullish": Icons.thumb_up,
    "Only Bearish": Icons.thumb_down,
    "Dev-focused": Icons.code,
    "Regulatory": Icons.gavel,
    "ETF": Icons.attach_money,
  };

  List<NewsItem> get filteredNews {
    if (_selectedFilter == "All") return widget.newsItems;
    return widget.newsItems.where((item) {
      final cat = item.category.toLowerCase();
      final sent = item.sentiment.toLowerCase();
      if (_selectedFilter == "Only Bullish") {
        return cat == "only bullish" || sent == "positive";
      } else if (_selectedFilter == "Only Bearish") {
        return cat == "only bearish" || sent == "negative";
      } else {
        return cat == _selectedFilter.toLowerCase();
      }
    }).toList();
  }

  Map<String, dynamic> getSentimentBadge(ColorScheme scheme, String s) {
    final lower = s.toLowerCase();
    if (lower == "positive") {
      return {"text": "Bullish", "color": scheme.secondary};
    } else if (lower == "negative") {
      return {"text": "Bearish", "color": scheme.error};
    } else {
      return {"text": "Neutral", "color": scheme.primary};
    }
  }

  IconData getNewsIcon(String category) {
    switch (category.toLowerCase()) {
      case "regulatory":
        return Icons.gavel;
      case "dev-focused":
        return Icons.code;
      case "etf":
        return Icons.trending_up;
      default:
        return Icons.campaign;
    }
  }

  void _showOptionsModal() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Smart Feed Options",
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: 12),
            Text("Additional options can be placed here.",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const double cardHeight = 160, cardWidth = 320;

    return Card(
      color: scheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Smart Feed",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: scheme.onSurface),
                  onPressed: _showOptionsModal,
                  tooltip: "Options",
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Filters + summary
            Row(
              children: [
                Expanded(
                  child: ToggleFilterIconRowWidget(
                    options: filters,
                    optionIcons: filterIcons,
                    activeOption: _selectedFilter,
                    onSelected: (opt) =>
                        setState(() => _selectedFilter = opt),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    "Latest market signals aggregated and analyzed for trends.",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: scheme.onSurface),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // News cards strip
            SizedBox(
              height: cardHeight,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context)
                    .copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                }),
                child: GestureDetector(
                  onHorizontalDragUpdate: (_) {},
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 12),
                    itemCount: filteredNews.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 40),
                    itemBuilder: (_, i) {
                      final item = filteredNews[i];
                      final badge = getSentimentBadge(scheme, item.sentiment);
                      return InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: scheme.surface,
                              title: Text("News Details",
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(color: scheme.onSurface)),
                              content: Text(
                                "Full summary for: ${item.headline}\n\nLink to article...",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: scheme.onSurface),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Close",
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(color: scheme.primary)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: cardWidth,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: scheme.primary.withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Source + icon
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        scheme.primary.withOpacity(0.2),
                                    child: Text(
                                      item.source
                                          .substring(0, 2)
                                          .toUpperCase(),
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: scheme.onPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.source,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: scheme.onSurface),
                                    ),
                                  ),
                                  Icon(
                                    getNewsIcon(item.category),
                                    color: scheme.primary,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Headline
                              Expanded(
                                child: Text(
                                  item.headline,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyLarge
                                      ?.copyWith(color: scheme.onSurface),
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Sentiment badge
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (badge['color'] as Color)
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    badge['text'] as String,
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: scheme.onPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

