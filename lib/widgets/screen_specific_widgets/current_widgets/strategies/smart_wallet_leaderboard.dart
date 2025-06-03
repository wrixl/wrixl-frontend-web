// lib\widgets\screen_specific_widgets\current_widgets\strategies\smart_wallet_leaderboard.dart

// lib/widgets/screen_specific_widgets/current_widgets/strategies/smart_wallet_leaderboard.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SmartWalletLeaderboard extends StatefulWidget {
  const SmartWalletLeaderboard({super.key});

  @override
  State<SmartWalletLeaderboard> createState() => _SmartWalletLeaderboardState();
}

class _SmartWalletLeaderboardState extends State<SmartWalletLeaderboard> {
  String _sortBy = 'Wrixl Score';

  final List<Map<String, dynamic>> wallets = [
    {
      'name': 'AlphaWhale',
      'roi': 28.7,
      'volatility': 'Low',
      'followers': 312,
      'score': 91,
      'fit': 'High Fit',
      'tags': ['🐋 Whale', '🧠 AI-Driven'],
      'sparkline': [1.2, 1.3, 1.5, 1.4, 1.7, 1.9, 2.0]
    },
    {
      'name': 'MomentumMax',
      'roi': 21.3,
      'volatility': 'Medium',
      'followers': 189,
      'score': 85,
      'fit': 'Medium Fit',
      'tags': ['🚀 Momentum'],
      'sparkline': [1.0, 1.1, 1.2, 1.3, 1.35, 1.4, 1.45]
    }
  ];

  void _changeSort(String? value) {
    if (value == null) return;
    setState(() {
      _sortBy = value;
    });
  }

  Widget _buildSortHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: _sortBy,
          onChanged: _changeSort,
          items: ['Wrixl Score', 'ROI', 'Followers']
              .map((label) => DropdownMenuItem(value: label, child: Text(label)))
              .toList(),
        ),
        Text("Top Wallets: \${wallets.length}", style: const TextStyle(fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _buildSparkline(List<double> data) {
    return SizedBox(
      width: 100,
      height: 30,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            )
          ],
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildWalletCard(Map<String, dynamic> wallet) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(wallet['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: wallet['fit'] == 'High Fit' ? Colors.green[100] : Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(wallet['fit'], style: const TextStyle(fontSize: 12)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ROI: \${wallet['roi']}%"),
            Text("Volatility: \${wallet['volatility']}"),
            Text("Followers: \${wallet['followers']}"),
            Wrap(
              spacing: 6,
              children: wallet['tags']
                  .map<Widget>((tag) => Chip(label: Text(tag, style: const TextStyle(fontSize: 12))))
                  .toList(),
            ),
            const SizedBox(height: 6),
            _buildSparkline(wallet['sparkline']),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Mirror"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSortHeader(),
        const SizedBox(height: 12),
        ...wallets.map(_buildWalletCard).toList(),
      ],
    );
  }
}
