// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\drift_vs_you.dart


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DriftVsYouWidget extends StatefulWidget {
  const DriftVsYouWidget({super.key});

  @override
  State<DriftVsYouWidget> createState() => _DriftVsYouWidgetState();
}

class _DriftVsYouWidgetState extends State<DriftVsYouWidget> {
  final List<Map<String, dynamic>> driftData = [
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDriftScore(),
            const SizedBox(height: 16),
            _buildDriftTable(),
            const SizedBox(height: 24),
            _buildCTAButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Drift vs You',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('What is Drift?'),
                content: Text(
                    'This widget compares your portfolio allocation with a selected smart wallet.'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDriftScore() {
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

    return Row(
      children: [
        Text(
          'Drift Score: ',
          style: TextStyle(fontSize: 16),
        ),
        Chip(
          label: Text(driftStatus),
          backgroundColor: driftColor.withOpacity(0.1),
          labelStyle: TextStyle(color: driftColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDriftTable() {
    return Column(
      children: driftData.map((item) {
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100.withOpacity(0.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['token'], style: const TextStyle(fontSize: 16)),
              Text('${item['yourPct']}%'),
              Text('${item['walletPct']}%'),
              Text(
                '${delta.toStringAsFixed(1)}%',
                style: TextStyle(color: statusColor),
              ),
              Chip(
                label: Text(status),
                backgroundColor: statusColor.withOpacity(0.1),
                labelStyle: TextStyle(color: statusColor),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}
