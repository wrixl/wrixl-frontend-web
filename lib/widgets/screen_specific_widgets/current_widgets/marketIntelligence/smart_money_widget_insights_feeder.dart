// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\smart_money_widget_insights_feeder.dart

// Fully updated SmartMoneyWidgetInsightsFeeder widget with styling aligned to StressRadarWidget

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
    // ... more items
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
                Text("Smart Money Insights",
                    style: theme.textTheme.titleMedium),
                SizedBox(
                  width: 200,
                  height: 36,
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search insights",
                      prefixIcon: Icon(Icons.search,
                          size: 18, color: scheme.onSurface),
                      filled: true,
                      fillColor: scheme.surfaceVariant,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
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
            const SizedBox(height: 12),
            ToggleFilterIconRowWidget(
              options: walletTypes,
              optionIcons: walletIcons,
              activeOption: activeWalletType,
              onSelected: (option) => setState(() => activeWalletType = option),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFeed.length,
              itemBuilder: (context, index) {
                final item = filteredFeed[index];
                final tags = List<String>.from(item['tags'] ?? []);
                final tokens = List<String>.from(item['tokens'] ?? []);
                final wallets = List<String>.from(item['wallets'] ?? []);

                return GestureDetector(
                  onTap: () => _showInsightModal(context, item),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        left: BorderSide(color: scheme.primary, width: 2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(item['insight'] ?? '',
                                  style: theme.textTheme.titleSmall),
                            ),
                            IconButton(
                              icon: const Icon(Icons.star_border, size: 20),
                              color: scheme.secondary,
                              onPressed: () {},
                              tooltip: 'Bookmark',
                            )
                          ],
                        ),
                        if (tags.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            children: tags
                                .map((tag) => Chip(
                                      label: Text(tag,
                                          style: theme.textTheme.bodySmall),
                                      backgroundColor:
                                          scheme.primary.withOpacity(0.15),
                                    ))
                                .toList(),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...tokens.map((t) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: CryptoIconUtils.getIcon(t, size: 16),
                                )),
                            const Spacer(),
                            Text('${wallets.length} wallets',
                                style: theme.textTheme.labelSmall),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['detail'] ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withOpacity(0.75)),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            item['timestamp'] ?? '',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: scheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _showInsightModal(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final wallets = List<String>.from(item['wallets'] ?? []);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text(item['insight'] ?? '',
            style: theme.textTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detail:", style: theme.textTheme.bodyMedium),
            Text(item['detail'] ?? ''),
            const SizedBox(height: 10),
            Text("Wallets:", style: theme.textTheme.bodyMedium),
            ...wallets.map((w) => Text("• $w",
                style:
                    theme.textTheme.bodySmall?.copyWith(fontSize: 12)))
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }
}
