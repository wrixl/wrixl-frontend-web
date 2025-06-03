// lib\widgets\screen_specific_widgets\current_widgets\token_allocation_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class TokenAllocationWidget extends StatefulWidget {
  const TokenAllocationWidget({super.key});

  @override
  State<TokenAllocationWidget> createState() => _TokenAllocationWidgetState();
}

class _TokenAllocationWidgetState extends State<TokenAllocationWidget> {
  String _activeFilter = 'By Category';

  final List<String> filterOptions = [
    'By Category',
    'By Network',
    'By Risk Tier'
  ];

  final List<_TokenSlice> tokenSlices = [
    _TokenSlice(symbol: 'ETH', name: 'Ethereum', percent: 38, value: 32000),
    _TokenSlice(symbol: 'USDC', name: 'USD Coin', percent: 25, value: 21000),
    _TokenSlice(symbol: 'ARB', name: 'Arbitrum', percent: 15, value: 12500),
    _TokenSlice(symbol: 'PEPE', name: 'Pepe Coin', percent: 12, value: 10000),
    _TokenSlice(symbol: 'RLB', name: 'Rollbit', percent: 10, value: 8500),
  ];

  void _showTokenModal(_TokenSlice token) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        title: Text("${token.name} (${token.symbol})"),
        content: Text(
            "You hold ${token.percent}% of your portfolio in ${token.symbol}, worth \$${token.value.toStringAsFixed(0)}."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Token Allocation",
                    style: Theme.of(context).textTheme.titleMedium),
                ToggleFilterIconRowWidget(
                  options: filterOptions,
                  optionIcons: {
                    'By Category': Icons.category,
                    'By Network': Icons.cloud,
                    'By Risk Tier': Icons.shield,
                  },
                  activeOption: _activeFilter,
                  onSelected: (val) => setState(() => _activeFilter = val),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Chart
            SizedBox(
              height: 160,
              child: PieChart(
                PieChartData(
                  sections: tokenSlices.map((t) {
                    final color = Colors
                        .primaries[t.symbol.hashCode % Colors.primaries.length];
                    return PieChartSectionData(
                      value: t.percent.toDouble(),
                      title: "${t.percent}%",
                      color: color.withOpacity(0.8),
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    );
                  }).toList(),
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Legend
            Column(
              children: tokenSlices.map((t) {
                final color = Colors
                    .primaries[t.symbol.hashCode % Colors.primaries.length];
                return GestureDetector(
                  onTap: () => _showTokenModal(t),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        CircleAvatar(
                            backgroundColor: color.withOpacity(0.8), radius: 6),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text("${t.symbol} — ${t.name}",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        Text("${t.percent}%",
                            style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Text("\$${t.value.toStringAsFixed(0)}",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _TokenSlice {
  final String symbol;
  final String name;
  final int percent;
  final double value;

  _TokenSlice({
    required this.symbol,
    required this.name,
    required this.percent,
    required this.value,
  });
}
