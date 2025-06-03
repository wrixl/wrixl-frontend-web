// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\claimable_perks.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class ClaimablePerksWidget extends StatefulWidget {
  const ClaimablePerksWidget({Key? key}) : super(key: key);

  @override
  State<ClaimablePerksWidget> createState() => _ClaimablePerksWidgetState();
}

class Perk {
  final String title;
  final String source;
  final String icon;
  final DateTime dateEarned;
  bool claimed;

  Perk({
    required this.title,
    required this.source,
    required this.icon,
    required this.dateEarned,
    this.claimed = false,
  });
}

class _ClaimablePerksWidgetState extends State<ClaimablePerksWidget> {
  List<Perk> perks = [
    Perk(
      title: 'AI Signal Access',
      source: 'Unlocked via Prediction Streak',
      icon: '📈',
      dateEarned: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Perk(
      title: 'Strategy Simulator Trial',
      source: 'Earned from 500 XP',
      icon: '🧰',
      dateEarned: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  void _claimPerk(int index) {
    setState(() {
      perks[index].claimed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unclaimedPerks = perks.where((p) => !p.claimed).toList();
    final claimedPerks = perks.where((p) => p.claimed).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("🎯 Claimable Perks", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (unclaimedPerks.isEmpty)
          _buildEmptyState()
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: unclaimedPerks.map((perk) => _buildPerkCard(perk, false)).toList(),
          ),
        const SizedBox(height: 24),
        if (claimedPerks.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("✅ Claimed", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: claimedPerks.map((perk) => _buildPerkCard(perk, true)).toList(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPerkCard(Perk perk, bool claimed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      width: 200,
      decoration: BoxDecoration(
        color: claimed ? Colors.grey[900] : Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!claimed)
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(perk.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(perk.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(perk.source, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(claimed
              ? "Claimed on ${DateFormat('MMM d').format(perk.dateEarned)}"
              : "Unlocked ${DateFormat('MMM d').format(perk.dateEarned)}"),
          const SizedBox(height: 12),
          if (!claimed)
            ElevatedButton(
              onPressed: () => _claimPerk(perks.indexOf(perk)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.black,
              ),
              child: const Text("Claim Now"),
            )
          else
            const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.card_giftcard, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text("No perks unlocked yet.", style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Text("Keep predicting, voting, and earning to unlock perks!",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
