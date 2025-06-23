// lib/widgets/screen_specific_widgets/mirror_insights_widgets/wallet_tile.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

// helper for formatting dates
String _fmt(DateTime d) => "${d.month}/${d.day}/${d.year}";

class WalletData {
  final String address;
  final String strategyTag;
  final String emoji;
  final String roi7d;
  final String roi30d;
  final String sharpe;
  final String winRate;
  final String followers;
  final double confidence;
  final String size;
  final int avgHoldMonths;
  final int uniqueTokens;
  final double reputation;
  final int recommendation;
  final int? wrixlRank;
  final List<double> roiTrend;
  final List<String> topHoldings;
  final String dominantChain;
  final String assetTypeMix;
  final List<String> behaviorTags;
  final int activeMirrors;
  final String avgMirrorRoi;
  final DateTime initialRecommendationDate;
  final DateTime? lastVerifiedDate;
  final Map<String, dynamic> metadata;

  WalletData({
    required this.address,
    required this.strategyTag,
    required this.emoji,
    required this.roi7d,
    required this.roi30d,
    required this.sharpe,
    required this.winRate,
    required this.followers,
    required this.confidence,
    required this.size,
    required this.avgHoldMonths,
    required this.uniqueTokens,
    required this.reputation,
    required this.recommendation,
    required this.roiTrend,
    required this.topHoldings,
    required this.dominantChain,
    required this.assetTypeMix,
    required this.behaviorTags,
    required this.activeMirrors,
    required this.avgMirrorRoi,
    required this.initialRecommendationDate,
    this.lastVerifiedDate,
    this.wrixlRank,
    this.metadata = const {},
  });
}

class WalletTileListWidget extends StatelessWidget {
  const WalletTileListWidget({Key? key}) : super(key: key);

  List<WalletData> _dummyWallets() => [
        WalletData(
          address: "0xAa12...3F6B",
          strategyTag: "DeFi Degen",
          emoji: "🚀",
          roi7d: "+12%",
          roi30d: "+28%",
          sharpe: "1.2",
          winRate: "73%",
          followers: "150K",
          confidence: 0.8,
          size: "tuna",
          avgHoldMonths: 4,
          uniqueTokens: 28,
          reputation: 4.3,
          recommendation: 91,
          wrixlRank: 3,
          roiTrend: [0.0, 0.2, 0.5, 0.9, 1.2, 1.0, 1.3],
          topHoldings: ["ETH", "ARB", "USDC"],
          dominantChain: "Ethereum",
          assetTypeMix: "60% DeFi, 30% Stable, 10% NFT",
          behaviorTags: ["Yield Farmer", "Gas Saver"],
          activeMirrors: 1240,
          avgMirrorRoi: "+16.7%",
          initialRecommendationDate: DateTime(2024, 11, 10),
          lastVerifiedDate: DateTime(2025, 4, 10),
        ),
        WalletData(
          address: "0xBf98...E4C1",
          strategyTag: "ETH Maxi",
          emoji: "🦄",
          roi7d: "+7%",
          roi30d: "+15%",
          sharpe: "1.0",
          winRate: "65%",
          followers: "230K",
          confidence: 0.9,
          size: "whale",
          avgHoldMonths: 9,
          uniqueTokens: 14,
          reputation: 4.8,
          recommendation: 96,
          wrixlRank: 1,
          roiTrend: [0.1, 0.2, 0.3, 0.5, 0.6, 0.6, 0.7],
          topHoldings: ["ETH", "stETH", "wBTC"],
          dominantChain: "Ethereum",
          assetTypeMix: "80% ETH, 10% DeFi, 10% Bluechip",
          behaviorTags: ["Long-Term Holder", "DCA Strategist"],
          activeMirrors: 2120,
          avgMirrorRoi: "+14.2%",
          initialRecommendationDate: DateTime(2024, 10, 1),
          lastVerifiedDate: DateTime(2025, 4, 12),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final wallets = _dummyWallets();

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Popular Wallets",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const Icon(Icons.account_balance_wallet_rounded, size: 20),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon:
                                Icon(Icons.bar_chart, size: 18, color: scheme.primary),
                            label: Text("Simulate in Portfolio Simulator",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: scheme.primary, fontSize: 13)),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 180,
                            height: 36,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search wallets",
                                prefixIcon: Icon(Icons.search,
                                    size: 18, color: scheme.onSurface),
                                filled: true,
                                fillColor: scheme.surface.withOpacity(0.1),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                hintStyle: theme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: scheme.onSurface.withOpacity(0.7),
                                        fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: scheme.primary.withOpacity(0.3)),
                                ),
                              ),
                              onChanged: (query) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 460,
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
                            itemCount: wallets.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 24),
                            itemBuilder: (context, index) {
                              final w = wallets[index];
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    showNewReusableModal(
                                      context,
                                      title: w.address,
                                      size: WidgetModalSize.large,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(w.emoji,
                                                style: const TextStyle(
                                                    fontSize: 48)),
                                          ),
                                          const SizedBox(height: 12),
                                          Text("Address: ${w.address}"),
                                          Text("Strategy: ${w.strategyTag}"),
                                          const SizedBox(height: 8),
                                          Text("7d ROI: ${w.roi7d}"),
                                          Text("30d ROI: ${w.roi30d}"),
                                          Text("Sharpe: ${w.sharpe}"),
                                          Text("Win Rate: ${w.winRate}"),
                                          Text("Followers: ${w.followers}"),
                                          const SizedBox(height: 8),
                                          Text(
                                              "Confidence: ${(w.confidence * 100).toStringAsFixed(0)}%"),
                                          Text("Size: ${w.size}"),
                                          Text("Avg Hold: ${w.avgHoldMonths} mo"),
                                          Text("Unique Tokens: ${w.uniqueTokens}"),
                                          Text(
                                              "Reputation: ${w.reputation.toStringAsFixed(1)}"),
                                          Text("Rec Score: ${w.recommendation}%"),
                                          const SizedBox(height: 8),
                                          Text("Top Holdings: ${w.topHoldings.join(", ")}"),
                                          Text("Chain: ${w.dominantChain}"),
                                          Text("Asset Mix: ${w.assetTypeMix}"),
                                          const SizedBox(height: 8),
                                          Text("Behavior: ${w.behaviorTags.join(", ")}"),
                                          Text("Active Mirrors: ${w.activeMirrors}"),
                                          Text("Avg Mirror ROI: ${w.avgMirrorRoi}"),
                                          const SizedBox(height: 8),
                                          Text(
                                              "Recommended: ${_fmt(w.initialRecommendationDate)}"),
                                          if (w.lastVerifiedDate != null)
                                            Text(
                                                "Verified: ${_fmt(w.lastVerifiedDate!)}"),
                                          const SizedBox(height: 16),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text("Close"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: _WalletTile(data: w),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WalletTile extends StatelessWidget {
  final WalletData data;

  const _WalletTile({Key? key, required this.data}) : super(key: key);

  String _shortAddress(String a) =>
      "${a.substring(0, 6)}...${a.substring(a.length - 4)}";

  IconData _sizeIcon(String size) {
    switch (size.toLowerCase()) {
      case "whale":
        return Icons.podcasts;
      case "tuna":
        return Icons.eco;
      default:
        return Icons.bubble_chart;
    }
  }

  Widget _stars(BuildContext ctx, double rating) {
    final scheme = Theme.of(ctx).colorScheme;
    int filled = rating.floor();
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < filled ? Icons.star : Icons.star_border,
          color: scheme.primary,
          size: 14,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: 360,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.primary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address + Strategy
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_rounded,
                        size: 18,
                        color: scheme.onSurface.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      _shortAddress(data.address),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.strategyTag,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // ROI + Sparkline
            Row(
              children: [
                Text(
                  data.roi7d,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  height: 26,
                  child: Sparkline(
                    data: data.roiTrend,
                    useCubicSmoothing: true,
                    cubicSmoothingFactor: 0.2,
                    lineColor: scheme.primary,
                    lineWidth: 2.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "Realized ROI (7d)",
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            // Core stats
            Wrap(
              spacing: 14,
              runSpacing: 10,
              children: [
                _statBlock("Sharpe", data.sharpe, context),
                _statBlock("Win Rate", data.winRate, context),
                _statBlock("Followers", data.followers, context),
                _statBlock("Avg Hold", "${data.avgHoldMonths} mo", context),
                _statBlock("Tokens", "${data.uniqueTokens}", context),
                _statBlock("Rec Score", "${data.recommendation}%", context),
                _statBlock("Active Mirrors", "${data.activeMirrors}", context),
                _statBlock("Avg ROI (Mirror)", data.avgMirrorRoi, context),
              ],
            ),
            const SizedBox(height: 10),
            // Reputation
            Row(
              children: [
                Text("Reputation: ", style: theme.textTheme.labelSmall),
                _stars(context, data.reputation),
              ],
            ),
            const SizedBox(height: 8),
            // Holdings, Chain, Mix
            Text(
              "Top Holdings: ${data.topHoldings.join(', ')}",
              style: theme.textTheme.labelSmall,
            ),
            Text(
              "Dominant Chain: ${data.dominantChain}",
              style: theme.textTheme.labelSmall,
            ),
            Text(
              "Asset Mix: ${data.assetTypeMix}",
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 6),
            // Behavior Tags
            Wrap(
              spacing: 6,
              children: data.behaviorTags.map((tag) {
                return Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 11)),
                  backgroundColor: scheme.primary.withOpacity(0.12),
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const SizedBox(height: 6),
            // Recommendation & Verification
            Text(
              "📌 Recommended: ${_fmt(data.initialRecommendationDate)}",
              style: theme.textTheme.labelSmall,
            ),
            if (data.lastVerifiedDate != null)
              Text(
                "✅ Verified: ${_fmt(data.lastVerifiedDate!)}",
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: scheme.secondary),
              ),
            const SizedBox(height: 10),
            // Emoji / Size / Rank
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(data.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Icon(_sizeIcon(data.size),
                    color: scheme.onSurface.withOpacity(0.7), size: 18),
                const SizedBox(width: 8),
                if (data.wrixlRank != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("Wrixler! #${data.wrixlRank}",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: scheme.primary),
                    ),
                    child: Text("Chart",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.primary, fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text("Bookmark",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onPrimary, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBlock(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: scheme.onSurface)),
        Text(label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: scheme.onSurface.withOpacity(0.6))),
      ],
    );
  }
}
