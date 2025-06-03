// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\top_sector_rankings.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class TopSectorRankingsWidget extends StatefulWidget {
  const TopSectorRankingsWidget({Key? key}) : super(key: key);

  @override
  State<TopSectorRankingsWidget> createState() => _TopSectorRankingsWidgetState();
}

class _TopSectorRankingsWidgetState extends State<TopSectorRankingsWidget> {
  final List<String> sectors = ['All', 'AI', 'DeFi', 'L2s', 'RWA'];
  String activeSector = 'AI';

  final List<Map<String, dynamic>> dummyLeaderboard = [
    {'rank': 1, 'name': 'CryptoQueen', 'gain': 24.3},
    {'rank': 2, 'name': 'L2Legend', 'gain': 19.1},
    {'rank': 3, 'name': 'GregToken', 'gain': 16.8},
    {'rank': 4, 'name': 'You', 'gain': 15.2},
    {'rank': 5, 'name': 'ChainGuru', 'gain': 13.5},
  ];

  void _openFullLeaderboardModal() {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: 'Full Sector Leaderboard',
        onClose: () => Navigator.of(context).pop(),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Expanded leaderboard and sector filter UI goes here.'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("📊 Top Sector Rankings", style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),

        // User Highlight
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          child: const Text("You’re #4 in AI Sector • +15.2% WRX gain"),
        ),

        // Sector Tabs
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sectors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final sector = sectors[index];
              final isActive = sector == activeSector;
              return GestureDetector(
                onTap: () => setState(() => activeSector = sector),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
                  ),
                  child: Text(
                    sector,
                    style: theme.textTheme.labelLarge!.copyWith(
                      color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Leaderboard Table
        Column(
          children: dummyLeaderboard.map((entry) {
            final isUser = entry['name'] == 'You';
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isUser
                    ? theme.colorScheme.primary.withOpacity(0.2)
                    : theme.cardColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${entry['rank'] <= 3 ? ['🥇','🥈','🥉'][entry['rank']-1] : entry['rank']}.',
                    style: theme.textTheme.bodyLarge),
                  Expanded(
                    child: Text(
                      entry['name'],
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '+${entry['gain'].toStringAsFixed(1)}%',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _openFullLeaderboardModal,
              child: const Text("View Full Leaderboard"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Earn your AI badge"),
            ),
          ],
        ),
      ],
    );
  }
}
