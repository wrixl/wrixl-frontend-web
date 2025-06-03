// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\rewards_inventory.dart

import 'package:flutter/material.dart';

class RewardsInventoryWidget extends StatefulWidget {
  const RewardsInventoryWidget({super.key});

  @override
  State<RewardsInventoryWidget> createState() => _RewardsInventoryWidgetState();
}

class _RewardItem {
  final String type; // WRX, XP, Badge, Perk
  final String title;
  final String source;
  final int amount;
  final DateTime dateEarned;
  final bool claimed;
  final String icon;
  final String action;

  _RewardItem({
    required this.type,
    required this.title,
    required this.source,
    required this.amount,
    required this.dateEarned,
    required this.claimed,
    required this.icon,
    required this.action,
  });
}

class _RewardsInventoryWidgetState extends State<RewardsInventoryWidget> {
  bool _showClaimed = false;

  final List<_RewardItem> _rewards = [
    _RewardItem(
      type: 'WRX',
      title: 'Prediction Bonus',
      source: 'Top 10% Accuracy',
      amount: 20,
      dateEarned: DateTime.now().subtract(const Duration(hours: 2)),
      claimed: false,
      icon: '🪙',
      action: 'Claim',
    ),
    _RewardItem(
      type: 'XP',
      title: 'Streak XP Boost',
      source: '5-Day Voting Streak',
      amount: 50,
      dateEarned: DateTime.now().subtract(const Duration(days: 1)),
      claimed: true,
      icon: '📈',
      action: 'Used',
    ),
    _RewardItem(
      type: 'WRX',
      title: 'Referral Reward',
      source: '2 Friends Activated',
      amount: 15,
      dateEarned: DateTime.now().subtract(const Duration(days: 3)),
      claimed: false,
      icon: '🎁',
      action: 'Claim',
    ),
  ];

  void _claimReward(int index) {
    setState(() {
      _rewards[index] = _RewardItem(
        type: _rewards[index].type,
        title: _rewards[index].title,
        source: _rewards[index].source,
        amount: _rewards[index].amount,
        dateEarned: _rewards[index].dateEarned,
        claimed: true,
        icon: _rewards[index].icon,
        action: 'Claimed',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _rewards.where((r) => r.claimed == _showClaimed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("🎁 Rewards Inventory", style: theme.textTheme.titleLarge),
            ToggleButtons(
              isSelected: [_showClaimed == false, _showClaimed == true],
              onPressed: (i) => setState(() => _showClaimed = (i == 1)),
              children: const [Text("Unclaimed"), Text("Claimed")],
            )
          ],
        ),
        const SizedBox(height: 16),
        // Empty state
        if (filtered.isEmpty)
          Center(
            child: Text(
              _showClaimed ? "You’ve claimed everything—well done!" : "No rewards yet. Start predicting!",
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final reward = filtered[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!reward.claimed)
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(reward.icon, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reward.title, style: theme.textTheme.titleMedium),
                            Text(reward.source, style: theme.textTheme.bodySmall),
                            Text("+${reward.amount} ${reward.type}", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (!reward.claimed)
                        ElevatedButton(
                          onPressed: () => _claimReward(index),
                          child: const Text("Claim"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        )
                      else
                        const Icon(Icons.check_circle, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
