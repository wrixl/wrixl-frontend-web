// lib\widgets\screen_specific_widgets\current_widgets\strategies\published_strategy_hall_of_fame.dart


import 'package:flutter/material.dart';

class PublishedStrategyHallOfFame extends StatelessWidget {
  const PublishedStrategyHallOfFame({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "🏆 Published Strategy Hall of Fame",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _FilterBar(),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return _StrategyCard(index: index);
            },
          ),
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: selected,
        items: ['Most Minted', 'Top Rated', 'Longest Surviving', 'By Theme']
            .map((label) => DropdownMenuItem(child: Text(label), value: label))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => selected = value);
          }
        },
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  final int index;

  const _StrategyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Strategy #$index",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text("Sharpe: 1.4 | CAGR: 18%", style: TextStyle(color: Colors.white70)),
            const Text("Drawdown: -12% | WRX Burn: 420", style: TextStyle(color: Colors.white70)),
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
