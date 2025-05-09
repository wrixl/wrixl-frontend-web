// lib\screens\dashboard\mirror_insights.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/miror_insights_widgets/mirror_strategy_builder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/miror_insights_widgets/mirror_suggestion_tile.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/miror_insights_widgets/profit_line_chart.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/miror_insights_widgets/wallet_tile.dart';

class MirrorInsightsScreen extends StatefulWidget {
  const MirrorInsightsScreen({Key? key}) : super(key: key);

  @override
  State<MirrorInsightsScreen> createState() => _MirrorInsightsScreenState();
}

class _MirrorInsightsScreenState extends State<MirrorInsightsScreen> {
  final List<String> walletStrategies = [
    "Conservative Whale",
    "Aggressive Degen",
    "Yield Optimizer",
  ];

  final List<String> holdingThemes = [
    "AI",
    "DeFi",
    "Meme",
  ];

  String? selectedStrategy;
  String? selectedTheme;

  @override
  void initState() {
    super.initState();
    selectedStrategy = walletStrategies.first;
    selectedTheme = holdingThemes.first;
  }

  final List<WalletData> walletDataList = [
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
    WalletData(
      address: "0xC3d4...9Ab7",
      strategyTag: "Meme Scout",
      emoji: "🐸",
      roi7d: "+25%",
      roi30d: "+45%",
      sharpe: "0.7",
      winRate: "58%",
      followers: "95K",
      confidence: 0.6,
      size: "striped bass",
      avgHoldMonths: 2,
      uniqueTokens: 42,
      reputation: 3.7,
      recommendation: 68,
      roiTrend: [0.0, 0.5, 1.0, 1.3, 1.6, 2.0, 2.5],
      topHoldings: ["PEPE", "DOGE", "BONK"],
      dominantChain: "Solana",
      assetTypeMix: "90% Meme, 10% DeFi",
      behaviorTags: ["High Risk", "Trend Chaser"],
      activeMirrors: 860,
      avgMirrorRoi: "+22.5%",
      initialRecommendationDate: DateTime(2025, 1, 15),
      lastVerifiedDate: DateTime(2025, 3, 28),
    ),
    WalletData(
      address: "0xD01e...7A2C",
      strategyTag: "AI Yield",
      emoji: "🤖",
      roi7d: "+9%",
      roi30d: "+21%",
      sharpe: "1.4",
      winRate: "77%",
      followers: "180K",
      confidence: 0.85,
      size: "tuna",
      avgHoldMonths: 5,
      uniqueTokens: 33,
      reputation: 4.1,
      recommendation: 89,
      wrixlRank: 7,
      roiTrend: [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
      topHoldings: ["FET", "AGIX", "OCEAN"],
      dominantChain: "Polygon",
      assetTypeMix: "70% AI, 20% Yield, 10% Stable",
      behaviorTags: ["Auto Compounding", "Cross Chain"],
      activeMirrors: 1580,
      avgMirrorRoi: "+17.9%",
      initialRecommendationDate: DateTime(2024, 12, 3),
      lastVerifiedDate: DateTime(2025, 4, 11),
    ),
  ];

  final List<MirrorSuggestionData> suggestionList = [
    MirrorSuggestionData(
      name: "L2 Diversifier",
      confidence: 0.82,
      similarityScore: "91%",
      projectedRoi: "+17.2%",
      volatility: "Medium",
      strategyTag: "Cross-L2 Blend",
      sharpe: "1.3",
      topHoldings: ["ARB", "OP", "BASE"],
      dominantChain: "Arbitrum",
      assetTypeMix: "50% L2 Tokens, 30% DeFi, 20% Stable",
      initialRecommendationDate: DateTime(2024, 11, 20),
      investmentGoal: "Exposure to emerging L2s",
      goalAchieved: "63%",
      horizon: "6–12 months",
      isBookmarked: false,
      onBookmark: () => debugPrint("Bookmarked L2 Diversifier"),
      onPreview: () => debugPrint("Preview L2 Diversifier"),
      onAdopt: () => debugPrint("Adopt L2 Diversifier"),
    ),
    MirrorSuggestionData(
      name: "Stable Yield Mixer",
      confidence: 0.76,
      similarityScore: "84%",
      projectedRoi: "+12.9%",
      volatility: "Low",
      strategyTag: "Stable LP Compounder",
      sharpe: "1.1",
      topHoldings: ["USDC", "DAI", "CRV"],
      dominantChain: "Ethereum",
      assetTypeMix: "70% Stablecoins, 20% Yield, 10% Governance",
      initialRecommendationDate: DateTime(2024, 10, 10),
      investmentGoal: "Passive stablecoin yield",
      goalAchieved: "82%",
      horizon: "12+ months",
      isBookmarked: true,
      onBookmark: () => debugPrint("Unbookmarked Stable Yield Mixer"),
      onPreview: () => debugPrint("Preview Stable Yield Mixer"),
      onAdopt: () => debugPrint("Adopt Stable Yield Mixer"),
    ),
    MirrorSuggestionData(
      name: "Cross-Chain Momentum",
      confidence: 0.68,
      similarityScore: "79%",
      projectedRoi: "+21.4%",
      volatility: "High",
      strategyTag: "Rotation Trader",
      sharpe: "0.9",
      topHoldings: ["SOL", "AVAX", "INJ"],
      dominantChain: "Solana",
      assetTypeMix: "50% Layer 1s, 30% AI, 20% Altcoins",
      initialRecommendationDate: DateTime(2025, 1, 5),
      investmentGoal: "Capture high-beta breakout rallies",
      goalAchieved: "54%",
      horizon: "1–3 months",
      isBookmarked: false,
      onBookmark: () => debugPrint("Bookmarked Cross-Chain Momentum"),
      onPreview: () => debugPrint("Preview Cross-Chain Momentum"),
      onAdopt: () => debugPrint("Adopt Cross-Chain Momentum"),
    ),
    MirrorSuggestionData(
      name: "Alt Season Signal",
      confidence: 0.88,
      similarityScore: "94%",
      projectedRoi: "+23.8%",
      volatility: "High",
      strategyTag: "Altcoin Sprinter",
      sharpe: "1.4",
      topHoldings: ["DOGE", "SHIB", "PEPE"],
      dominantChain: "Base",
      assetTypeMix: "60% Meme, 30% L2, 10% NFTs",
      initialRecommendationDate: DateTime(2025, 2, 14),
      investmentGoal: "Ride short-term alt surges",
      goalAchieved: "71%",
      horizon: "< 3 months",
      isBookmarked: true,
      onBookmark: () => debugPrint("Unbookmarked Alt Season Signal"),
      onPreview: () => debugPrint("Preview Alt Season Signal"),
      onAdopt: () => debugPrint("Adopt Alt Season Signal"),
    ),
    MirrorSuggestionData(
      name: "Stable + L2 Hybrid",
      confidence: 0.71,
      similarityScore: "83%",
      projectedRoi: "+15.3%",
      volatility: "Medium",
      strategyTag: "Risk-Balanced Vault",
      sharpe: "1.2",
      topHoldings: ["OP", "USDT", "FXS"],
      dominantChain: "Optimism",
      assetTypeMix: "40% Stable, 40% L2, 20% Governance",
      initialRecommendationDate: DateTime(2024, 12, 8),
      investmentGoal: "Blend low-risk yield with L2 growth",
      goalAchieved: "69%",
      horizon: "6–9 months",
      isBookmarked: false,
      onBookmark: () => debugPrint("Bookmarked Stable + L2 Hybrid"),
      onPreview: () => debugPrint("Preview Stable + L2 Hybrid"),
      onAdopt: () => debugPrint("Adopt Stable + L2 Hybrid"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? scheme.surface,
        elevation: theme.appBarTheme.elevation ?? 0,
        iconTheme: theme.appBarTheme.iconTheme,
        title: Text(
          "Mirror Insights",
          style:
              theme.textTheme.titleLarge?.copyWith(color: scheme.onBackground),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildFullWidthCard(
              child: MirrorStrategyBuilder(
                walletStrategies: walletStrategies,
                holdingThemes: holdingThemes,
                selectedStrategy: selectedStrategy!,
                selectedTheme: selectedTheme!,
                onStrategyChanged: (value) =>
                    setState(() => selectedStrategy = value),
                onThemeChanged: (value) =>
                    setState(() => selectedTheme = value),
              ),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: WalletTileListWidget(wallets: walletDataList),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: const ProfitLineChart(),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Suggestions header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AI‑Suggested Mirror Strategies",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        height: 36,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search strategies",
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
                              borderSide: BorderSide(
                                  color: scheme.primary.withOpacity(0.3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: scheme.primary.withOpacity(0.3)),
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                          onChanged: (query) {
                            // TODO: filter suggestions
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 495,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (_) {},
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(right: 12),
                          itemCount: suggestionList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, i) =>
                              MirrorSuggestionTile(data: suggestionList[i]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthCard({required Widget child}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.primary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
