// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\community_challenges.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  final String status; // 'available', 'in_progress', 'completed'
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🏆 ${c.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(formatRemainingTime(c.endTime), style: const TextStyle(color: Colors.orangeAccent))
              ],
            ),
            const SizedBox(height: 8),
            Text(c.description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('🎁 ${c.reward}', style: const TextStyle(fontSize: 14, color: Colors.green)),
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
                  Text('📊 Progress: ${c.current} / ${c.total}')
                ],
              ),
            if (c.status == 'completed')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('📉 Rank: ${c.rank}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Community Challenges',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text('Time-limited missions for glory & XP'),
        const SizedBox(height: 16),
        ...challenges.map(buildChallengeCard)
      ],
    );
  }
}
