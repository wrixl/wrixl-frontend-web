// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\wrixler_rank_tier.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class WrixlerRankTierWidget extends StatelessWidget {
  const WrixlerRankTierWidget({super.key});

  final int currentXp = 1240;
  final int nextTierXp = 2000;
  final String currentTier = "Whale";
  final String nextTier = "Kraken";

  List<String> get perks => const [
        "+5% WRX Rewards",
        "Access to Prediction Leaderboards",
        "Badge-Eligible Challenges",
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final xpProgress = currentXp / nextTierXp;
    final remainingXp = nextTierXp - currentXp;

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("🏆 Your Wrixler Rank",
                    style: theme.textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: "How Rank Tiers Work",
                  onPressed: () => showDialog(
                    context: context,
builder: (_) => NewWidgetModal(
  title: "Wrixler Tiers Explained",
  onClose: () => Navigator.of(context).pop(),
  child: const Text(
    "Tier progression is based on XP earned via predictions, votes, and community actions.",
  ),
),

                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            Text("🐋 $currentTier Tier",
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Text("XP: $currentXp / $nextTierXp",
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: xpProgress,
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 18),
                const SizedBox(width: 6),
                Text("Next: $nextTier ($remainingXp XP to go)",
                    style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: perks
                  .map((perk) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            Flexible(child: Text(perk, style: theme.textTheme.bodyMedium)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () => showDialog(
                context: context,

builder: (_) => NewWidgetModal(
  title: "How to Earn XP",
  onClose: () => Navigator.of(context).pop(),
  child: const Text(
    "Earn XP by making predictions, voting on signal proposals, and referring users.",
  ),
),

              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("How to Earn XP →"),
            ),
          ],
        ),
      ),
    );
  }
}
