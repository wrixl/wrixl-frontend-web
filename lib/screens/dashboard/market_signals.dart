// lib/screens/dashboard/market_signals.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/market_signals_widgets/market_signals_correlation_matrix.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/market_signals_widgets/market_signals_macro_intelligence_cards_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/market_signals_widgets/market_signals_sector_movers_widget.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/market_signals_widgets/market_signals_smart_news_strip_widget.dart';

class MarketSignalsScreen extends StatelessWidget {
  const MarketSignalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Dummy data for Macro Intelligence Cards.
    final List<MacroCardData> macroCards = [
      MacroCardData(
        title: "Crypto vs Traditional",
        snapshotMetric: "BTC +4.1% vs S&P −0.3%",
        chartData: [0.9, 1.1, 1.0, 1.2, 1.1, 1.3, 1.4],
        chartType: ChartType.line,
        tag: "Risk‑On",
        tagColor: scheme.primary,
        icon: Icons.show_chart,
        onTap: () {},
      ),
      MacroCardData(
        title: "Volatility Index",
        snapshotMetric: "VIX: 25 (7d up)",
        chartData: [22, 23, 24, 25, 26, 25, 27],
        chartType: ChartType.bar,
        tag: "Volatile",
        tagColor: scheme.error,
        icon: Icons.trending_up,
        onTap: () {},
      ),
      MacroCardData(
        title: "Stablecoin Flows",
        snapshotMetric: "Net minting +3M",
        chartData: [100, 103, 105, 102, 108, 110, 115],
        chartType: ChartType.pie,
        tag: "Liquidity",
        tagColor: scheme.secondary,
        icon: Icons.water_drop,
        onTap: () {},
      ),
      MacroCardData(
        title: "Global Money Supply",
        snapshotMetric: "M2 +1.8% QoQ",
        chartData: [92, 93, 94, 96, 97, 98, 99],
        chartType: ChartType.line,
        tag: "Expansion",
        tagColor: scheme.primary,
        icon: Icons.public,
        onTap: () {},
      ),
    ];

    // Dummy data for Smart News Strip.
    final List<NewsItem> newsItems = [
      NewsItem(
        headline: "Market rallies as BTC surges, signaling new momentum",
        sentiment: "Positive",
        source: "Decrypt",
        category: "Only Bullish",
      ),
      NewsItem(
        headline: "Gold prices steady amid economic fears and uncertainty",
        sentiment: "Neutral",
        source: "CoinDesk",
        category: "Neutral",
      ),
      NewsItem(
        headline: "Blockchain devs push protocol upgrade in latest sprint",
        sentiment: "Positive",
        source: "CoinDesk",
        category: "Dev‑focused",
      ),
      NewsItem(
        headline: "Crypto regulation intensifies as lawmakers debate policies",
        sentiment: "Negative",
        source: "Decrypt",
        category: "Only Bearish",
      ),
      NewsItem(
        headline:
            "Bitcoin ETF filing gains traction among institutional investors",
        sentiment: "Positive",
        source: "CoinDesk",
        category: "ETF",
      ),
      NewsItem(
        headline: "New crypto regulatory updates raise industry concerns",
        sentiment: "Negative",
        source: "Decrypt",
        category: "Regulatory",
      ),
    ];

    // Dummy data for Sector Movers.
    final List<SectorMover> movers = [
      SectorMover(
        sectorName: "DeFi",
        icon: Icons.account_balance_wallet,
        devActivity: 25.0,
        walletGrowth: 18.0,
        txVolume: -5.0,
        marketCapDelta: 12.0,
        sparklineData: [1.0, 1.1, 1.3, 1.2, 1.4, 1.5, 1.6],
        tokensCount: 15,
        marketCap: 120,
      ),
      SectorMover(
        sectorName: "AI",
        icon: Icons.memory,
        devActivity: 15.0,
        walletGrowth: 12.0,
        txVolume: 8.0,
        marketCapDelta: 20.0,
        sparklineData: [0.9, 1.0, 1.05, 1.2, 1.3, 1.4, 1.5],
        tokensCount: 10,
        marketCap: 85,
      ),
      SectorMover(
        sectorName: "Gaming",
        icon: Icons.videogame_asset,
        devActivity: -5.0,
        walletGrowth: 10.0,
        txVolume: 5.0,
        marketCapDelta: 3.0,
        sparklineData: [1.2, 1.15, 1.1, 1.05, 1.0, 0.95, 0.9],
        tokensCount: 8,
        marketCap: 50,
      ),
      SectorMover(
        sectorName: "NFTs",
        icon: Icons.image,
        devActivity: 8.0,
        walletGrowth: 7.0,
        txVolume: 12.0,
        marketCapDelta: 5.0,
        sparklineData: [1.0, 1.05, 1.1, 1.15, 1.2, 1.18, 1.25],
        tokensCount: 20,
        marketCap: 200,
      ),
      SectorMover(
        sectorName: "L2s",
        icon: Icons.layers,
        devActivity: 20.0,
        walletGrowth: 17.0,
        txVolume: 10.0,
        marketCapDelta: 22.0,
        sparklineData: [1.1, 1.2, 1.3, 1.25, 1.35, 1.40, 1.45],
        tokensCount: 12,
        marketCap: 150,
      ),
      SectorMover(
        sectorName: "Blockchain",
        icon: Icons.block,
        devActivity: 30.0,
        walletGrowth: 20.0,
        txVolume: 15.0,
        marketCapDelta: 18.0,
        sparklineData: [1.0, 1.2, 1.4, 1.3, 1.5, 1.6, 1.7],
        tokensCount: 18,
        marketCap: 180,
      ),
      SectorMover(
        sectorName: "Metaverse",
        icon: Icons.vrpano,
        devActivity: 12.0,
        walletGrowth: 14.0,
        txVolume: 9.0,
        marketCapDelta: 10.0,
        sparklineData: [0.8, 0.9, 1.0, 1.1, 1.0, 1.05, 1.1],
        tokensCount: 16,
        marketCap: 95,
      ),
      SectorMover(
        sectorName: "Web3",
        icon: Icons.cloud,
        devActivity: 22.0,
        walletGrowth: 19.0,
        txVolume: 13.0,
        marketCapDelta: 16.0,
        sparklineData: [1.2, 1.3, 1.35, 1.4, 1.45, 1.5, 1.55],
        tokensCount: 14,
        marketCap: 130,
      ),
      SectorMover(
        sectorName: "Crypto Payment",
        icon: Icons.payment,
        devActivity: 18.0,
        walletGrowth: 16.0,
        txVolume: 12.0,
        marketCapDelta: 14.0,
        sparklineData: [1.1, 1.15, 1.2, 1.25, 1.3, 1.35, 1.4],
        tokensCount: 22,
        marketCap: 210,
      ),
    ];

    // Dummy data for Correlation Matrix.
    final List<String> correlationLabels = [
      "DeFi",
      "Layer 1",
      "Meme Coins",
      "NFT",
      "AI",
      "BTC",
      "ETH",
      "Gold",
      "S&P 500",
      "NASDAQ"
    ];
    final List<List<double>> correlationMatrix = [
      [1.00, 0.45, 0.30, 0.35, 0.25, 0.60, 0.55, -0.60, -0.95, 0.00],
      [0.45, 1.00, 0.50, 0.40, 0.80, 0.55, 0.60, -0.05, 0.00, 0.05],
      [0.30, 0.50, 1.00, 0.45, 0.35, 0.40, 0.45, -0.70, -0.05, 0.00],
      [0.35, 0.40, 0.45, 1.00, 0.55, 0.50, 0.45, -0.405, 0.00, 0.05],
      [0.25, 0.30, 0.35, 0.55, 1.00, 0.40, 0.35, -0.10, 0.05, 0.00],
      [0.60, 0.55, 0.40, 0.50, 0.40, 1.00, 0.85, -0.05, -0.10, -0.05],
      [0.55, 0.60, 0.45, 0.45, 0.35, 0.85, 1.00, 0.40, -0.75, 0.00],
      [-0.30, -0.05, -0.10, -0.45, -0.70, -0.05, 0.00, 1.00, 0.60, 0.25],
      [-0.50, 0.00, -0.05, 0.00, 0.05, -0.40, -0.05, 0.20, 1.00, 0.85],
      [0.10, 0.05, 0.03, 0.45, 0.00, -0.65, 0.00, 0.25, -0.85, 1.00],
    ];

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? scheme.surface,
        elevation: theme.appBarTheme.elevation ?? 0,
        iconTheme: theme.appBarTheme.iconTheme,
        title: Text("Market Signals",
            style:
                theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildThemedCard(context,
                child: SizedBox(
                    height: 385,
                    child: MarketSignalsMacroIntelligenceCardsWidget(
                        cards: macroCards))),
            const SizedBox(height: 24),
            _buildThemedCard(context,
                child: CorrelationMatrixWidget(
                    labels: correlationLabels,
                    matrix: correlationMatrix,
                    title: "Correlation Matrix")),
            const SizedBox(height: 24),
            _buildThemedCard(context,
                child: SizedBox(
                    height: 350,
                    child: MarketSignalsSectorMoversWidget(movers: movers))),
            const SizedBox(height: 24),
            _buildThemedCard(context,
                child: SizedBox(
                    height: 290,
                    child: MarketSignalsSmartNewsStripWidget(
                        newsItems: newsItems))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedCard(BuildContext context, {required Widget child}) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.primary.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(0.15),
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
