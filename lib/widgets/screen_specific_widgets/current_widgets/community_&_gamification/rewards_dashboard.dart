// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/rewards_dashboard.dart

import 'package:flutter/material.dart';

class RewardsDashboardWidget extends StatelessWidget {
  final int totalEarned;
  final int claimable;
  final int weeklyEarned;
  final int monthlyEarned;
  final int predictionEarned;
  final int votingEarned;
  final int referralEarned;
  final int currentProgress;
  final int bonusThreshold;
  final int nextBonusAmount;
  final String nextActionTip;

  const RewardsDashboardWidget({
    super.key,
    this.totalEarned = 1245,
    this.claimable = 25,
    this.weeklyEarned = 145,
    this.monthlyEarned = 490,
    this.predictionEarned = 600,
    this.votingEarned = 400,
    this.referralEarned = 245,
    this.currentProgress = 1245,
    this.bonusThreshold = 1500,
    this.nextBonusAmount = 50,
    this.nextActionTip = "Predict on 1 more signal to reach your bonus!",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (currentProgress / bonusThreshold).clamp(0.0, 1.0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: colorScheme.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🔥 WRX Rewards Dashboard', style: theme.textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('⏳ $claimable WRX',
                      style: theme.textTheme.labelMedium?.copyWith(color: Colors.amber[800])),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text('💰 Total Earned: $totalEarned WRX', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('📈 This Week: $weeklyEarned WRX')),
                Expanded(child: Text('📅 This Month: $monthlyEarned WRX')),
              ],
            ),
            const SizedBox(height: 16),
            Text('📊 Earnings Breakdown:', style: theme.textTheme.labelLarge),
            const SizedBox(height: 6),
            Text('- 🧠 Predictions: $predictionEarned WRX'),
            Text('- 🗳️ Voting: $votingEarned WRX'),
            Text('- 📣 Referrals: $referralEarned WRX'),
            const SizedBox(height: 16),
            Text('🎁 Bonus Progress', style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: theme.dividerColor,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 6),
            Text('$currentProgress / $bonusThreshold WRX — Next Bonus: +$nextBonusAmount WRX'),
            const SizedBox(height: 12),
            Text('🚀 $nextActionTip',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
          ],
        ),
      ),
    );
  }
}
