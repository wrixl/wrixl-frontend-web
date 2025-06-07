// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\community_challenges.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityChallengesWidget extends StatefulWidget {
  const CommunityChallengesWidget({super.key});

  @override
  State<CommunityChallengesWidget> createState() => _CommunityChallengesWidgetState();
}

class Challenge {
  final String title;
  final String description;
  final DateTime endTime;
  final String reward;
  final int current;
  final int total;
  final String status;
  final String rank;

  Challenge({
    required this.title,
    required this.description,
    required this.endTime,
    required this.reward,
    required this.current,
    required this.total,
    required this.status,
    required this.rank,
  });
}

class _CommunityChallengesWidgetState extends State<CommunityChallengesWidget> {
  late List<Challenge> challenges;

  @override
  void initState() {
    super.initState();
    challenges = [
      Challenge(
        title: 'Curate 3 Signals this Week',
        description: 'Vote on signal proposals to complete',
        endTime: DateTime.now().add(const Duration(hours: 62)),
        reward: '+10 WRX + 100 XP',
        current: 2,
        total: 3,
        status: 'in_progress',
        rank: '—',
      ),
      Challenge(
        title: 'Predict Top Gainer – 24h Challenge',
        description: 'Place predictions in Signal Arena',
        endTime: DateTime.now().add(const Duration(hours: 11)),
        reward: '+250 XP + Gold 🏅',
        current: 3,
        total: 3,
        status: 'completed',
        rank: '#4 of 76',
      ),
      Challenge(
        title: 'Refer 2 Friends',
        description: 'Use your referral code to invite users',
        endTime: DateTime.now().add(const Duration(days: 5)),
        reward: '+50 WRX + Badge 🎖️',
        current: 0,
        total: 2,
        status: 'available',
        rank: '—',
      )
    ];
  }

  String formatRemainingTime(DateTime endTime) {
    final duration = endTime.difference(DateTime.now());
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h left';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m left';
    } else {
      return '${duration.inMinutes}m left';
    }
  }

  Widget buildChallengeCard(Challenge c) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🏆 ${c.title}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                Text(formatRemainingTime(c.endTime), style: const TextStyle(color: Colors.orangeAccent))
              ],
            ),
            const SizedBox(height: 6),
            Text(c.description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text('🎁 ${c.reward}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.greenAccent)),
            const SizedBox(height: 12),
            if (c.status == 'in_progress')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: c.current / c.total,
                    color: Colors.amber,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 4),
                  Text('📊 Progress: ${c.current} / ${c.total}',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            if (c.status == 'completed')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('📉 Rank: ${c.rank}', style: Theme.of(context).textTheme.bodyMedium),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_events),
                    label: const Text('Claim Reward'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  )
                ],
              ),
            if (c.status == 'available')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Join'),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Community Challenges', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Time-limited missions for glory & XP',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            ...challenges.map(buildChallengeCard)
          ],
        ),
      ),
    );
  }
}
