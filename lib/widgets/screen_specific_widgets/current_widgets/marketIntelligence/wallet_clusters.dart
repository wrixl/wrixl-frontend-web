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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildClusterSelector(theme),
            const SizedBox(height: 16),
            _buildTopTokensTable(theme),
            const SizedBox(height: 20),
            _buildCompositionPieChart(scheme),
            const SizedBox(height: 20),
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

  Widget _buildTopTokensTable(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Tokens by Conviction', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...topTokens.map((t) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(radius: 16, child: Text(t['token'], style: const TextStyle(fontSize: 12))),
                Text('${t['weight']}%', style: theme.textTheme.bodyMedium),
                Text('Δ ${t['change']}%', style: TextStyle(
                  color: t['change'] >= 0 ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                )),
                Text(t['conviction'], style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCompositionPieChart(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cluster Composition',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: PieChart(PieChartData(
            sectionsSpace: 1,
            centerSpaceRadius: 30,
            sections: composition.entries
                .map((e) => PieChartSectionData(
                      value: e.value,
                      title: '${e.key} (${e.value.toInt()}%)',
                      titleStyle: const TextStyle(fontSize: 10),
                      radius: 42,
                    ))
                .toList(),
          )),
        )
      ],
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
        OutlinedButton.icon(
          icon: const Icon(Icons.notifications_active_outlined),
          label: const Text('Alert on Shift'),
          onPressed: () {},
        ),
      ],
    );
  }
}
