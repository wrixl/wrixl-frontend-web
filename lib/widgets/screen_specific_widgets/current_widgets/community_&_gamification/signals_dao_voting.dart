// lib\widgets\screen_specific_widgets\current_widgets\community_&_gamification\signals_dao_voting.dart

import 'package:flutter/material.dart';
import 'dart:math';

class SignalsDAOVotingWidget extends StatefulWidget {
  const SignalsDAOVotingWidget({Key? key}) : super(key: key);

  @override
  State<SignalsDAOVotingWidget> createState() => _SignalsDAOVotingWidgetState();
}

class _SignalsDAOVotingWidgetState extends State<SignalsDAOVotingWidget> {
  final List<Map<String, dynamic>> _proposals = List.generate(4, (i) {
    return {
      'title': 'Signal ${['L2 Surge', 'AI Rotation', 'DEX Spike', 'Stablecoin Divergence'][i]}',
      'description': 'Community proposal to prioritize ${['layer 2 protocols', 'AI narratives', 'DEX volume spikes', 'stablecoin flows'][i]} as high-confidence trade signals.',
      'yes': Random().nextInt(70) + 15,
      'no': Random().nextInt(30) + 5,
      'timeLeft': '${Random().nextInt(5) + 1}h ${Random().nextInt(59)}m',
      'userVote': null, // 'yes' or 'no'
    };
  });

  void _vote(int index, String vote) {
    setState(() {
      _proposals[index]['userVote'] = vote;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(
            'Signals DAO Voting',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _proposals.length,
            itemBuilder: (context, index) {
              final proposal = _proposals[index];
              final totalVotes = proposal['yes'] + proposal['no'];
              final yesPercent = (proposal['yes'] / totalVotes) * 100;
              final noPercent = 100 - yesPercent;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.how_to_vote, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              proposal['title'],
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            proposal['timeLeft'],
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        proposal['description'],
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: theme.colorScheme.surfaceVariant,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: yesPercent * 2,
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('👍 ${yesPercent.toStringAsFixed(1)}%'),
                          Text('👎 ${noPercent.toStringAsFixed(1)}%'),
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
                              label: const Text('Vote Yes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _vote(index, 'no'),
                              icon: const Icon(Icons.thumb_down),
                              label: const Text('Vote No'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        )
                      else
                        Center(
                          child: Text(
                            'You voted ${proposal['userVote'].toUpperCase()}',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
