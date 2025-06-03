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
    Color deltaColor = wallet["delta"] > 0
        ? Colors.green
        : wallet["delta"] < 0
            ? Colors.red
            : Colors.grey;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text("🥇 ${wallet["rank"]}", style: theme.textTheme.titleLarge),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wallet["alias"], style: theme.textTheme.titleMedium),
                  Text("${wallet["type"]} • ROI: +${wallet["roi"]}% ${_selectedTimeframe}"),
                  Text("Top: ${wallet["holdings"].join(', ')}"),
                ],
              ),
            ),
            Column(
              children: [
                Icon(
                  wallet["delta"] > 0
                      ? Icons.arrow_upward
                      : wallet["delta"] < 0
                          ? Icons.arrow_downward
                          : Icons.horizontal_rule,
                  color: deltaColor,
                ),
                Text("Δ ${wallet["delta"]}", style: TextStyle(color: deltaColor)),
              ],
            ),
            const SizedBox(width: 8),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("🏆 Wallet Leaderboard", style: theme.textTheme.titleLarge),
            const SizedBox(width: 8),
            const Tooltip(
              message: "Ranked smart money wallets by ROI, conviction, and inflows.",
              child: Icon(Icons.info_outline, size: 18),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: _selectedTimeframe,
              items: ['24H', '7D', '30D'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedTimeframe = val!),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _selectedChain,
              items: ['All', 'ETH', 'SOL', 'BASE', 'BNB']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedChain = val!),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._wallets.map((wallet) => _buildWalletRow(wallet, theme)).toList(),
      ],
    );
  }
}
