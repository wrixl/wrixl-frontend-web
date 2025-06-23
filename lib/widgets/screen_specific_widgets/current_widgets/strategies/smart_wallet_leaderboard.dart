// lib/widgets/screen_specific_widgets/current_widgets/strategies/smart_wallet_leaderboard.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class SmartWalletLeaderboard extends StatefulWidget {
  const SmartWalletLeaderboard({Key? key}) : super(key: key);

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
      'sparkline': [1.2, 1.3, 1.5, 1.4, 1.7, 1.9, 2.0],
    },
    {
      'name': 'MomentumMax',
      'roi': 21.3,
      'volatility': 'Medium',
      'followers': 189,
      'score': 85,
      'fit': 'Medium Fit',
      'tags': ['🚀 Momentum'],
      'sparkline': [1.0, 1.1, 1.2, 1.3, 1.35, 1.4, 1.45],
    },
  ];

  void _changeSort(String? value) {
    if (value == null) return;
    setState(() => _sortBy = value);
  }

  void _openWalletModal(Map<String, dynamic> wallet) {
    showNewReusableModal(
      context,
      title: wallet['name'],
      size: WidgetModalSize.medium,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wrixl Score: ${wallet['score']}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('ROI: ${wallet['roi']}%'),
          Text('Volatility: ${wallet['volatility']}'),
          Text('Followers: ${wallet['followers']}'),
          const SizedBox(height: 12),
          Text('Fit: ${wallet['fit']}'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: (wallet['tags'] as List<String>)
                .map((tag) => Chip(label: Text(tag, style: const TextStyle(fontSize: 12))))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text('Performance Sparkline:', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          _buildSparkline(wallet['sparkline'] as List<double>),
        ],
      ),
    );
  }

  Widget _buildSparkline(List<double> data) {
    return SizedBox(
      width: 200,
      height: 60,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildWalletCard(Map<String, dynamic> wallet) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _openWalletModal(wallet),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          color: scheme.surfaceVariant,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Fit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(wallet['name'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(wallet['fit'], style: Theme.of(context).textTheme.labelSmall),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openWalletModal(wallet),
                      icon: const Icon(Icons.auto_graph, size: 16),
                      label: const Text("Mirror"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  children: (wallet['tags'] as List<String>)
                      .map((tag) => Chip(label: Text(tag, style: const TextStyle(fontSize: 12))))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Stats
                Text(
                  "ROI: ${wallet['roi']}%  •  Volatility: ${wallet['volatility']}  •  Followers: ${wallet['followers']}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                // Sparkline
                _buildSparkline(wallet['sparkline'] as List<double>),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          color: scheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Smart Wallet Leaderboard",
                        style: Theme.of(context).textTheme.titleMedium),
                    DropdownButton<String>(
                      value: _sortBy,
                      onChanged: _changeSort,
                      items: ['Wrixl Score', 'ROI', 'Followers']
                          .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Scrollable Wallet List
                Expanded(
                  child: ListView.builder(
                    itemCount: wallets.length,
                    itemBuilder: (context, index) {
                      return _buildWalletCard(wallets[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
