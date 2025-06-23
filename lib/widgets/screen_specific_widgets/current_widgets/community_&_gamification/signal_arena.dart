// lib/widgets/screen_specific_widgets/current_widgets/community_&_gamification/signal_arena.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class SignalArenaWidget extends StatefulWidget {
  const SignalArenaWidget({Key? key}) : super(key: key);

  @override
  State<SignalArenaWidget> createState() => _SignalArenaWidgetState();
}

class _SignalPrediction {
  final String title;
  final String category;
  final Duration timeRemaining;
  final double yesOdds;
  final double noOdds;
  final double userStake;
  final double payoutMultiplier;

  _SignalPrediction({
    required this.title,
    required this.category,
    required this.timeRemaining,
    required this.yesOdds,
    required this.noOdds,
    required this.userStake,
    required this.payoutMultiplier,
  });
}

class _SignalArenaWidgetState extends State<SignalArenaWidget> {
  final List<_SignalPrediction> _predictions = [
    _SignalPrediction(
      title: 'L2 Surge Incoming',
      category: 'Layer-2s',
      timeRemaining: const Duration(hours: 3, minutes: 12),
      yesOdds: 0.64,
      noOdds: 0.36,
      userStake: 20,
      payoutMultiplier: 2.3,
    ),
    _SignalPrediction(
      title: 'AI L1 Edge',
      category: 'AI Chains',
      timeRemaining: const Duration(hours: 6, minutes: 45),
      yesOdds: 0.55,
      noOdds: 0.45,
      userStake: 0,
      payoutMultiplier: 1.9,
    ),
  ];

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  void _showPredictionModal(_SignalPrediction signal) {
    showNewReusableModal(
      context,
      title: signal.title,
      size: WidgetModalSize.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(signal.title,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Category: ${signal.category}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Time remaining: ${_formatDuration(signal.timeRemaining)}',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text('Current Odds:',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text('YES: ${(signal.yesOdds * 100).toStringAsFixed(0)}%'),
              ),
              Chip(
                label: Text('NO: ${(signal.noOdds * 100).toStringAsFixed(0)}%'),
              ),
            ],
          ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Est. Payout: ${(signal.payoutMultiplier * signal.userStake).toStringAsFixed(2)} WRX',
                style:
                    const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirm Bet'),
              ),
            ],
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
        return IntrinsicHeight(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 3,
            color: theme.colorScheme.surface,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Signal Arena',
                          style: theme.textTheme.titleMedium),
                      const Spacer(),
                      const Icon(Icons.auto_graph_rounded,
                          color: Colors.deepPurpleAccent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _predictions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final signal = _predictions[index];
                        return GestureDetector(
                          onTap: () => _showPredictionModal(signal),
                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(maxWidth: 300),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                              elevation: 2,
                              color: theme.cardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(signal.title,
                                              style: theme
                                                  .textTheme
                                                  .titleSmall,
                                              overflow: TextOverflow
                                                  .ellipsis),
                                        ),
                                        Text(
                                            '⏱ ${_formatDuration(signal.timeRemaining)}',
                                            style: TextStyle(
                                                color: theme
                                                    .colorScheme
                                                    .secondary)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text('📈 ${signal.category}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: theme.colorScheme
                                                .onSurface
                                                .withOpacity(0.7))),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              LinearProgressIndicator(
                                            value: signal.yesOdds,
                                            backgroundColor:
                                                Colors.red.shade100,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.blue),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                            '${(signal.yesOdds * 100).toStringAsFixed(0)}% YES'),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                      children: [
                                        Text(
                                            '💰 Stake: ${signal.userStake} WRX',
                                            style: const TextStyle(
                                                fontSize: 13)),
                                        Text(
                                            '🏆 ${signal.payoutMultiplier}× Payout',
                                            style: const TextStyle(
                                                fontSize: 13)),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _showPredictionModal(
                                                  signal),
                                          child:
                                              const Text('↗ Place Bet'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _showPredictionModal(
                                                  signal),
                                          child: const Text(
                                              '📜 View Signal Detail'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
}
