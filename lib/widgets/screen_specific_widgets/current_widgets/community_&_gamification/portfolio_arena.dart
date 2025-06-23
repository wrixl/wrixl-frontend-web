// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/portfolio_arena.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wrixl_frontend/theme/theme.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

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
  int _hoverIndex = -1;

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
    _PortfolioContest(
      name: 'Meme Wars',
      goal: 'Highest Return in 12h',
      timeRemaining: const Duration(hours: 12),
      entries: 150,
      prizePool: 800,
      estimatedReturn: 2.8,
      userEntered: false,
      contestType: '🚀 Rapid Return',
    ),
    _PortfolioContest(
      name: 'Bluechip Brawl',
      goal: 'Beat ETH by 2%',
      timeRemaining: const Duration(hours: 18, minutes: 15),
      entries: 75,
      prizePool: 1000,
      estimatedReturn: 1.7,
      userEntered: true,
      contestType: '📊 Benchmark',
    ),
    _PortfolioContest(
      name: 'DEX Duel',
      goal: 'Top 10 by Volume Gain',
      timeRemaining: const Duration(hours: 24),
      entries: 65,
      prizePool: 1100,
      estimatedReturn: 3.4,
      userEntered: false,
      contestType: '⚔️ Volume Battle',
    ),
  ];

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _showContestModal(_PortfolioContest contest) {
    showNewReusableModal(
      context,
      title: contest.name,
      size: WidgetModalSize.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contest.name,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Goal: ${contest.goal}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Ends in: ${_formatDuration(contest.timeRemaining)}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Entries: ${contest.entries}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Prize Pool: ${contest.prizePool.toStringAsFixed(0)} WRX',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Estimated Return: ${contest.estimatedReturn.toStringAsFixed(1)}×',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Type: ${contest.contestType}',
              style: Theme.of(context).textTheme.bodyMedium),
          if (contest.userEntered) ...[
            const SizedBox(height: 8),
            Text('✅ You’re in! Good luck.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ],
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stake WRX',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(contest.userEntered ? 'Update Stake' : 'Stake & Enter'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 3,
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Portfolio Arena',
                          style: theme.textTheme.titleMedium),
                      const Spacer(),
                      const Icon(Icons.emoji_events_outlined,
                          color: Colors.amber, size: 22),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          for (int i = 0; i < _contests.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: GestureDetector(
                                onTap: () => _showContestModal(_contests[i]),
                                child: kIsWeb
                                    ? MouseRegion(
                                        onEnter: (_) =>
                                            setState(() => _hoverIndex = i),
                                        onExit: (_) =>
                                            setState(() => _hoverIndex = -1),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          decoration: _hoverIndex == i
                                              ? WrixlTheme.getHoverGlow()
                                              : null,
                                          child: _buildContestCard(_contests[i], theme),
                                        ),
                                      )
                                    : _buildContestCard(_contests[i], theme),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContestCard(_PortfolioContest contest, ThemeData theme) {
    return Container(
      width: 300,
      constraints: const BoxConstraints(minHeight: 200, maxHeight: 500),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.98),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text('🧠 ${contest.name}',
                        style: theme.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(contest.contestType,
                      style:
                          TextStyle(color: theme.colorScheme.secondary)),
                ],
              ),
              const SizedBox(height: 6),
              Text('🎯 Goal: ${contest.goal}',
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                '⏱ Ends in: ${_formatDuration(contest.timeRemaining)}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                ),
              ),
              const SizedBox(height: 4),
              Text('👥 Entries: ${contest.entries}',
                  style: const TextStyle(fontSize: 13)),
              Text('🏆 Prize: ${contest.prizePool.toStringAsFixed(0)} WRX',
                  style: const TextStyle(fontSize: 13)),
              Text('💼 Return: ${contest.estimatedReturn.toStringAsFixed(1)}×',
                  style: const TextStyle(fontSize: 13)),
              if (contest.userEntered) ...[
                const SizedBox(height: 6),
                Text('✅ You’re in!',
                    style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary)),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('📈 View Portfolio'),
                  ),
                  TextButton(
                    onPressed: () => _showContestModal(contest),
                    child: const Text('🎯 Enter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
