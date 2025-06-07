// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\wallet_strategy_card.dart

import 'package:flutter/material.dart';

class WalletStrategyCard extends StatefulWidget {
  final String walletAlias;
  final String walletType;
  final double rankDelta;

  const WalletStrategyCard({
    Key? key,
    required this.walletAlias,
    required this.walletType,
    required this.rankDelta,
  }) : super(key: key);

  @override
  State<WalletStrategyCard> createState() => _WalletStrategyCardState();
}

class _WalletStrategyCardState extends State<WalletStrategyCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _holdings = [
    {
      'token': 'PYTH',
      'icon': Icons.api,
      'percent': 38.0,
      'action': 'Accumulating',
      'priceDelta': 12.4,
      'sector': 'Oracle'
    },
    {
      'token': 'JUP',
      'icon': Icons.explore,
      'percent': 17.5,
      'action': 'Trimming',
      'priceDelta': -3.2,
      'sector': 'DEX'
    },
    {
      'token': 'WIF',
      'icon': Icons.pets,
      'percent': 0.0,
      'action': 'Exited',
      'priceDelta': 0.0,
      'sector': 'Meme'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'Accumulating':
        return Colors.green;
      case 'Trimming':
        return Colors.red;
      case 'Holding':
        return Colors.orange;
      case 'Exited':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar
            Row(
              children: [
                Text("@${widget.walletAlias}", style: theme.textTheme.titleMedium),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Wallet tagged as ${widget.walletType}.',
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                Chip(
                  label: Text(widget.walletType, style: theme.textTheme.labelLarge),
                  avatar: const Icon(Icons.star, size: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: scheme.primary.withOpacity(0.1),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
              labelStyle: theme.textTheme.labelLarge,
              indicatorColor: scheme.primary,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Holdings'),
                Tab(text: 'Trades'),
                Tab(text: 'Conviction'),
                Tab(text: 'Activity'),
              ],
            ),
            const SizedBox(height: 12),

            // Tab views
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHoldingsTab(theme),
                  Center(child: Text('Trades tab coming soon...', style: theme.textTheme.bodySmall)),
                  Center(child: Text('Conviction heatmap coming soon...', style: theme.textTheme.bodySmall)),
                  Center(child: Text('Activity chart coming soon...', style: theme.textTheme.bodySmall)),
                ],
              ),
            ),

            const Divider(height: 32),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.square),
                  label: const Text("Mirror"),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text("Watch Wallet"),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.sync_alt),
                  label: const Text("Simulate Drift"),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHoldingsTab(ThemeData theme) {
    return ListView.separated(
      itemCount: _holdings.length,
      separatorBuilder: (_, __) => const Divider(height: 12),
      itemBuilder: (context, index) {
        final h = _holdings[index];
        final actionColor = _getActionColor(h['action']);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(h['icon'], color: actionColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${h['token']} (${h['sector']})', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text('${h['percent']}% — ${h['action']}', style: TextStyle(color: actionColor)),
                ],
              ),
            ),
            Text(
              "${h['priceDelta']}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: h['priceDelta'] >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
