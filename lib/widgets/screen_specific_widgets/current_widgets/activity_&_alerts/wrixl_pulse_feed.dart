// lib\widgets\screen_specific_widgets\current_widgets\activity_&_alerts\wrixl_pulse_feed.dart

import 'package:flutter/material.dart';

class WrixlPulseFeedWidget extends StatefulWidget {
  const WrixlPulseFeedWidget({super.key});

  @override
  State<WrixlPulseFeedWidget> createState() => _WrixlPulseFeedWidgetState();
}

class _WrixlPulseFeedWidgetState extends State<WrixlPulseFeedWidget> {
  final List<Map<String, dynamic>> _feedItems = _dummyPulseFeedItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.bubble_chart, color: Colors.indigo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Wrixl Pulse Feed',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Future toggle (Trending / Real-Time / 24h)
                  },
                  child: const Text('Real-Time'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _feedItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _feedItems[index];
                  return _buildFeedCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedCard(Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item['icon'], color: item['color']),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['headline'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item['subtext'],
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: List.generate(item['actions'].length, (i) {
                final action = item['actions'][i];
                return ElevatedButton(
                  onPressed: () {
                    // Handle action callback
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                  child: Text(action),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _dummyPulseFeedItems = [
  {
    'icon': Icons.local_fire_department_rounded,
    'color': Colors.redAccent,
    'headline': '🔥 Token Flow: \$ENA mirrored 32x in last 1h',
    'subtext': 'Smart wallets increasing exposure by +14%',
    'actions': ['Mirror', 'Simulate']
  },
  {
    'icon': Icons.trending_up_rounded,
    'color': Colors.blueAccent,
    'headline': '📈 Signal Surge: “Narrative L2 Rush” hit 91% confidence',
    'subtext': 'Added to 23 portfolios in 2h',
    'actions': ['View Signal']
  },
  {
    'icon': Icons.group_outlined,
    'color': Colors.green,
    'headline':
        '👥 Portfolio Popularity: “Stable Yield Stacker” gained 40 new followers',
    'subtext': '17% return over 7d',
    'actions': ['Copy Strategy']
  },
  {
    'icon': Icons.auto_graph_rounded,
    'color': Colors.orange,
    'headline': '📊 Airdrop Sim spike: L2 Stimulus tool used 78x today',
    'subtext': 'User behavior suggests new speculative rotation forming',
    'actions': ['Try Tool']
  },
];
