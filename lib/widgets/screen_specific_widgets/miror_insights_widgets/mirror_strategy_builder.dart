// lib/widgets/screen_specific_widgets/miror_insights_widgets/mirror_strategy_builder.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class MirrorStrategyBuilder extends StatelessWidget {
  final List<String> walletStrategies;
  final List<String> holdingThemes;
  final String? selectedStrategy;
  final String? selectedTheme;
  final ValueChanged<String?> onStrategyChanged;
  final ValueChanged<String?> onThemeChanged;

  const MirrorStrategyBuilder({
    Key? key,
    required this.walletStrategies,
    required this.holdingThemes,
    required this.selectedStrategy,
    required this.selectedTheme,
    required this.onStrategyChanged,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dropdownHeight = 56.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mirror Strategy Builder",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppConstants.accentColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Wallet Strategy Dropdown
            Expanded(
              flex: 3,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Wallet Strategy",
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  suffixIcon: Tooltip(
                    message:
                        "Choose a trading style (e.g., conservative or aggressive)",
                    child: const Icon(Icons.info_outline, size: 18),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedStrategy,
                    isExpanded: true,
                    items: walletStrategies
                        .map((strategy) => DropdownMenuItem<String>(
                              value: strategy,
                              child: Text(strategy),
                            ))
                        .toList(),
                    onChanged: onStrategyChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Holding Theme Dropdown
            Expanded(
              flex: 3,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Holding Theme",
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  suffixIcon: Tooltip(
                    message: "Filter by themes like DeFi, AI, or NFTs",
                    child: const Icon(Icons.info_outline, size: 18),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedTheme,
                    isExpanded: true,
                    items: holdingThemes
                        .map((theme) => DropdownMenuItem<String>(
                              value: theme,
                              child: Text(theme),
                            ))
                        .toList(),
                    onChanged: onThemeChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Show Strategies Button
            SizedBox(
              height: dropdownHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Trigger wallet filter update
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Show Strategies"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentColor,
                  foregroundColor: Colors.black45,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
