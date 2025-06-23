// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/top_sector_rankings.dart

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
    showNewReusableModal(
      context,
      title: 'Full Sector Leaderboard',
      size: WidgetModalSize.medium,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Expanded leaderboard and sector filter UI goes here.'),
      ),
    );
  }

  void _openEntryModal(Map<String, dynamic> entry) {
    final isUser = entry['name'] == 'You';
    showNewReusableModal(
      context,
      title: 'Rank #${entry['rank']} Details',
      size: WidgetModalSize.small,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            entry['rank'] <= 3
                ? ['🥇', '🥈', '🥉'][entry['rank'] - 1]
                : '${entry['rank']}.',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 8),
          Text(
            entry['name'],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '+${(entry['gain'] as double).toStringAsFixed(1)}% WRX gain',
            style: TextStyle(
              fontSize: 16,
              color: isUser ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isUser
                ? 'Keep it up! You’re climbing the ranks in $activeSector.'
                : 'View ${entry['name']}’s full performance in $activeSector.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = theme.colorScheme.primary.withOpacity(0.2);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📊 Top Sector Rankings", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.bar_chart),
                  tooltip: "View Full Leaderboard",
                  onPressed: _openFullLeaderboardModal,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // User Highlight
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              ),
              child: Text(
                "You’re #4 in $activeSector Sector • +15.2% WRX gain",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

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
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        sector,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: isActive
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Leaderboard List
            Column(
              children: dummyLeaderboard.map((entry) {
                final isUser = entry['name'] == 'You';
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _openEntryModal(entry),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isUser ? highlightColor : theme.cardColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry['rank'] <= 3
                                ? ['🥇', '🥈', '🥉'][entry['rank'] - 1]
                                : '${entry['rank']}.',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Expanded(
                            child: Text(
                              entry['name'],
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            '+${(entry['gain'] as double).toStringAsFixed(1)}%',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _openFullLeaderboardModal,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("View Full Leaderboard"),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: navigate to badge-earning flow
                  },
                  child: Text("Earn your $activeSector badge"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

