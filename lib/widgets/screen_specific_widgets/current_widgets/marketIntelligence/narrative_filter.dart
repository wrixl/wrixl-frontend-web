// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/narrative_filter.dart

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

  String _activeCategory = "Narratives";
  final Set<String> _selectedFilters = {};

  void _toggleFilter(String tag) {
    setState(() {
      if (!_selectedFilters.add(tag)) {
        _selectedFilters.remove(tag);
      }
    });
    widget.onFilterChanged(_selectedFilters.toList());
  }

  void _clearAll() {
    setState(() => _selectedFilters.clear());
    widget.onFilterChanged([]);
  }

  void _openAllFiltersSheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("All Filters", style: theme.textTheme.titleLarge),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: _filters.entries
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildFilterGroup(e.key, e.value),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _filters.keys.toList();

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title + clear
            Row(
              children: [
                Text("🎯 Narrative Filter",
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                if (_selectedFilters.isNotEmpty)
                  TextButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear All"),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Tier 1: category chips
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = categories[i];
                  return ChoiceChip(
                    label: Text(cat),
                    selected: cat == _activeCategory,
                    onSelected: (_) =>
                        setState(() => _activeCategory = cat),
                    selectedColor:
                        theme.colorScheme.primary.withOpacity(0.2),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Tier 2: chips for active category + “All” button
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount:
                    _filters[_activeCategory]!.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  if (i == _filters[_activeCategory]!.length) {
                    return ActionChip(
                      label: const Text("+ All"),
                      onPressed: _openAllFiltersSheet,
                    );
                  }
                  final tag = _filters[_activeCategory]![i];
                  final sel = _selectedFilters.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: sel,
                    onSelected: (_) => _toggleFilter(tag),
                    selectedColor: theme.colorScheme.primary
                        .withOpacity(0.2),
                  );
                },
              ),
            ),
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
        Text(group,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((tag) {
            final sel = _selectedFilters.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: sel,
              onSelected: (_) => _toggleFilter(tag),
              selectedColor: theme.colorScheme.primary
                  .withOpacity(0.2),
            );
          }).toList(),
        ),
      ],
    );
  }
}
