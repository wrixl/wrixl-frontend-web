// lib\widgets\screen_specific_widgets\current_widgets\streak_tracker_widget.dart

// lib\widgets\screen_specific_widgets\current_widgets\streak_tracker_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakTrackerWidget extends StatefulWidget {
  const StreakTrackerWidget({Key? key}) : super(key: key);

  @override
  State<StreakTrackerWidget> createState() => _StreakTrackerWidgetState();
}

enum BehaviorType { trade, vote, simulate, login }

class _StreakTrackerWidgetState extends State<StreakTrackerWidget> {
  final DateTime today = DateTime.now();
  final int totalDays = 21;
  BehaviorType currentBehavior = BehaviorType.trade;

  late List<Map<String, dynamic>> streakData;

  final Map<BehaviorType, String> behaviorLabels = {
    BehaviorType.trade: 'Profitable Trades',
    BehaviorType.vote: 'Votes Cast',
    BehaviorType.simulate: 'AI Simulations',
    BehaviorType.login: 'Daily Logins',
  };

  @override
  void initState() {
    super.initState();
    _generateStreakData();
  }

  void _generateStreakData() {
    streakData = List.generate(totalDays, (i) {
      final date = today.subtract(Duration(days: totalDays - 1 - i));
      final isDone = Random().nextBool();
      return {
        'date': date,
        'done': isDone,
        'milestone': i % 7 == 0,
      };
    });
  }

  int get currentStreak {
    int count = 0;
    for (int i = streakData.length - 1; i >= 0; i--) {
      if (streakData[i]['done']) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  int get longestStreak {
    int max = 0;
    int count = 0;
    for (final day in streakData) {
      if (day['done']) {
        count++;
        max = max < count ? count : max;
      } else {
        count = 0;
      }
    }
    return max;
  }

  String? get todayAction {
    if (streakData.last['done']) return null;
    switch (currentBehavior) {
      case BehaviorType.trade:
        return "Make a profitable trade today.";
      case BehaviorType.vote:
        return "Cast a DAO vote today.";
      case BehaviorType.simulate:
        return "Run an AI simulation today.";
      case BehaviorType.login:
        return "Open WRIXL and view insights.";
    }
  }

  Widget _buildBehaviorToggle(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 4,
      children: BehaviorType.values.map((type) {
        final isSelected = type == currentBehavior;
        return ChoiceChip(
          selected: isSelected,
          label: Text(behaviorLabels[type]!),
          onSelected: (_) => setState(() {
            currentBehavior = type;
            _generateStreakData();
          }),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔥 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange.shade700),
                    const SizedBox(width: 4),
                    Text(
                      "${currentStreak}-day streak",
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: "View insights",
                  onPressed: () => _showStreakModal(context),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 🧠 Behavior Toggle
            _buildBehaviorToggle(context),
            const SizedBox(height: 6),

            // 📆 Grid Display
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: streakData.length,
              padding: const EdgeInsets.symmetric(vertical: 2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 0,
                crossAxisSpacing: 2,
                childAspectRatio: 2.1,
              ),
              itemBuilder: (_, index) {
                final item = streakData[index];
                final date = item['date'] as DateTime;
                final isDone = item['done'] as bool;
                final isToday = DateFormat.yMd().format(date) ==
                    DateFormat.yMd().format(today);
                final isMilestone = item['milestone'] as bool;

                IconData icon;
                Color color;

                if (isToday) {
                  icon = Icons.star_rounded;
                  color = Colors.amber;
                } else if (isDone && isMilestone) {
                  icon = Icons.whatshot;
                  color = Colors.deepPurpleAccent;
                } else if (isDone) {
                  icon = Icons.check_circle;
                  color = Colors.green;
                } else {
                  icon = Icons.cancel;
                  color = Colors.grey.shade400;
                }

                return Tooltip(
                  message: DateFormat.MMMd().format(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(icon, size: 18, color: color),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 6),

            // 🎯 Today CTA
            if (todayAction != null)
              Column(
                children: [
                  Text("Today’s Action:",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    todayAction!,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.bolt, size: 16),
                      label: const Text("Take Action",
                          style: TextStyle(fontSize: 13)),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            if (todayAction == null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "✅ Today’s streak already completed!",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showStreakModal(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text("Streak Insights", style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔥 Current Streak: $currentStreak days"),
            Text("🏆 Longest Streak: $longestStreak days"),
            const SizedBox(height: 8),
            Text("Tracking: ${behaviorLabels[currentBehavior]}"),
            const SizedBox(height: 8),
            const Text("🎯 Bonus Milestones:"),
            const Text("• 3-day: +XP Boost"),
            const Text("• 7-day: +Strategy Badge"),
            const Text("• 14-day: Leaderboard Bump"),
            const SizedBox(height: 8),
            const Text("🧠 Tips to Maintain:"),
            const Text("✔️ Show up daily"),
            const Text("📈 Take meaningful actions"),
            const Text("🎁 Hit milestones for rewards"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
