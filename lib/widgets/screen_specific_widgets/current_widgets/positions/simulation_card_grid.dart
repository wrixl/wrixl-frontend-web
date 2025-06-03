// lib\widgets\screen_specific_widgets\current_widgets\positions\simulation_card_grid.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimulationCardGrid extends StatelessWidget {
  final List<SimulationStrategy> strategies;

  const SimulationCardGrid({super.key, required this.strategies});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: strategies.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final sim = strategies[index];
        final perfColor =
            sim.performance >= 0 ? Colors.greenAccent : Colors.redAccent;

        return GestureDetector(
          onTap: () {}, // future modal or simulation drill-down
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: sim.status == 'Active'
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: 1.2,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      sim.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: sim.status == 'Active'
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : theme.dividerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sim.status,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: sim.status == 'Active'
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${sim.performance >= 0 ? '+' : ''}${sim.performance.toStringAsFixed(1)}%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: perfColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      sim.startDate,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Confidence: ${sim.confidence}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  children: sim.tokens
                      .map((token) => CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(token.iconUrl),
                            backgroundColor: Colors.transparent,
                          ))
                      .toList(),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    sim.tag,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SimulationStrategy {
  final String title;
  final String status;
  final String startDate;
  final double performance;
  final String confidence;
  final List<SimToken> tokens;
  final String tag;

  const SimulationStrategy({
    required this.title,
    required this.status,
    required this.startDate,
    required this.performance,
    required this.confidence,
    required this.tokens,
    required this.tag,
  });
}

class SimToken {
  final String symbol;
  final String iconUrl;

  const SimToken({required this.symbol, required this.iconUrl});
}

// Dummy Data
final List<SimulationStrategy> dummySimulations = [
  SimulationStrategy(
    title: 'Strategy A',
    status: 'Active',
    startDate: 'May 12',
    performance: 29.8,
    confidence: 'Medium',
    tokens: [
      SimToken(
          symbol: 'SOL',
          iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png'),
      SimToken(
          symbol: 'LINK',
          iconUrl: 'https://cryptologos.cc/logos/chainlink-link-logo.png'),
      SimToken(
          symbol: 'INJ',
          iconUrl:
              'https://cryptologos.cc/logos/injective-protocol-inj-logo.png'),
    ],
    tag: 'Outperforming',
  ),
  SimulationStrategy(
    title: 'Strategy B',
    status: 'Expired',
    startDate: 'Apr 28',
    performance: -6.5,
    confidence: 'Low',
    tokens: [
      SimToken(
          symbol: 'UNI',
          iconUrl: 'https://cryptologos.cc/logos/uniswap-uni-logo.png'),
      SimToken(
          symbol: 'LINK',
          iconUrl: 'https://cryptologos.cc/logos/chainlink-link-logo.png'),
    ],
    tag: 'Underperforming',
  ),
  SimulationStrategy(
    title: 'Strategy C',
    status: 'Archived',
    startDate: 'May 03',
    performance: 27.7,
    confidence: 'High',
    tokens: [
      SimToken(
          symbol: 'UNI',
          iconUrl: 'https://cryptologos.cc/logos/uniswap-uni-logo.png'),
      SimToken(
          symbol: 'ETH',
          iconUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png'),
      SimToken(
          symbol: 'SOL',
          iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png'),
    ],
    tag: 'Outperforming',
  ),
];
