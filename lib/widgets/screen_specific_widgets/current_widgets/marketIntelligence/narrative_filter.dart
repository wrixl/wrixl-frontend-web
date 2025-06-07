// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\narrative_filter.dart

import 'package:flutter/material.dart';

class NarrativeFilterWidget extends StatefulWidget {
  final Function(List<String>) onFilterChanged;

  const NarrativeFilterWidget({super.key, required this.onFilterChanged});

  @override
  State<NarrativeFilterWidget> createState() => _NarrativeFilterWidgetState();
}

class _NarrativeFilterWidgetState extends State<NarrativeFilterWidget> {
  final Map<String, List<String>> _filters = {
    "Narratives": ["AI", "RWA", "Memecoins", "Telegram Coins"],
    "Chains": ["Ethereum", "Solana", "Base", "BNB"],
    "Sectors": ["DeFi", "NFTs", "GameFi", "Oracles", "Staking"],
    "Experimental": ["L2 Memecoins", "Telegram Pumps", "RWA Narratives"],
    "My Watchlist": ["WIF", "JUP", "TAO"],
  };

  final Set<String> _selectedFilters = {};

  void _toggleFilter(String value) {
    setState(() {
      if (_selectedFilters.contains(value)) {
        _selectedFilters.remove(value);
      } else {
        _selectedFilters.add(value);
      }
    });
    widget.onFilterChanged(_selectedFilters.toList());
  }

  void _clearAll() {
    setState(() {
      _selectedFilters.clear();
    });
    widget.onFilterChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text("🎯 Narrative Filter", style: theme.textTheme.titleMedium),
                const SizedBox(width: 8),
                Tooltip(
                  message: "Select the themes you want to track",
                  child: const Icon(Icons.info_outline, size: 18),
                ),
                const Spacer(),
                if (_selectedFilters.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear All"),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ..._filters.entries.map((entry) => _buildFilterGroup(entry.key, entry.value)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGroup(String group, List<String> items) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final selected = _selectedFilters.contains(item);
            return FilterChip(
              label: Text(item),
              selected: selected,
              onSelected: (_) => _toggleFilter(item),
              selectedColor: theme.colorScheme.primary.withOpacity(0.2),
              backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
