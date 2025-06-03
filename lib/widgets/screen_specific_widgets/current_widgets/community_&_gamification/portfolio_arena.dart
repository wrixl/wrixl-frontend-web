// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\portfolio_arena.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PortfolioArenaWidget extends StatefulWidget {
  const PortfolioArenaWidget({Key? key}) : super(key: key);

  @override
  State<PortfolioArenaWidget> createState() => _PortfolioArenaWidgetState();
}

class _PortfolioContest {
  final String name;
  final String goal;
  final Duration timeRemaining;
  final int entries;
  final double prizePool;
  final double estimatedReturn;
  final bool userEntered;
  final String contestType;

  _PortfolioContest({
    required this.name,
    required this.goal,
    required this.timeRemaining,
    required this.entries,
    required this.prizePool,
    required this.estimatedReturn,
    required this.userEntered,
    required this.contestType,
  });
}

class _PortfolioArenaWidgetState extends State<PortfolioArenaWidget> {
  final List<_PortfolioContest> _contests = [
    _PortfolioContest(
      name: 'L2 Alpha Stack',
      goal: 'Beat +5% in 24h',
      timeRemaining: const Duration(hours: 3, minutes: 21),
      entries: 123,
      prizePool: 1200,
      estimatedReturn: 2.1,
      userEntered: true,
      contestType: '🎯 Target %',
    ),
    _PortfolioContest(
      name: 'AI Dominators',
      goal: 'Top 3 by % gain',
      timeRemaining: const Duration(hours: 6, minutes: 10),
      entries: 89,
      prizePool: 950,
      estimatedReturn: 3.0,
      userEntered: false,
      contestType: '🏁 Top 3',
    ),
  ];

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _openEntryModal(_PortfolioContest contest) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contest.name,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Goal: ${contest.goal}'),
              const SizedBox(height: 8),
              Text('Time remaining: ${_formatDuration(contest.timeRemaining)}'),
              const SizedBox(height: 16),
              Text('Estimated Return: ${contest.estimatedReturn}×'),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stake WRX',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Stake & Enter'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _contests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final contest = _contests[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('🧠 Portfolio: ${contest.name}', style: Theme.of(context).textTheme.titleMedium),
                    Text(contest.contestType),
                  ],
                ),
                const SizedBox(height: 8),
                Text('🎯 Goal: ${contest.goal}'),
                const SizedBox(height: 4),
                Text('⏱ Ends in: ${_formatDuration(contest.timeRemaining)}   👥 Entries: ${contest.entries}'),
                const SizedBox(height: 4),
                Text('🏆 Prize Pool: ${contest.prizePool.toStringAsFixed(0)} WRX'),
                const SizedBox(height: 4),
                Text('💼 Est. Return: ${contest.estimatedReturn.toStringAsFixed(1)}×'),
                const SizedBox(height: 12),
                if (contest.userEntered)
                  Text('✅ You’re in! Est. rank: Top 24%', style: TextStyle(color: Colors.blueAccent)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('📈 View Portfolio'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => _openEntryModal(contest),
                      child: const Text('🎯 Enter Contest'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
