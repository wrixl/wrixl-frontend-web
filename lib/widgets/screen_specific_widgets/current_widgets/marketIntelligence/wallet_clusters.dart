// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\wallet_clusters.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletClustersWidget extends StatefulWidget {
  const WalletClustersWidget({super.key});

  @override
  State<WalletClustersWidget> createState() => _WalletClustersWidgetState();
}

class _WalletClustersWidgetState extends State<WalletClustersWidget> {
  final List<String> clusters = [
    'Top VCs',
    'Smart Degens',
    'Bridge LPs',
    'Influencers',
    'Dormant Whales'
  ];
  String selectedCluster = 'Top VCs';

  final List<Map<String, dynamic>> topTokens = [
    {'token': 'LRT', 'weight': 12.3, 'change': 4.6, 'conviction': 'High'},
    {'token': 'ETH', 'weight': 23.1, 'change': -2.0, 'conviction': 'Neutral'},
    {'token': 'MEME', 'weight': 4.9, 'change': 3.9, 'conviction': 'Fading'},
    {'token': 'BRT', 'weight': 12.3, 'change': 4.6, 'conviction': 'High'},
    {'token': 'MTH', 'weight': 23.1, 'change': -2.0, 'conviction': 'Neutral'},
    {'token': 'PEME', 'weight': 4.9, 'change': 3.9, 'conviction': 'Fading'},
  ];

  final Map<String, double> composition = {
    'AI': 30,
    'RWA': 20,
    'L2s': 25,
    'DeFi': 15,
    'Others': 10
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // so the scroll view shrinks to its content when it's small:
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildClusterSelector(theme),
            const SizedBox(height: 16),

            // fixed‐height charts row
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(child: _buildTokenBarChart(theme)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildCompositionChart(scheme)),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _buildSparkline(),
            const SizedBox(height: 16),
            _buildCTAButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Wallet Clusters', style: theme.textTheme.titleMedium),
        DropdownButton<String>(
          value: 'Behavior-Based',
          items: const [
            DropdownMenuItem(value: 'Behavior-Based', child: Text('Behavior-Based')),
            DropdownMenuItem(value: 'Sector-Based', child: Text('Sector-Based')),
            DropdownMenuItem(value: 'Social-Based', child: Text('Social-Based')),
          ],
          onChanged: (_) {},
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildClusterSelector(ThemeData theme) {
      return SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: clusters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cluster = clusters[index];
            final selected = cluster == selectedCluster;
            return ChoiceChip(
              label: Text(cluster),
              selected: selected,
              onSelected: (_) => setState(() => selectedCluster = cluster),
              selectedColor: theme.colorScheme.primary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      );
    }

    Widget _buildTokenBarChart(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Tokens by Conviction',
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // this Expanded/ListView will scroll if there are too many tokens
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: topTokens.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, i) {
              final token = topTokens[i];
              return Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(token['token'],
                        style: theme.textTheme.bodySmall),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: token['weight'] / 100,
                      color: _convictionColor(token['conviction']),
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Δ ${token['change']}%',
                    style: TextStyle(
                      color: token['change'] >= 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Color _convictionColor(String conviction) {
    switch (conviction) {
      case 'High':
        return Colors.green;
      case 'Neutral':
        return Colors.grey;
      case 'Fading':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildCompositionChart(ColorScheme scheme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartHeight =
            constraints.maxHeight > 300 ? 200 : constraints.maxHeight * 0.7;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cluster Composition',
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: chartHeight,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 1,
                  centerSpaceRadius: chartHeight / 2.5,
                  sections: composition.entries
                      .map((e) => PieChartSectionData(
                            value: e.value,
                            title: '${e.key} (${e.value.toInt()}%)',
                            titleStyle: const TextStyle(fontSize: 10),
                            radius: chartHeight / 4,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSparkline() {
    final List<double> data = [
      0.5, 0.8, 0.7, 1.2, 0.9, 1.3, 0.6, 0.4, 0.7, 0.5,
      // … etc …
    ];

    return SizedBox(
      height: 60,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: data.length.toDouble() - 1,
        ),
      ),
    );
  }

  Widget _buildCTAButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('Simulate Cluster'),
              onPressed: () {},
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.track_changes_outlined),
              label: const Text('Track Tokens'),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.wallet),
              label: const Text('View Wallets'),
              onPressed: () {},
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Alert on Shift'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
