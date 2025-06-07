// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\signals_dao_voting.dart

// lib\widgets\screen_specific_widgets\current_widgets\community_\&_gamification\signals_dao_voting.dart

import 'package:flutter/material.dart';
import 'dart:math';

class SignalsDAOVotingWidget extends StatefulWidget {
  const SignalsDAOVotingWidget({Key? key}) : super(key: key);

  @override
  State<SignalsDAOVotingWidget> createState() => _SignalsDAOVotingWidgetState();
}

class _SignalsDAOVotingWidgetState extends State<SignalsDAOVotingWidget> {
  final List<Map<String, dynamic>> _proposals = [
    {
      'title': 'Signal L2 Surge',
      'description': 'Community proposal to prioritize layer 2 protocols as high-confidence trade signals.',
      'yes': 28,
      'no': 27,
      'timeLeft': '5h 34m',
      'userVote': null
    },
    {
      'title': 'Signal AI Rotation',
      'description': 'Community proposal to prioritize AI narratives as high-confidence trade signals.',
      'yes': 67,
      'no': 24,
      'timeLeft': '5h 4m',
      'userVote': null
    },
    {
      'title': 'Signal DEX Spike',
      'description': 'Community proposal to prioritize DEX volume spikes as high-confidence trade signals.',
      'yes': 18,
      'no': 15,
      'timeLeft': '4h 4m',
      'userVote': null
    },
    {
      'title': 'Signal Stablecoin Divergence',
      'description': 'Community proposal to prioritize stablecoin flows as high-confidence trade signals.',
      'yes': 40,
      'no': 26,
      'timeLeft': '3h 56m',
      'userVote': null
    },
  ];

  void _vote(int index, String vote) {
    setState(() {
      _proposals[index]['userVote'] = vote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Signals DAO Voting', style: theme.textTheme.titleMedium),
                const Spacer(),
                const Icon(Icons.how_to_vote, color: Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _proposals.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final proposal = _proposals[index];
                  final totalVotes = proposal['yes'] + proposal['no'];
                  final yesPercent = (proposal['yes'] / totalVotes) * 100;
                  final noPercent = 100 - yesPercent;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surfaceVariant.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.analytics_outlined, color: scheme.secondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(proposal['title'], style: theme.textTheme.titleSmall),
                            ),
                            Text(proposal['timeLeft'], style: theme.textTheme.labelMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(proposal['description'], style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: yesPercent / 100,
                            minHeight: 12,
                            backgroundColor: scheme.surface.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('👍 ${yesPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12)),
                            Text('👎 ${noPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (proposal['userVote'] == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _vote(index, 'yes'),
                                icon: const Icon(Icons.thumb_up),
                                label: const Text('Yes'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _vote(index, 'no'),
                                icon: const Icon(Icons.thumb_down),
                                label: const Text('No'),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              ),
                            ],
                          )
                        else
                          Center(
                            child: Text(
                              'You voted ${proposal['userVote'].toUpperCase()}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
