// lib\widgets\screen_specific_widgets\current_widgets\strategies\token_intelligence_filters.dart

// Fully modernized TokenIntelligenceFilters widget with consistent styling, padding, and card layout

import 'package:flutter/material.dart';

class TokenIntelligenceFilters extends StatefulWidget {
  const TokenIntelligenceFilters({super.key});

  @override
  State<TokenIntelligenceFilters> createState() => _TokenIntelligenceFiltersState();
}

class _TokenIntelligenceFiltersState extends State<TokenIntelligenceFilters> {
  final Map<String, bool> selectedFilters = {
    'Top Momentum': false,
    'Low Volatility': false,
    'Smart Money Heavy': false,
    'New Narratives': false,
    'AI': false,
    'DeFi': false,
    'L2': false,
    'Memecoins': false,
  };

  final Map<String, List<String>> tokenExamples = {
    'Top Momentum': ['ARB', 'INJ', 'PYTH'],
    'Low Volatility': ['DAI', 'USDC', 'WBTC'],
    'Smart Money Heavy': ['SNX', 'GMX', 'AAVE'],
    'New Narratives': ['FET', 'TIA', 'WIF'],
    'AI': ['FET', 'RNDR', 'AGIX'],
    'DeFi': ['UNI', 'AAVE', 'DYDX'],
    'L2': ['ARB', 'OP', 'ZKSYNC'],
    'Memecoins': ['DOGE', 'WIF', 'PEPE'],
  };

  void _toggleFilter(String filter) {
    setState(() {
      selectedFilters[filter] = !(selectedFilters[filter] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
      elevation: 3,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Token Intelligence Filters",
                    style: theme.textTheme.titleMedium),
                const Icon(Icons.filter_alt_outlined, color: Colors.teal),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedFilters.entries.map((entry) {
                final filter = entry.key;
                final selected = entry.value;
                final exampleTokens = tokenExamples[filter] ?? [];

                return Tooltip(
                  message: "$filter\nTokens: ${exampleTokens.join(', ')}",
                  child: FilterChip(
                    label: Text(filter),
                    selected: selected,
                    onSelected: (_) => _toggleFilter(filter),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Apply Filters to Build Engine"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Filters applied to strategy engine"),
                      duration: Duration(seconds: 2),
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
