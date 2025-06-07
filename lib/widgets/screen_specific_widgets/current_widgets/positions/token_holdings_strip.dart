// lib\widgets\screen_specific_widgets\current_widgets\positions\token_holdings_strip.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenHoldingsStrip extends StatelessWidget {
  final List<TokenHolding>? holdings;
  final void Function(TokenHolding)? onTap;

  const TokenHoldingsStrip({
    super.key,
    this.holdings,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.compactCurrency(symbol: '\$');
    final data = holdings ?? dummyHoldings;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("💰 Token Holdings",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.pie_chart_outline),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: data.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final holding = data[index];
                  final changeColor =
                      holding.change24h >= 0 ? Colors.green : Colors.red;
                  final formattedValue = formatter.format(holding.usdValue);

                  return GestureDetector(
                    onTap: () => onTap?.call(holding),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 140,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    NetworkImage(holding.iconUrl),
                              ),
                              Text(
                                '${holding.change24h >= 0 ? '+' : ''}${holding.change24h.toStringAsFixed(1)}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: changeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            holding.symbol,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            formattedValue,
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      theme.dividerColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: (holding.portfolioPercentage / 100)
                                    .clamp(0.0, 1.0),
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${holding.portfolioPercentage.toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
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

class TokenHolding {
  final String symbol;
  final double usdValue;
  final double portfolioPercentage;
  final double change24h;
  final String iconUrl;

  const TokenHolding({
    required this.symbol,
    required this.usdValue,
    required this.portfolioPercentage,
    required this.change24h,
    required this.iconUrl,
  });
}

// Example usage for preview/testing
final List<TokenHolding> dummyHoldings = [
  TokenHolding(
    symbol: 'BTC',
    usdValue: 21250,
    portfolioPercentage: 42.5,
    change24h: 1.6,
    iconUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
  ),
  TokenHolding(
    symbol: 'ETH',
    usdValue: 13400,
    portfolioPercentage: 26.8,
    change24h: -0.9,
    iconUrl: 'https://cryptologos.cc/logos/ethereum-eth-logo.png',
  ),
  TokenHolding(
    symbol: 'LINK',
    usdValue: 2400,
    portfolioPercentage: 9.6,
    change24h: 3.2,
    iconUrl: 'https://cryptologos.cc/logos/chainlink-link-logo.png',
  ),
  TokenHolding(
    symbol: 'SOL',
    usdValue: 1600,
    portfolioPercentage: 6.2,
    change24h: 5.1,
    iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
  ),
  TokenHolding(
    symbol: 'USDC',
    usdValue: 1000,
    portfolioPercentage: 4.0,
    change24h: 0.0,
    iconUrl: 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png',
  ),
  TokenHolding(
    symbol: 'INJ',
    usdValue: 875,
    portfolioPercentage: 3.5,
    change24h: 8.4,
    iconUrl: 'https://cryptologos.cc/logos/injective-protocol-inj-logo.png',
  ),
  TokenHolding(
    symbol: 'DOGE',
    usdValue: 490,
    portfolioPercentage: 1.4,
    change24h: -2.3,
    iconUrl: 'https://cryptologos.cc/logos/dogecoin-doge-logo.png',
  ),
];
