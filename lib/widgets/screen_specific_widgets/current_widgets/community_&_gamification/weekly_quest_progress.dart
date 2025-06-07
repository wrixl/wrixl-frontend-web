// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\weekly_quest_progress.dart

import 'package:flutter/material.dart';
import 'dart:async';

class WeeklyQuestProgressWidget extends StatefulWidget {
  const WeeklyQuestProgressWidget({Key? key}) : super(key: key);

  @override
  State<WeeklyQuestProgressWidget> createState() => _WeeklyQuestProgressWidgetState();
}

class _WeeklyQuestProgressWidgetState extends State<WeeklyQuestProgressWidget> {
  late Timer _timer;
  Duration _timeLeft = const Duration(days: 2, hours: 14);

  final List<_Quest> quests = [
    _Quest(icon: '🟢', title: 'Predict 3 Signals', reward: 60, current: 2, total: 3, actionLabel: 'Predict'),
    _Quest(icon: '🟣', title: 'Vote on 5 DAO Proposals', reward: 50, current: 1, total: 5, actionLabel: 'Vote'),
    _Quest(icon: '🔶', title: 'Refer 1 Friend', reward: 40, current: 0, total: 1, actionLabel: 'Share'),
    _Quest(icon: '🔄', title: 'Log In 5 Days in a Row', reward: 30, current: 3, total: 5, actionLabel: 'Track'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _timeLeft = _timeLeft - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.remainder(24).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '${d.inDays}d $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    int completed = quests.where((q) => q.current >= q.total).length;
    int total = quests.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🎯 Weekly Challenges', style: theme.textTheme.titleMedium),
                Text('⏳ Ends in: ${_formatDuration(_timeLeft)}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline))
              ],
            ),
            const SizedBox(height: 16),
            ...quests.map((q) => _buildQuestCard(q, theme)),
            const SizedBox(height: 12),
            _buildFinalReward(completed, total, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard(_Quest q, ThemeData theme) {
    bool isComplete = q.current >= q.total;
    double percent = (q.current / q.total).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.withOpacity(0.05) : Colors.transparent,
        border: Border.all(color: isComplete ? Colors.green : theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(q.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(child: Text('${q.title} +${q.reward} XP', style: theme.textTheme.bodyMedium)),
              if (!isComplete)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('→ ${q.actionLabel}'),
                )
              else
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: percent),
          ),
          const SizedBox(height: 4),
          Text('${q.current}/${q.total} completed', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline))
        ],
      ),
    );
  }

  Widget _buildFinalReward(int completed, int total, ThemeData theme) {
    bool allComplete = completed == total;
    double percent = (completed / total).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: allComplete ? Colors.amber.withOpacity(0.1) : Colors.transparent,
        border: Border.all(color: allComplete ? Colors.amber : theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🏁 Complete All Quests', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              const Text('+100 XP 🎁')
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: percent, color: Colors.amber),
          ),
          const SizedBox(height: 4),
          Text('$completed/$total Quests Complete', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline))
        ],
      ),
    );
  }
}

class _Quest {
  final String icon;
  final String title;
  final int reward;
  final int current;
  final int total;
  final String actionLabel;

  const _Quest({
    required this.icon,
    required this.title,
    required this.reward,
    required this.current,
    required this.total,
    required this.actionLabel,
  });
}
