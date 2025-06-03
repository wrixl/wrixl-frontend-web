// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\todays_intelligence_summary.dart

import 'package:flutter/material.dart';

class TodaysIntelligenceSummary extends StatefulWidget {
  const TodaysIntelligenceSummary({super.key});

  @override
  State<TodaysIntelligenceSummary> createState() => _TodaysIntelligenceSummaryState();
}

class _TodaysIntelligenceSummaryState extends State<TodaysIntelligenceSummary> {
  String _selectedTimeframe = 'Today';
  bool _showExplanation = false;

  final Map<String, List<Map<String, String>>> _summaryData = {
    'Today': [
      {
        'icon': '📈',
        'text': 'AI dominance continues — mentions up 83%, VC wallets accumulating \$FET.',
        'explanation': 'Narrative velocity up across Twitter and Telegram. Top tokens: \$FET, \$AGIX.'
      },
      {
        'icon': '🧊',
        'text': 'Stablecoin inflow of \$512M hints at upcoming altcoin deployment.',
        'explanation': 'Major exchanges saw large USDC + USDT deposits in past 6h.'
      },
      {
        'icon': '🐋',
        'text': 'Whale cluster rotated into Solana memes and Layer 2 infra.',
        'explanation': 'Wallet tags show \$WIF and \$TURBO buys, plus Arbitrum ecosystem entries.'
      },
      {
        'icon': '⚠️',
        'text': '\$JUP flagged in Smart Signals after on-chain buys surged 4x.',
        'explanation': 'Triggered by repeat wallet activity + social anomaly detection.'
      },
      {
        'icon': '🌐',
        'text': 'Macro: Markets cautious post-ETF delay; ETH/BTC ratio stalls.',
        'explanation': 'Derivatives open interest down 5%; TradFi sentiment cooling.'
      },
    ],
    // Placeholder example for other timeframes
    'Last 24h': [],
    'This Week': [],
  };

  void _toggleTimeframe(String timeframe) {
    setState(() => _selectedTimeframe = timeframe);
  }

  void _toggleExplanation() {
    setState(() => _showExplanation = !_showExplanation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insights = _summaryData[_selectedTimeframe] ?? [];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.today, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Today’s Intelligence Summary",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message:
                      'Auto-generated daily snapshot from narratives, signals, smart wallets & macro cues.',
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  constraints: const BoxConstraints(minWidth: 64, minHeight: 32),
                  isSelected: ['Today', 'Last 24h', 'This Week']
                      .map((e) => _selectedTimeframe == e)
                      .toList(),
                  onPressed: (index) => _toggleTimeframe(['Today', 'Last 24h', 'This Week'][index]),
                  children: const [Text('Today'), Text('24h'), Text('Week')],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...insights.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['icon'] ?? '', style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['text'] ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      if (_showExplanation && item['explanation'] != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 32, top: 4),
                          child: Text(
                            item['explanation']!,
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                        ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Source: Wrixl AI, Wallet Intel, Social APIs",
                  style: theme.textTheme.bodySmall,
                ),
                TextButton.icon(
                  onPressed: _toggleExplanation,
                  icon: Icon(_showExplanation ? Icons.visibility_off : Icons.visibility, size: 16),
                  label: Text(_showExplanation ? "Hide Details" : "Explain This"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
