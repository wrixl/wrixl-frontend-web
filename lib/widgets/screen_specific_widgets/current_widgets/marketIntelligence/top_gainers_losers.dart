// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\top_gainers_losers.dart

import 'package:flutter/material.dart';

class TopGainersLosersWidget extends StatefulWidget {
  const TopGainersLosersWidget({super.key});

  @override
  State<TopGainersLosersWidget> createState() => _TopGainersLosersWidgetState();
}

class _TopGainersLosersWidgetState extends State<TopGainersLosersWidget> {
  String selectedTimeframe = '24H';
  String selectedFilter = 'All Tokens';

  final List<String> timeframes = ['1H', '4H', '24H', '7D'];
  final List<String> filters = [
    'All Tokens',
    'My Holdings',
    'Tracked Narratives',
    'High Confidence Only'
  ];

  final List<Map<String, String>> topGainers = [
    {'symbol': 'JUP', 'change': '+28.2%', 'tag': '🐳 Whale Buy'},
    {'symbol': 'PYTH', 'change': '+24.1%', 'tag': '📢 Social Spike'},
    {'symbol': 'SOL', 'change': '+19.7%', 'tag': '🧠 AI Momentum'},
    {'symbol': 'LDO', 'change': '+17.4%', 'tag': '🔥 Narrative Surge'},
    {'symbol': 'TIA', 'change': '+15.0%', 'tag': '🔍 New DAO Trend'},
  ];

  final List<Map<String, String>> topLosers = [
    {'symbol': 'WIF', 'change': '-19.8%', 'tag': '🔥 Narrative Exit'},
    {'symbol': 'BONK', 'change': '-15.7%', 'tag': '🧠 AI Sentiment Collapse'},
    {'symbol': 'MATIC', 'change': '-12.4%', 'tag': '🐳 Sell-Off'},
    {'symbol': 'SUI', 'change': '-11.9%', 'tag': '📢 Social Fade'},
    {'symbol': 'MEME', 'change': '-10.1%', 'tag': '🔍 Volume Drop'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedTimeframe,
              items: timeframes.map((tf) => DropdownMenuItem(
                    value: tf,
                    child: Text(tf),
                  )).toList(),
              onChanged: (value) => setState(() => selectedTimeframe = value!),
            ),
            DropdownButton<String>(
              value: selectedFilter,
              items: filters.map((f) => DropdownMenuItem(
                    value: f,
                    child: Text(f),
                  )).toList(),
              onChanged: (value) => setState(() => selectedFilter = value!),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(context, '📈 Top Gainers', topGainers, Colors.green),
            const SizedBox(width: 16),
            _buildColumn(context, '📉 Top Losers', topLosers, Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.equalizer),
              label: const Text("Compare"),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add to Tracker"),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.show_chart),
              label: const Text("View Chart"),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildColumn(
      BuildContext context, String title, List<Map<String, String>> data, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final token in data)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color.withOpacity(0.05),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(token['symbol']![0], style: TextStyle(color: color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$${token['symbol']}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          token['tag']!,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Text(
                    token['change']!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}
