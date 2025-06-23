// lib/widgets/screen_specific_widgets/current_widgets/strategies/top_fit_wallets.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class TopFitWalletsWidget extends StatelessWidget {
  const TopFitWalletsWidget({Key? key}) : super(key: key);

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
            // Header
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
            // Horizontal list of wallets
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wallets.length,
                itemBuilder: (context, index) {
                  final wallet = wallets[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // open modal with details for this wallet
                          showNewReusableModal(
                            context,
                            title: wallet.name,
                            size: WidgetModalSize.medium,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(wallet.avatarPath),
                                    radius: 30,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(wallet.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("Wrixl Score: ${wallet.wrixlScore}"),
                                Text("ROI: ${wallet.roi.toStringAsFixed(1)}%"),
                                const SizedBox(height: 8),
                                Text("Fit Level: ${wallet.fitLevel}"),
                                const SizedBox(height: 8),
                                Text("Why this fit:", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(wallet.matchReason),
                                const SizedBox(height: 12),
                                Text("Themes:", style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: wallet.themes.map((t) => Chip(label: Text(t))).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                        child: _FitWalletCard(wallet: wallet),
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
}

class _FitWalletCard extends StatelessWidget {
  final _FitWallet wallet;

  const _FitWalletCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surfaceVariant,
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar, name & score
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
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text("Wrixl Score: ${wallet.wrixlScore}",
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ROI
            Text("ROI: ${wallet.roi.toStringAsFixed(1)}%",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                        color: wallet.roi > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            // Themes
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: wallet.themes.map((themeText) {
                return Chip(
                  label: Text(themeText,
                      style: Theme.of(context).textTheme.labelSmall),
                  backgroundColor: scheme.primary.withOpacity(0.1),
                  side: BorderSide(color: scheme.primary.withOpacity(0.2)),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Fit Level badge
            Tooltip(
              message: wallet.matchReason,
              child: Chip(
                label: Text(wallet.fitLevel,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontWeight: FontWeight.w600, color: _fitTextColor(wallet.fitLevel))),
                backgroundColor: _fitColor(wallet.fitLevel),
              ),
            ),
            const Spacer(),
            // Mirror + Bookmark
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.link, size: 16),
                    label: const Text("Mirror"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: "Bookmark Wallet",
                  onPressed: () {},
                ),
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
        return Colors.green.shade200;
      case "Medium Fit":
        return Colors.amber.shade200;
      case "Low Fit":
        return Colors.red.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _fitTextColor(String fitLevel) {
    switch (fitLevel) {
      case "High Fit":
        return Colors.green.shade900;
      case "Medium Fit":
        return Colors.amber.shade900;
      case "Low Fit":
        return Colors.red.shade900;
      default:
        return Colors.grey.shade800;
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
