// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\wallet_leaderboard.dart

import 'package:flutter/material.dart';

class WalletLeaderboardWidget extends StatefulWidget {
  const WalletLeaderboardWidget({super.key});

  @override
  State<WalletLeaderboardWidget> createState() => _WalletLeaderboardWidgetState();
}

class _WalletLeaderboardWidgetState extends State<WalletLeaderboardWidget> {
  String _selectedTimeframe = '7D';
  String _selectedChain = 'All';

  final List<Map<String, dynamic>> _wallets = [
    {
      "rank": 1,
      "alias": "@WhaleAlpha001",
      "type": "VC",
      "score": 92,
      "roi": 18.4,
      "delta": 1,
      "holdings": ["PENDLE", "JUP", "WIF"],
    },
    {
      "rank": 2,
      "alias": "@DeFiDegod",
      "type": "Fund",
      "score": 88,
      "roi": 16.2,
      "delta": -1,
      "holdings": ["TAO", "ETH", "FET"],
    },
  ];

  Widget _buildWalletRow(Map<String, dynamic> wallet, ThemeData theme) {
    final deltaColor = wallet["delta"] > 0
        ? Colors.green
        : wallet["delta"] < 0
            ? Colors.red
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Text("🥇 ${wallet["rank"]}",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        title: Text(wallet["alias"],
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${wallet["type"]} • ROI: +${wallet["roi"]}% ${_selectedTimeframe}",
                style: theme.textTheme.bodySmall),
            Text("Top: ${wallet["holdings"].join(', ')}", style: theme.textTheme.bodySmall),
          ],
        ),
        trailing: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  wallet["delta"] > 0
                      ? Icons.arrow_upward
                      : wallet["delta"] < 0
                          ? Icons.arrow_downward
                          : Icons.horizontal_rule,
                  color: deltaColor,
                  size: 20,
                ),
                Text("Δ ${wallet["delta"]}", style: TextStyle(color: deltaColor, fontSize: 12)),
              ],
            ),
            IconButton(icon: const Icon(Icons.show_chart), onPressed: () {}),
            IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text("🏆 Wallet Leaderboard",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                const Tooltip(
                  message: "Ranked smart money wallets by ROI, conviction, and inflows.",
                  child: Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedTimeframe,
                  style: theme.textTheme.bodyMedium,
                  items: ['24H', '7D', '30D']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedTimeframe = val!),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedChain,
                  style: theme.textTheme.bodyMedium,
                  items: ['All', 'ETH', 'SOL', 'BASE', 'BNB']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedChain = val!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._wallets.map((wallet) => _buildWalletRow(wallet, theme)).toList(),
          ],
        ),
      ),
    );
  }
}
