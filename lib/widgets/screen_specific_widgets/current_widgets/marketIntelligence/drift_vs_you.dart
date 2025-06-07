// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\drift_vs_you.dart

import 'package:flutter/material.dart';

class DriftVsYouWidget extends StatelessWidget {
  const DriftVsYouWidget({super.key});

  final List<Map<String, dynamic>> driftData = const [
    {
      'token': 'PYTH',
      'yourPct': 2.1,
      'walletPct': 8.7,
      'sector': 'LRT',
    },
    {
      'token': 'ETH',
      'yourPct': 14.0,
      'walletPct': 6.2,
      'sector': 'L1',
    },
    {
      'token': 'JUP',
      'yourPct': 3.3,
      'walletPct': 5.1,
      'sector': 'DEX',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    double totalDrift = driftData.fold(0, (sum, item) {
      return sum + (item['walletPct'] - item['yourPct']).abs();
    });

    String driftStatus;
    Color driftColor;
    if (totalDrift < 10) {
      driftStatus = "Aligned";
      driftColor = Colors.green;
    } else if (totalDrift < 25) {
      driftStatus = "Minor Drift";
      driftColor = Colors.orange;
    } else {
      driftStatus = "Major Drift";
      driftColor = Colors.red;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Drift vs You', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('What is Drift?'),
                        content: Text(
                          'This widget compares your portfolio allocation with a selected smart wallet.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Drift Score
            Row(
              children: [
                const Text('Drift Score: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Chip(
                  label: Text(driftStatus),
                  backgroundColor: driftColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: driftColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Drift Table
            ...driftData.map((item) {
              double delta = item['walletPct'] - item['yourPct'];
              String status = delta > 3
                  ? "Underweight"
                  : delta < -3
                      ? "Overweight"
                      : "Aligned";
              Color statusColor = delta > 3
                  ? Colors.red
                  : delta < -3
                      ? Colors.orange
                      : Colors.green;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: scheme.surfaceVariant.withOpacity(0.05),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['token'],
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text('${item['yourPct']}%',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text('${item['walletPct']}%',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text('${delta.toStringAsFixed(1)}%',
                        style: TextStyle(
                            color: statusColor, fontWeight: FontWeight.w500)),
                    Chip(
                      label: Text(status),
                      backgroundColor: statusColor.withOpacity(0.1),
                      labelStyle: TextStyle(color: statusColor, fontSize: 11),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    )
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // CTA Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('Simulate Drift'),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.track_changes),
                  label: const Text('Mirror Allocation'),
                  onPressed: () {},
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: const Text('Set Alert'),
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
