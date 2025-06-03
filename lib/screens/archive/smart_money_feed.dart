// lib\screens\dashboard\smart_money_feed.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/screens/archive/live_ticker.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/capital_movement_map.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_widget_insights_feeder.dart';
import 'package:wrixl_frontend/widgets/screen_specific_widgets/current_widgets/marketIntelligence/smart_money_feed_insight_cards.dart';

/// SmartMoneyFeedScreen provides a real‑time, actionable view into the moves
/// of top wallets and funds. It’s broken into 4 sections:
/// 1. Live Whale Ticker
/// 2. Insight Cards Grid
/// 3. Flow Diagram
/// 4. AI‑powered commentary feed
class SmartMoneyFeedScreen extends StatefulWidget {
  const SmartMoneyFeedScreen({Key? key}) : super(key: key);

  @override
  _SmartMoneyFeedScreenState createState() => _SmartMoneyFeedScreenState();
}

class _SmartMoneyFeedScreenState extends State<SmartMoneyFeedScreen> {
  // —— Dummy data for demonstration —— //

  final List<String> tickerMessages = [
    "Whale 0xAB... just moved 2.4M USDC to DEX Y",
    "Top fund wallet accumulating LDO for 3 days straight",
    "New Smart Wallet: 22% ROI over last 7 days – Mostly trading SOL and OP",
    "Whale 0x91... swapped 1.8M USDT for ETH on GigaByte",
    "Smart LP 0xFA... pulled liquidity from Curve — 4% slippage",
    "Hedge Fund Cluster entering stablecoin rotation: USDC → DAI",
    "0x7D... sold 900K MEME tokens — down 40% in 48h",
    "AI-tagged wallet: 16 wins in 18 trades — focusing on L2 tokens",
    "Clustered wallets signaling LayerZero accumulation",
    "Top performer 0xCC... swapped 600K USDT into WBTC",
    "Wallet 0x33... mirror trades suggest prepping for OP breakout",
    "High-frequency whale 0xEF... executed 112 trades in 24h",
    "DeFi Index whales moving capital to Pendle and Lyra",
    "NFT whale 0x99... offloaded 14 collections in bulk to ETH",
    "Smart Money Score: 0xA1... jumped from 71 to 91 in 5 days",
  ];

  final List<Map<String, dynamic>> insightCards = [
    {
      'title': 'Biggest Daily Accumulator',
      'stat': 'Wallet 0xFD... acquired 5M USDC',
      'priceSpots': {
        'FTC': [
          FlSpot(0, 1.21),
          FlSpot(1, 1.42),
          FlSpot(2, 6.98),
          FlSpot(3, 9.24),
          FlSpot(4, 5.56),
          FlSpot(5, 8.3),
          FlSpot(6, 9.82),
        ],
      },
      'wallets': ['0xABC...', '0xABC...'],
      'commentary':
          'Wallet showed strong stablecoin positioning in the last 24 hours.',
      'totalValue': 5000000.0,
      'confidence': 4,
      'trendType': 'New Trend',
      'tokens': ['FTC'],
      'chains': ['Ethereum', 'Ripple']
    },
    {
      'title': 'Top Selling Wallet',
      'stat': 'Sold 3M USDC in 24h',
      'priceSpots': {
        'FTC': [
          FlSpot(0, 9.93),
          FlSpot(1, 5.05),
          FlSpot(2, 7.76),
          FlSpot(3, 7.61),
          FlSpot(4, 5.57),
          FlSpot(5, 6.62),
          FlSpot(6, 3.91),
        ],
        'SUSHI': [
          FlSpot(0, 3.0),
          FlSpot(1, 2.95),
          FlSpot(2, 2.98),
          FlSpot(3, 2.97),
          FlSpot(4, 3.1),
          FlSpot(5, 3.2),
          FlSpot(6, 3.0),
        ],
      },
      'wallets': ['0xBCD...', '0xBCD...'],
      'commentary': 'Consistent outflows observed amid market uncertainty.',
      'totalValue': 3000000.0,
      'confidence': 3,
      'trendType': 'Trend Confirmation',
      'tokens': ['FTC', 'SUSHI'],
      'chains': ['Ethereum']
    },
    {
      'title': 'Smart Money Sector Shift',
      'stat': 'Shifted to L2s',
      'priceSpots': {
        'ETH': [
          FlSpot(0, 9.2),
          FlSpot(1, 3.0),
          FlSpot(2, 5.49),
          FlSpot(3, 1.6),
          FlSpot(4, 7.67),
          FlSpot(5, 2.14),
          FlSpot(6, 6.76),
        ],
        'FTC': [
          FlSpot(0, 2.5),
          FlSpot(1, 2.8),
          FlSpot(2, 2.7),
          FlSpot(3, 2.6),
          FlSpot(4, 2.9),
          FlSpot(5, 3.1),
          FlSpot(6, 3.0),
        ],
      },
      'wallets': ['0xCDE...', '0xCDE...'],
      'commentary': 'Notable migration from ETH mainnet into L2 ecosystems.',
      'totalValue': 12800000.0,
      'confidence': 4,
      'trendType': 'Trend Reversal',
      'tokens': ['ETH', 'FTC'],
      'chains': ['Ethereum', 'Factom']
    },
    {
      'title': 'AI Wallet of the Week',
      'stat': 'ROI: 38% over 7 days',
      'priceSpots': {
        'GBYTE': [
          FlSpot(0, 6.94),
          FlSpot(1, 8.59),
          FlSpot(2, 2.42),
          FlSpot(3, 8.72),
          FlSpot(4, 7.62),
          FlSpot(5, 7.91),
          FlSpot(6, 8.26),
        ],
        'FTC': [
          FlSpot(0, 4.1),
          FlSpot(1, 4.2),
          FlSpot(2, 4.3),
          FlSpot(3, 4.5),
          FlSpot(4, 4.4),
          FlSpot(5, 4.6),
          FlSpot(6, 4.8),
        ],
      },
      'wallets': ['0xDEF...', '0xDEF...'],
      'commentary': 'Dominant L2 trading with rapid swap frequency.',
      'totalValue': 3100000.0,
      'confidence': 5,
      'trendType': 'New Trend',
      'tokens': ['GBYTE', 'FTC'],
      'chains': ['GigaByte', 'Factom']
    },
    {
      'title': 'Most Profitable Wallet',
      'stat': '+\$720K profit this week',
      'priceSpots': {
        'ETH': [
          FlSpot(0, 3.11),
          FlSpot(1, 2.13),
          FlSpot(2, 3.86),
          FlSpot(3, 1.63),
          FlSpot(4, 2.27),
          FlSpot(5, 9.97),
          FlSpot(6, 1.94),
        ],
        'GBYTE': [
          FlSpot(0, 1.0),
          FlSpot(1, 1.0),
          FlSpot(2, 1.0),
          FlSpot(3, 1.0),
          FlSpot(4, 1.0),
          FlSpot(5, 1.0),
          FlSpot(6, 1.0),
        ],
      },
      'wallets': ['0xEFG...', '0xEFG...'],
      'commentary':
          'Strong DEX performance and low entry points across tokens.',
      'totalValue': 720000.0,
      'confidence': 5,
      'trendType': 'Trend Confirmation',
      'tokens': ['ETH', 'GBYTE'],
      'chains': ['Ethereum']
    },
    {
      'title': 'Biggest NFT Exit',
      'stat': '\$1.4M outflow from NFTs',
      'priceSpots': {
        'SUSHI': [
          FlSpot(0, 9.34),
          FlSpot(1, 1.82),
          FlSpot(2, 2.88),
          FlSpot(3, 6.39),
          FlSpot(4, 1.16),
          FlSpot(5, 6.01),
          FlSpot(6, 1.56),
        ],
      },
      'wallets': ['0xFGH...', '0xFGH...'],
      'commentary': 'Smart wallets moved liquidity from NFTs to stables.',
      'totalValue': 1400000.0,
      'confidence': 4,
      'trendType': 'Trend Reversal',
      'tokens': ['SUSHI'],
      'chains': ['Ethereum']
    },
    {
      'title': 'Whale Consolidation',
      'stat': 'Now holding only 3 tokens',
      'priceSpots': {
        'ETH': [
          FlSpot(0, 4.07),
          FlSpot(1, 4.06),
          FlSpot(2, 8.98),
          FlSpot(3, 9.48),
          FlSpot(4, 6.24),
          FlSpot(5, 7.2),
          FlSpot(6, 7.98),
        ],
        'WBTC': [
          FlSpot(0, 30.0),
          FlSpot(1, 30.5),
          FlSpot(2, 31.0),
          FlSpot(3, 32.0),
          FlSpot(4, 33.0),
          FlSpot(5, 32.5),
          FlSpot(6, 31.8),
        ],
        'GBYTE': [
          FlSpot(0, 1.0),
          FlSpot(1, 1.0),
          FlSpot(2, 1.0),
          FlSpot(3, 1.0),
          FlSpot(4, 1.0),
          FlSpot(5, 1.0),
          FlSpot(6, 1.0),
        ],
      },
      'wallets': ['0xGHI...', '0xGHI...'],
      'commentary': 'Portfolio tightened to core assets post-volatility.',
      'totalValue': 12400000.0,
      'confidence': 4,
      'trendType': 'Trend Confirmation',
      'tokens': ['ETH', 'WBTC', 'GBYTE'],
      'chains': ['Ethereum', 'Polygon']
    },
    {
      'title': 'Rotation into Yield',
      'stat': '4 wallets farming Factom yields',
      'priceSpots': {
        'FTC': [
          FlSpot(0, 6.0),
          FlSpot(1, 2.9),
          FlSpot(2, 3.44),
          FlSpot(3, 2.95),
          FlSpot(4, 2.68),
          FlSpot(5, 3.5),
          FlSpot(6, 8.28),
        ],
        'GBYTE': [
          FlSpot(0, 2.3),
          FlSpot(1, 2.4),
          FlSpot(2, 2.5),
          FlSpot(3, 2.6),
          FlSpot(4, 2.7),
          FlSpot(5, 2.8),
          FlSpot(6, 2.9),
        ],
      },
      'wallets': ['0xHIJ...', '0xHIJ...'],
      'commentary': 'High APYs triggered smart contract interaction surges.',
      'totalValue': 4700000.0,
      'confidence': 3,
      'trendType': 'New Trend',
      'tokens': ['FTC', 'GBYTE'],
      'chains': ['Factom', 'GigaByte']
    },
  ];

  final List<Map<String, dynamic>> feedItems = [
    {
      'insight': 'Hedge funds entering DeFi yield plays',
      'detail':
          'Pendle, Lyra, and Aura saw 17.2M USD inflows from fund-tagged wallets. '
              'Rotational play suggests confidence in short-term yield optimization.',
      'walletType': 'Fund',
      'confidence': 4,
      'wallets': ['0xF1...', '0xD3...', '0xE4...'],
      'tokens': ['GBYTE', 'SUSHI', 'WBTC'],
      'tags': ['Yield Farming', 'Rotation', 'DeFi'],
      'timestamp': '12:02 • 04/09',
    },
    {
      'insight': 'Whale cluster shedding MEME exposure',
      'detail': 'Over 2.1M USD in MEME tokens dumped. On-chain signals suggest '
          'redeployment toward GigaByte yield plays and low-cap L2 assets.',
      'walletType': 'Whale',
      'confidence': 3,
      'wallets': ['0xA2...', '0xC1...'],
      'tokens': ['GBYTE'],
      'tags': ['Exit Pattern', 'Risk Off', 'L2 Rotation'],
      'timestamp': '11:47 • 04/09',
    },
    {
      'insight': 'Fresh wallet hits 100K USD profit in 48 hours',
      'detail':
          'New high-frequency trader surfaced on Base. Executed 38 trades '
              'with an 82% win rate. Monitoring ongoing behavior.',
      'walletType': 'Fresh Wallet',
      'confidence': 3,
      'wallets': ['0xNew...'],
      'tokens': ['USDC', 'ETH', 'SUSHI'],
      'tags': ['High Activity', 'Base Chain', 'Fresh Wallet'],
      'timestamp': '10:55 • 04/09',
    },
    {
      'insight': 'Degens rotate from NFTs into yield tokens',
      'detail':
          'NFT-heavy wallets exited JPEGs and moved into L2 LPs (GBYTE, FTC). '
              'Avg APR: 14.6%. Slippage: minimal.',
      'walletType': 'Degen',
      'confidence': 2,
      'wallets': ['0xDE...', '0xGN...'],
      'tokens': ['GBYTE', 'FTC'],
      'tags': ['Rotation', 'Yield', 'NFT Exit'],
      'timestamp': '10:24 • 04/09',
    },
  ];

  /// Wraps each section in a full-width “card” that reads from the theme.
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        title: Text(
          "Smart Money Tracking",
          style:
              theme.textTheme.titleLarge?.copyWith(color: scheme.onBackground),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFullWidthCard(
              child: LiveWhaleTicker(),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: SmartMoneyFeedInsightCards(),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: const SmartMoneyFeedFlowDiagram(),
            ),
            const SizedBox(height: 24),
            _buildFullWidthCard(
              child: SmartMoneyWidgetInsightsFeeder(),
            ),
          ],
        ),
      ),
    );
  }
}
