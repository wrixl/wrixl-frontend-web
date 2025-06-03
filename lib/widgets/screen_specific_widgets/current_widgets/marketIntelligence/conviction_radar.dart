// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\conviction_radar.dart


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ConvictionRadarWidget extends StatefulWidget {
  const ConvictionRadarWidget({super.key});

  @override
  State<ConvictionRadarWidget> createState() => _ConvictionRadarWidgetState();
}

class _ConvictionRadarWidgetState extends State<ConvictionRadarWidget> {
  final List<String> clusters = ["All", "VCs", "Degens", "Bridge Wallets"];
  String selectedCluster = "All";

  final List<_TokenConviction> tokens = [
    _TokenConviction(
      ticker: "JITO",
      score: 92,
      repeatBuys: 3,
      dipBuys: 2,
      holdingDays: 18,
      walletCount: 7,
      recentBuys: [3, 4, 5, 2, 4, 3, 2],
    ),
    _TokenConviction(
      ticker: "FET",
      score: 85,
      repeatBuys: 2,
      dipBuys: 1,
      holdingDays: 12,
      walletCount: 5,
      recentBuys: [2, 2, 1, 3, 2, 2, 1],
    ),
    _TokenConviction(
      ticker: "GRAI",
      score: 76,
      repeatBuys: 3,
      dipBuys: 0,
      holdingDays: 7,
      walletCount: 9,
      recentBuys: [1, 1, 2, 2, 3, 1, 1],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("📡 Conviction Radar", style: theme.textTheme.titleLarge),
            const SizedBox(width: 8),
            Tooltip(message: "Which tokens smart wallets are buying repeatedly and holding.",
              child: const Icon(Icons.info_outline, size: 18),
            ),
            const Spacer(),
            ToggleButtons(
              isSelected: clusters.map((c) => c == selectedCluster).toList(),
              onPressed: (index) => setState(() => selectedCluster = clusters[index]),
              children: clusters.map((c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(c))).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: tokens.map(_buildTokenTile).toList(),
        ),
      ],
    );
  }

  Widget _buildTokenTile(_TokenConviction token) {
    final theme = Theme.of(context);
    final highConviction = token.score >= 80;

    return GestureDetector(
      onTap: () => _showTokenDetail(token),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        width: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (highConviction)
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              )
          ],
          border: Border.all(color: highConviction ? theme.colorScheme.primary : Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🪙 ${token.ticker}", style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text("Score: ${token.score}", style: theme.textTheme.bodySmall),
            Text("Repeat Buys: ${token.repeatBuys}", style: theme.textTheme.bodySmall),
            Text("Dip Buys: ${token.dipBuys}", style: theme.textTheme.bodySmall),
            Text("Wallets: ${token.walletCount}", style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            SizedBox(height: 32, child: _buildSparkline(token.recentBuys)),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkline(List<int> data) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
            isCurved: true,
            color: Colors.greenAccent,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
          )
        ],
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
      ),
    );
  }

  void _showTokenDetail(_TokenConviction token) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Token Conviction: ${token.ticker}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Conviction Score: ${token.score}"),
              Text("Repeat Buys: ${token.repeatBuys}"),
              Text("Dip Buys: ${token.dipBuys}"),
              Text("Holding Days: ${token.holdingDays}"),
              Text("Wallets Involved: ${token.walletCount}"),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
          ],
        );
      },
    );
  }
}

class _TokenConviction {
  final String ticker;
  final int score;
  final int repeatBuys;
  final int dipBuys;
  final int holdingDays;
  final int walletCount;
  final List<int> recentBuys;

  _TokenConviction({
    required this.ticker,
    required this.score,
    required this.repeatBuys,
    required this.dipBuys,
    required this.holdingDays,
    required this.walletCount,
    required this.recentBuys,
  });
}
