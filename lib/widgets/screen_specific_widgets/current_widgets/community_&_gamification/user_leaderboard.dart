// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\user_leaderboard.dart

import 'package:flutter/material.dart';
import 'dart:math';

class UserLeaderboardWidget extends StatefulWidget {
  const UserLeaderboardWidget({Key? key}) : super(key: key);

  @override
  State<UserLeaderboardWidget> createState() => _UserLeaderboardWidgetState();
}

class _UserLeaderboardWidgetState extends State<UserLeaderboardWidget> {
  String _sortBy = 'XP';
  String _filterBy = 'This Week';
  final List<Map<String, dynamic>> _dummyUsers = List.generate(20, (index) {
    return {
      'rank': index + 1,
      'username': 'User${index + 1}',
      'xp': Random().nextInt(5000) + 500,
      'wrx': Random().nextDouble() * 100,
      'tier': ['Bronze', 'Silver', 'Gold', 'Platinum', 'Whale'][index % 5],
      'trend': ['up', 'down', 'stable'][Random().nextInt(3)],
    };
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userRank = 12;
    final userCount = 345;
    final userXP = 1840;
    final userTier = 'Gold';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky Header
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('You are #$userRank of $userCount',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold)),
                          Text('$userXP XP • $userTier Tier'),
                        ],
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Improve Rank'),
                  )
                ],
              ),
            ),

            // Filter Chips
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildChip('XP'),
                _buildChip('WRX Earned'),
                _buildChip('Signal Accuracy'),
                _buildFilterChip('This Week'),
                _buildFilterChip('This Month'),
                _buildFilterChip('All Time'),
              ],
            ),
            const SizedBox(height: 12),

            // Leaderboard Table
            Expanded(
              child: ListView.separated(
                itemCount: _dummyUsers.length,
                separatorBuilder: (_, __) => const Divider(height: 12),
                itemBuilder: (context, index) {
                  final user = _dummyUsers[index];
                  final isTop3 = user['rank'] <= 3;
                  return Container(
                    decoration: BoxDecoration(
                      color: user['username'] == 'User12'
                          ? theme.colorScheme.primary.withOpacity(0.05)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('#${user['rank']}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: isTop3
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: isTop3 ? 18 : 14,
                                )),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['username'],
                                    style: theme.textTheme.bodyLarge),
                                Text('${user['xp']} XP',
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _buildTierBadge(user['tier']),
                            const SizedBox(width: 8),
                            _buildTrendIcon(user['trend']),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _sortBy == label,
      onSelected: (_) => setState(() => _sortBy = label),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: _filterBy == label,
      onSelected: (_) => setState(() => _filterBy = label),
    );
  }

  Widget _buildTierBadge(String tier) {
    final colorMap = {
      'Bronze': Colors.brown,
      'Silver': Colors.grey,
      'Gold': Colors.amber,
      'Platinum': Colors.blueGrey,
      'Whale': Colors.indigo,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorMap[tier]?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        tier,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorMap[tier],
        ),
      ),
    );
  }

  Widget _buildTrendIcon(String trend) {
    final iconMap = {
      'up': Icons.arrow_upward,
      'down': Icons.arrow_downward,
      'stable': Icons.remove,
    };
    final colorMap = {
      'up': Colors.green,
      'down': Colors.red,
      'stable': Colors.grey,
    };
    return Icon(
      iconMap[trend],
      color: colorMap[trend],
      size: 20,
    );
  }
}
