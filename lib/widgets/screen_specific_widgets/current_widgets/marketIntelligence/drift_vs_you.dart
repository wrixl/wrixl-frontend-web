// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/drift_vs_you.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class DriftVsYouWidget extends StatelessWidget {
  const DriftVsYouWidget({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> driftData = [
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

    // Compute overall drift score
    final totalDrift = driftData.fold<double>(
      0,
      (sum, item) => sum + (item['walletPct'] - item['yourPct']).abs(),
    );

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
          // Shrink‐wrap the column to its content
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // — Header Row —
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

            // — Drift Score Row —
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

            // — Drift Items (shrink-wrapped list) —
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: driftData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, i) {
                final item = driftData[i];
                final delta = item['walletPct'] - item['yourPct'];
                String status;
                Color statusColor;
                if (delta > 3) {
                  status = "Underweight";
                  statusColor = Colors.red;
                } else if (delta < -3) {
                  status = "Overweight";
                  statusColor = Colors.orange;
                } else {
                  status = "Aligned";
                  statusColor = Colors.green;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: scheme.surfaceVariant.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['token'], style: Theme.of(context).textTheme.bodyMedium),
                      Text('${item['yourPct']}%', style: Theme.of(context).textTheme.bodySmall),
                      Text('${item['walletPct']}%', style: Theme.of(context).textTheme.bodySmall),
                      Text('${delta.toStringAsFixed(1)}%',
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.w500)),
                      Chip(
                        label: Text(status),
                        backgroundColor: statusColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: statusColor, fontSize: 11),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // — CTA Buttons —
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.spaceAround,
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
            ),
          ],
        ),
      ),
    );
  }
}
