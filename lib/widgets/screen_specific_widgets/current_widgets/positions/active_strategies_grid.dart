// lib\widgets\screen_specific_widgets\current_widgets\positions\active_strategies_grid.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActiveStrategiesGrid extends StatelessWidget {
  final List<StrategyPosition> strategies;
  final void Function(StrategyPosition)? onTap;

  const ActiveStrategiesGrid({
    super.key,
    required this.strategies,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final formatter = NumberFormat.compactCurrency(symbol: '\$');

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isMobile ? 1.8 : 1.6,
      ),
      itemCount: strategies.length,
      itemBuilder: (context, index) {
        final strategy = strategies[index];
        final changeColor = strategy.change >= 0 ? Colors.green : Colors.red;
        final tileColor = strategy.change >= 5
            ? Colors.green.withOpacity(0.05)
            : strategy.change <= -5
                ? Colors.red.withOpacity(0.05)
                : theme.colorScheme.surface;

        return GestureDetector(
          onTap: () => onTap?.call(strategy),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strategy.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatter.format(strategy.capital)}  •  ${strategy.percentOfPortfolio.toStringAsFixed(1)}%',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${strategy.change >= 0 ? '+' : ''}${strategy.change.toStringAsFixed(2)}%',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: changeColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      strategy.lastAction,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: strategy.tokenIcons.take(3).map((iconUrl) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(iconUrl),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StrategyPosition {
  final String name;
  final double capital;
  final double percentOfPortfolio;
  final double change;
  final String lastAction;
  final List<String> tokenIcons;

  const StrategyPosition({
    required this.name,
    required this.capital,
    required this.percentOfPortfolio,
    required this.change,
    required this.lastAction,
    required this.tokenIcons,
  });
}

final List<StrategyPosition> dummyStrategies = [
  StrategyPosition(
    name: 'AI Momentum v2',
    capital: 8420,
    percentOfPortfolio: 28.3,
    change: 6.2,
    lastAction: 'Rebalanced 2d ago',
    tokenIcons: [
      'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
      'https://cryptologos.cc/logos/ethereum-eth-logo.png',
      'https://cryptologos.cc/logos/solana-sol-logo.png',
    ],
  ),
  StrategyPosition(
    name: 'Stable Yield Basket',
    capital: 4900,
    percentOfPortfolio: 16.8,
    change: 1.3,
    lastAction: 'Created 5d ago',
    tokenIcons: [
      'https://cryptologos.cc/logos/usd-coin-usdc-logo.png',
      'https://cryptologos.cc/logos/dai-dai-logo.png',
      'https://cryptologos.cc/logos/tether-usdt-logo.png',
    ],
  ),
  StrategyPosition(
    name: 'Narrative Momentum',
    capital: 3200,
    percentOfPortfolio: 12.5,
    change: -2.1,
    lastAction: 'Simulated 1d ago',
    tokenIcons: [
      'https://cryptologos.cc/logos/chainlink-link-logo.png',
      'https://cryptologos.cc/logos/injective-protocol-inj-logo.png',
      'https://cryptologos.cc/logos/arbitrum-arb-logo.png',
    ],
  ),
  StrategyPosition(
    name: 'Whale Mirror 3',
    capital: 2300,
    percentOfPortfolio: 8.7,
    change: 10.5,
    lastAction: 'New 12h ago',
    tokenIcons: [
      'https://cryptologos.cc/logos/optimism-ethereum-op-logo.png',
      'https://cryptologos.cc/logos/rocket-pool-eth-rpl-logo.png',
      'https://cryptologos.cc/logos/chainlink-link-logo.png',
    ],
  ),
];
