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
    final progress = (currentProgress / bonusThreshold).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🔥 WRX Rewards Dashboard', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('💰 Total Earned: $totalEarned WRX', style: theme.textTheme.bodyLarge),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('⏳ Claimable: $claimable WRX', style: theme.textTheme.labelMedium?.copyWith(color: Colors.amber[800])),
              )
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text('📈 This Week: $weeklyEarned WRX')),
              Expanded(child: Text('📅 This Month: $monthlyEarned WRX')),
            ],
          ),

          const SizedBox(height: 16),
          Text('📊 Earnings Breakdown:', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Text('- 🧠 Predictions: $predictionEarned WRX'),
          Text('- 🗳️ Voting: $votingEarned WRX'),
          Text('- 📣 Referrals: $referralEarned WRX'),

          const SizedBox(height: 16),
          Text('🪜 Bonus Progress:', style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: theme.dividerColor,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 6),
          Text('$currentProgress / $bonusThreshold WRX — 🎁 Next Bonus: +$nextBonusAmount WRX'),

          const SizedBox(height: 16),
          Text('🚀 Tip: $nextActionTip', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary)),
        ],
      ),
    );
  }
}
