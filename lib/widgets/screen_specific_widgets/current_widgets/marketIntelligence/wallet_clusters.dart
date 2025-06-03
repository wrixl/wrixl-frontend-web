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
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildClusterSelector(theme),
            const SizedBox(height: 16),
            _buildTopTokensTable(),
            const SizedBox(height: 16),
            _buildCompositionPieChart(theme),
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
        Text('Wallet Clusters',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: 'Behavior-Based',
          items: const [
            DropdownMenuItem(value: 'Behavior-Based', child: Text('Behavior-Based')),
            DropdownMenuItem(value: 'Sector-Based', child: Text('Sector-Based')),
            DropdownMenuItem(value: 'Social-Based', child: Text('Social-Based')),
          ],
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _buildClusterSelector(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: clusters.length,
        itemBuilder: (context, index) {
          final cluster = clusters[index];
          final selected = cluster == selectedCluster;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(cluster),
              selected: selected,
              onSelected: (_) => setState(() => selectedCluster = cluster),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopTokensTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Tokens by Conviction'),
        const SizedBox(height: 8),
        ...topTokens.map((t) => ListTile(
              leading: CircleAvatar(child: Text(t['token'])),
              title: Text('${t['token']} - ${t['weight']}%'),
              subtitle: Text(
                  'Change: ${t['change']}% | Conviction: ${t['conviction']}'),
              trailing: Icon(Icons.trending_up),
            )),
      ],
    );
  }

  Widget _buildCompositionPieChart(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cluster Composition'),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: PieChart(PieChartData(
            sections: composition.entries
                .map((e) => PieChartSectionData(
                      value: e.value,
                      title: '${e.key} (${e.value.toStringAsFixed(0)}%)',
                      radius: 50,
                    ))
                .toList(),
          )),
        )
      ],
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Simulate Cluster')),
        ElevatedButton(onPressed: () {}, child: const Text('Track Tokens')),
        ElevatedButton(onPressed: () {}, child: const Text('Alert on Shift')),
      ],
    );
  }
}
