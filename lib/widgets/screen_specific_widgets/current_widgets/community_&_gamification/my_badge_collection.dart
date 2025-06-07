// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\my_badge_collection.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class MyBadgeCollectionWidget extends StatefulWidget {
  const MyBadgeCollectionWidget({super.key});

  @override
  State<MyBadgeCollectionWidget> createState() => _MyBadgeCollectionWidgetState();
}

class _Badge {
  final String emoji;
  final String title;
  final String description;
  final bool isUnlocked;
  final bool isNew;
  final double progress;
  final String? dateEarned;

  const _Badge({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isUnlocked,
    this.isNew = false,
    this.progress = 0.0,
    this.dateEarned,
  });
}

class _MyBadgeCollectionWidgetState extends State<MyBadgeCollectionWidget> {
  List<_Badge> badges = [
    const _Badge(
        emoji: '🏆',
        title: 'Prediction Master',
        description: 'Earned for 20 correct predictions',
        isUnlocked: true,
        isNew: true,
        progress: 1.0,
        dateEarned: 'Apr 10'),
    const _Badge(
        emoji: '🕵️',
        title: 'Curation Detective',
        description: 'Voted on 10 signals',
        isUnlocked: true,
        progress: 1.0,
        dateEarned: 'Apr 5'),
    const _Badge(
        emoji: '📈',
        title: 'Bull Rider',
        description: 'Backed a 5x gainer',
        isUnlocked: false,
        progress: 0.6),
    const _Badge(
        emoji: '📣',
        title: 'Signal Shouter',
        description: 'Submitted 5 approved signals',
        isUnlocked: false,
        progress: 0.0),
    const _Badge(
        emoji: '🧠',
        title: 'DAO Voter',
        description: 'Participated in 3 governance votes',
        isUnlocked: true,
        progress: 1.0,
        dateEarned: 'Mar 28'),
    const _Badge(
        emoji: '🏅',
        title: 'Weekly Champion',
        description: 'Top 3 in leaderboard',
        isUnlocked: false,
        progress: 0.0),
  ];

  String getCurrentTier() => 'Silver Wrixler';
  int getUnlockedCount() => badges.where((b) => b.isUnlocked).length;
  int getTotalBadges() => badges.length;

  void _openBadgeModal(_Badge badge) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: badge.title,
        size: WidgetModalSize.small,
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            if (badge.isUnlocked)
              Text('Earned on ${badge.dateEarned}',
                  style: const TextStyle(color: Colors.green))
            else if (badge.progress > 0.0)
              Text('Progress: ${(badge.progress * 100).round()}%\nKeep going to unlock!',
                  textAlign: TextAlign.center)
            else
              Text('Locked — ${badge.description}', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCell(_Badge badge) {
    return GestureDetector(
      onTap: () => _openBadgeModal(badge),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: badge.isUnlocked ? Colors.white10 : Colors.white10.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: badge.isUnlocked ? Colors.greenAccent : Colors.grey.shade800,
            width: badge.isUnlocked ? 2.0 : 1.0,
          ),
          boxShadow: badge.isNew
              ? [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.7),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(badge.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: badge.isUnlocked ? Colors.white : Colors.white60,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Badge Collection", style: Theme.of(context).textTheme.titleMedium),
                const Icon(Icons.emoji_events_outlined, color: Colors.amberAccent),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: scheme.primary.withOpacity(0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🎖 Tier: ${getCurrentTier()}'),
                  Text('🏅 ${getUnlockedCount()} / ${getTotalBadges()} Badges')
                ],
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width < 600 ? 3 : 5,
              shrinkWrap: true,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: badges.map(_buildBadgeCell).toList(),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('View All Badges'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
