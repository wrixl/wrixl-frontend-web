// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\referral_impact_tracker.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReferralImpactTrackerWidget extends StatelessWidget {
  const ReferralImpactTrackerWidget({super.key});

  final int totalReferrals = 3;
  final int activeReferrals = 2;
  final double earnedWRX = 45.0;
  final double pendingWRX = 15.0;
  final double nextBonusWRX = 10.0;
  final int goalReferrals = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (totalReferrals / goalReferrals).clamp(0.0, 1.0);
    final isNearGoal = percent >= 0.9;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("👥 Referral Impact Tracker", style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text("You’ve invited $totalReferrals friends — $activeReferrals are active",
              style: theme.textTheme.bodyMedium),
          const SizedBox(height: 20),

          // Metrics Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard(theme, "Earned", "$earnedWRX WRX"),
              _buildMetricCard(theme, "Pending", "$pendingWRX WRX"),
              _buildMetricCard(theme, "Next Bonus", "+$nextBonusWRX WRX @ $goalReferrals"),
            ],
          ),
          const SizedBox(height: 24),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 16,
                    width: MediaQuery.of(context).size.width * percent * 0.7,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Progress: $totalReferrals of $goalReferrals referrals",
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: "https://wrixl.io/referral?code=YOURCODE"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Referral link copied!")),
                  );
                },
                icon: const Icon(Icons.link),
                label: const Text("Copy Link"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNearGoal
                      ? theme.colorScheme.primary.withOpacity(0.85)
                      : theme.colorScheme.primary,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.history),
                label: const Text("View History"),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(ThemeData theme, String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
