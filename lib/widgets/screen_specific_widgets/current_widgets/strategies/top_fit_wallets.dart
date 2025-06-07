// lib\widgets\screen_specific_widgets\current_widgets\strategies\top_fit_wallets.dart

import 'package:flutter/material.dart';

class TopFitWalletsWidget extends StatelessWidget {
  const TopFitWalletsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wallets = _mockFitWallets;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Top Wallets for You", style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.tune),
                  tooltip: "Edit Fit Preferences",
                  onPressed: () {
                    // TODO: Open fit preference modal
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  final wallet = wallets[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _FitWalletCard(wallet: wallet),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FitWalletCard extends StatelessWidget {
  final _FitWallet wallet;

  const _FitWalletCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(wallet.avatarPath),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(wallet.name,
                          style: Theme.of(context).textTheme.labelLarge),
                      Text("Wrixl Score: ${wallet.wrixlScore}",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text("ROI: ${wallet.roi}%",
                style: TextStyle(
                    color: wallet.roi > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 4,
              children: wallet.themes
                  .map((theme) => Chip(
                        label: Text(theme,
                            style: Theme.of(context).textTheme.labelSmall),
                        backgroundColor: Colors.blue.shade50,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 6),
            Tooltip(
              message: wallet.matchReason,
              child: Chip(
                label: Text(wallet.fitLevel,
                    style: Theme.of(context).textTheme.labelSmall),
                backgroundColor: _fitColor(wallet.fitLevel),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.link, size: 16),
                    label: const Text("Mirror"),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: "Bookmark Wallet",
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _fitColor(String fitLevel) {
    switch (fitLevel) {
      case "High Fit":
        return Colors.green.shade100;
      case "Medium Fit":
        return Colors.yellow.shade100;
      case "Low Fit":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}

class _FitWallet {
  final String name;
  final String avatarPath;
  final double roi;
  final int wrixlScore;
  final List<String> themes;
  final String fitLevel;
  final String matchReason;

  const _FitWallet({
    required this.name,
    required this.avatarPath,
    required this.roi,
    required this.wrixlScore,
    required this.themes,
    required this.fitLevel,
    required this.matchReason,
  });
}

const List<_FitWallet> _mockFitWallets = [
  _FitWallet(
    name: "AlphaHunter.eth",
    avatarPath: "assets/avatars/wallet1.png",
    roi: 42.7,
    wrixlScore: 92,
    themes: ["DeFi", "Stable Rotation"],
    fitLevel: "High Fit",
    matchReason: "Matches your stablecoin allocation + low-vol trend",
  ),
  _FitWallet(
    name: "DegenWhale",
    avatarPath: "assets/avatars/wallet2.png",
    roi: 71.3,
    wrixlScore: 88,
    themes: ["NFTs", "High Beta"],
    fitLevel: "Medium Fit",
    matchReason: "Your volatility preference aligns with this wallet",
  ),
  _FitWallet(
    name: "LongHoldCapital",
    avatarPath: "assets/avatars/wallet3.png",
    roi: 23.9,
    wrixlScore: 95,
    themes: ["Layer 1s", "Yield Farming"],
    fitLevel: "High Fit",
    matchReason: "Strong overlap with your long-term L1 exposure",
  ),
];
