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
    final scheme = theme.colorScheme;
    final percent = (totalReferrals / goalReferrals).clamp(0.0, 1.0);
    final isNearGoal = percent >= 0.9;

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
                Text("Referral Impact Tracker",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.group_add, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 12),
            Text("You’ve invited $totalReferrals friends — $activeReferrals are active",
                style: theme.textTheme.bodyMedium),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(theme, "Earned", "$earnedWRX WRX"),
                _buildMetric(theme, "Pending", "$pendingWRX WRX"),
                _buildMetric(theme, "Next Bonus", "+$nextBonusWRX WRX @ $goalReferrals"),
              ],
            ),

            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: scheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      height: 14,
                      width: MediaQuery.of(context).size.width * percent * 0.6,
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                    Clipboard.setData(
                        const ClipboardData(text: "https://wrixl.io/referral?code=YOURCODE"));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Referral link copied!")),
                    );
                  },
                  icon: const Icon(Icons.link),
                  label: const Text("Copy Link"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isNearGoal
                        ? scheme.primary.withOpacity(0.9)
                        : scheme.primary,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text("View History"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(ThemeData theme, String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.hintColor)),
              const SizedBox(height: 4),
              Text(value,
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
