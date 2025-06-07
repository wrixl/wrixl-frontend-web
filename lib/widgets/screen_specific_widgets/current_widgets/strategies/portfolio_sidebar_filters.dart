// lib\widgets\screen_specific_widgets\portfolios_widgets\portfolio_sidebar_filters.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';

class PortfolioSidebarFilters extends StatelessWidget {
  final List<String> riskTolerances;
  final List<String> timeframes;
  final List<String> themes;
  final Set<String> selectedRisks;
  final Set<String> selectedTimeframes;
  final Set<String> selectedThemes;
  final ValueChanged<MapEntry<String, bool>> onRiskSelected;
  final ValueChanged<MapEntry<String, bool>> onTimeframeSelected;
  final ValueChanged<MapEntry<String, bool>> onThemeSelected;

  final double minAIConfidence;
  final double minSharpeRatio;
  final double minSmartMoneyOverlap;
  final bool hideVolatile;
  final ValueChanged<double> onMinAIConfidenceChanged;
  final ValueChanged<double> onMinSharpeRatioChanged;
  final ValueChanged<double> onMinSmartMoneyOverlapChanged;
  final ValueChanged<bool> onHideVolatileChanged;

  final bool showModelPortfolios;
  final ValueChanged<int> onToggle;

  const PortfolioSidebarFilters({
    Key? key,
    required this.riskTolerances,
    required this.timeframes,
    required this.themes,
    required this.selectedRisks,
    required this.selectedTimeframes,
    required this.selectedThemes,
    required this.onRiskSelected,
    required this.onTimeframeSelected,
    required this.onThemeSelected,
    required this.minAIConfidence,
    required this.minSharpeRatio,
    required this.minSmartMoneyOverlap,
    required this.hideVolatile,
    required this.onMinAIConfidenceChanged,
    required this.onMinSharpeRatioChanged,
    required this.onMinSmartMoneyOverlapChanged,
    required this.onHideVolatileChanged,
    required this.showModelPortfolios,
    required this.onToggle,
  }) : super(key: key);

  void _showResetModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reset Filters", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text("Reset all filters back to their default values?"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Reset")),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Portfolio Filters", style: Theme.of(context).textTheme.titleMedium),
                IconButton(icon: const Icon(Icons.refresh), onPressed: () => _showResetModal(context)),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ToggleButtons(
                constraints: const BoxConstraints.tightFor(width: 60, height: 30),
                isSelected: [showModelPortfolios, !showModelPortfolios],
                onPressed: onToggle,
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Text("Model", style: TextStyle(fontSize: 12)),
                  Text("Personal", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterColumn(context, label: "Risk", values: riskTolerances, selectedValues: selectedRisks, onSelected: onRiskSelected),
                  const SizedBox(width: 32),
                  _buildFilterColumn(context, label: "Timeframe", values: timeframes, selectedValues: selectedTimeframes, onSelected: onTimeframeSelected),
                  const SizedBox(width: 32),
                  _buildFilterColumn(context, label: "Themes", values: themes, selectedValues: selectedThemes, onSelected: onThemeSelected),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            _buildAdvancedFilters(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterColumn(BuildContext context, {
    required String label,
    required List<String> values,
    required Set<String> selectedValues,
    required ValueChanged<MapEntry<String, bool>> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: values.map((value) {
            final selected = selectedValues.contains(value);
            return FilterChip(
              label: Text(value),
              selected: selected,
              onSelected: (val) => onSelected(MapEntry(value, val)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedIconColor: AppConstants.accentColor,
      iconColor: AppConstants.neonGreen,
      title: Text("Advanced Filters", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppConstants.neonGreen, fontWeight: FontWeight.bold)),
      children: [
        const SizedBox(height: 16),
        _buildSlider(context, label: "Min AI Confidence", value: minAIConfidence, min: 60, max: 100, divisions: 8, onChanged: onMinAIConfidenceChanged, unit: "%"),
        _buildSlider(context, label: "Min Sharpe Ratio", value: minSharpeRatio, min: 0, max: 3, divisions: 30, onChanged: onMinSharpeRatioChanged),
        _buildSlider(context, label: "Smart Money Overlap", value: minSmartMoneyOverlap, min: 0, max: 100, divisions: 10, onChanged: onMinSmartMoneyOverlapChanged, unit: "%"),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(value: hideVolatile, onChanged: (val) => onHideVolatileChanged(val ?? false), activeColor: AppConstants.neonRed),
            const SizedBox(width: 8),
            Flexible(child: Text("Hide high-volatility portfolios", style: Theme.of(context).textTheme.bodyMedium)),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSlider(BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    String unit = "",
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label (${value.toStringAsFixed(unit == "%" ? 0 : 2)}$unit)", style: Theme.of(context).textTheme.bodyMedium),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: "${value.toStringAsFixed(unit == "%" ? 0 : 2)}$unit",
          onChanged: onChanged,
          activeColor: AppConstants.neonGreen,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
