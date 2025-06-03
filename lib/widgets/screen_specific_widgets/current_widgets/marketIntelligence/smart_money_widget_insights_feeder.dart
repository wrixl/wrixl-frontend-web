import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/crypto_icons_flutter.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class SmartMoneyWidgetInsightsFeeder extends StatefulWidget {
  const SmartMoneyWidgetInsightsFeeder({Key? key}) : super(key: key);

  @override
  State<SmartMoneyWidgetInsightsFeeder> createState() =>
      _SmartMoneyWidgetInsightsFeederState();
}

class _SmartMoneyWidgetInsightsFeederState
    extends State<SmartMoneyWidgetInsightsFeeder> {
  String activeWalletType = 'all';
  String searchQuery = '';

  final List<String> walletTypes = [
    'all',
    'whale',
    'fund',
    'degen',
    'fresh wallet',
    'smart lp',
  ];

  final Map<String, IconData> walletIcons = {
    'all': Icons.all_inclusive,
    'whale': Icons.waves,
    'fund': Icons.pie_chart,
    'degen': Icons.flash_on,
    'fresh wallet': Icons.new_releases,
    'smart lp': Icons.science,
  };

  static final List<Map<String, dynamic>> _dummyFeedItems = [
    {
      'insight': 'Hedge funds entering DeFi yield plays',
      'detail':
          'Pendle, Lyra, and Aura saw 17.2M USD inflows from fund-tagged wallets.',
      'walletType': 'fund',
      'confidence': 4,
      'wallets': ['0xF1...', '0xD3...', '0xE4...'],
      'tokens': ['GBYTE', 'SUSHI', 'WBTC'],
      'tags': ['Yield Farming', 'Rotation', 'DeFi'],
      'timestamp': '12:02 • 04/09',
    },
    {
      'insight': 'Whale cluster shedding MEME exposure',
      'detail': 'Over 2.1M USD in MEME tokens dumped.',
      'walletType': 'whale',
      'confidence': 3,
      'wallets': ['0xA2...', '0xC1...'],
      'tokens': ['GBYTE'],
      'tags': ['Exit Pattern', 'Risk Off'],
      'timestamp': '11:47 • 04/09',
    },
    {
      'insight': 'Fresh wallet hits 100K USD profit in 48 hours',
      'detail':
          'New high-frequency trader surfaced on Base. 38 trades, 82% win rate.',
      'walletType': 'fresh wallet',
      'confidence': 3,
      'wallets': ['0xNew...'],
      'tokens': ['USDC', 'ETH', 'SUSHI'],
      'tags': ['High Activity', 'Base Chain'],
      'timestamp': '10:55 • 04/09',
    },
    {
      'insight': 'Degens rotate from NFTs into yield tokens',
      'detail':
          'NFT-heavy wallets exited JPEGs and moved into L2 LPs like GBYTE.',
      'walletType': 'degen',
      'confidence': 2,
      'wallets': ['0xDE...', '0xGN...'],
      'tokens': ['GBYTE', 'FTC'],
      'tags': ['Rotation', 'Yield'],
      'timestamp': '10:24 • 04/09',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final filteredFeed = _dummyFeedItems.where((item) {
      final type = (item['walletType']?.toLowerCase() ?? '');
      final matchType = activeWalletType == 'all' || type == activeWalletType;
      final matchQuery = searchQuery.isEmpty ||
          (item['insight']?.toLowerCase() ?? '')
              .contains(searchQuery.toLowerCase());
      return matchType && matchQuery;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Search
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
            SizedBox(
              width: 220,
              height: 36,
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: "Search insights",
                  prefixIcon:
                      Icon(Icons.search, size: 18, color: scheme.onSurface),
                  filled: true,
                  fillColor: scheme.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: scheme.primary.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: scheme.primary.withOpacity(0.3)),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Wallet‑type filters
        Align(
          alignment: Alignment.centerLeft,
          child: ToggleFilterIconRowWidget(
            options: walletTypes,
            optionIcons: walletIcons,
            activeOption: activeWalletType,
            onSelected: (option) => setState(() => activeWalletType = option),
          ),
        ),
        const SizedBox(height: 12),

        // Feed list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: filteredFeed.length,
          itemBuilder: (context, index) {
            final item = filteredFeed[index];
            final tags = List<String>.from(item['tags'] ?? []);
            final tokens = List<String>.from(item['tokens'] ?? []);
            final wallets = List<String>.from(item['wallets'] ?? []);

            return GestureDetector(
              onTap: () => _showInsightModal(context, item),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border(
                    left: BorderSide(color: scheme.primary, width: 2.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary.withOpacity(0.6),
                            scheme.primary.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['insight'] ?? '',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.star_border, size: 20),
                          color: scheme.secondary,
                          tooltip: 'Add to Watchlist',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Saved insight: '${item['insight']}'",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onPrimary,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: scheme.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    if (tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        children: tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        ...tokens.map((t) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: CryptoIconUtils.getIcon(t, size: 16),
                            )),
                        const Spacer(),
                        Text(
                          '${wallets.length} wallet(s)',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.bolt, size: 14, color: scheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Confidence: ${item['confidence'] ?? '—'} / 5',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurface.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item['timestamp'] ?? '',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, size: 18),
                          tooltip: 'Share Insight',
                          color: scheme.onSurface,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    "Share functionality coming soon"),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: scheme.surface,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showInsightModal(BuildContext context, Map<String, dynamic> item) {
    final wallets = List<String>.from(item['wallets'] ?? []);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text(
          item['insight'] ?? '',
          style: theme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rationale:",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(item['detail'] ?? "No details available."),
            const SizedBox(height: 10),
            Text("Involved Wallets:",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...wallets
                .map((w) => Text("• $w", style: theme.textTheme.bodyMedium)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
