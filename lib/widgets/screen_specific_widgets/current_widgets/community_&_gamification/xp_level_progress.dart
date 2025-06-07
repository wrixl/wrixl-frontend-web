// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/xp_level_progress.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class XPLevelProgressWidget extends StatelessWidget {
  final int currentXP;
  final int nextLevelXP;
  final String currentTier;
  final String nextTier;
  final String tierIcon;
  final VoidCallback onEarnXPPressed;
  final bool isLevelingUp;

  const XPLevelProgressWidget({
    super.key,
    required this.currentXP,
    required this.nextLevelXP,
    required this.currentTier,
    required this.nextTier,
    required this.tierIcon,
    required this.onEarnXPPressed,
    this.isLevelingUp = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = currentXP / nextLevelXP;
    final xpRemaining = nextLevelXP - currentXP;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("XP & Rank Progress",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.trending_up, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '$tierIcon Level ${_getLevel(currentXP)} – $currentTier',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isLevelingUp)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.auto_awesome, color: Colors.amber),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 16,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLevelingUp ? Colors.amber : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$currentXP XP / $nextLevelXP XP',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '+$xpRemaining XP to $nextTier',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onEarnXPPressed,
                child: const Text('How to earn XP →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getLevel(int xp) {
    if (xp >= 5000) return 6;
    if (xp >= 3000) return 5;
    if (xp >= 2000) return 4;
    if (xp >= 1000) return 3;
    if (xp >= 500) return 2;
    return 1;
  }
}
