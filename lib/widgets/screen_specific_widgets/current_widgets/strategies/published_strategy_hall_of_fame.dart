// lib\widgets\screen_specific_widgets\current_widgets\strategies\published_strategy_hall_of_fame.dart

import 'package:flutter/material.dart';

class PublishedStrategyHallOfFame extends StatelessWidget {
  const PublishedStrategyHallOfFame({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("🏆 Strategy Hall of Fame",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.emoji_events, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 12),
            _FilterBar(),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) {
                  return _StrategyCard(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatefulWidget {
  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  String selected = 'Most Minted';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: const InputDecoration(
        labelText: "Sort By",
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        'Most Minted',
        'Top Rated',
        'Longest Surviving',
        'By Theme'
      ].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
      onChanged: (value) {
        if (value != null) setState(() => selected = value);
      },
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final int index;

  const _StrategyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Strategy #$index",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text("Sharpe: 1.4 | CAGR: 18%",
                style: TextStyle(color: Colors.white70)),
            const Text("Drawdown: -12% | WRX Burn: 420",
                style: TextStyle(color: Colors.white70)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.auto_graph, color: Colors.white),
                  onPressed: () {},
                  tooltip: "Simulate",
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.white),
                  onPressed: () {},
                  tooltip: "Fork",
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: () {},
                  tooltip: "Bookmark",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
