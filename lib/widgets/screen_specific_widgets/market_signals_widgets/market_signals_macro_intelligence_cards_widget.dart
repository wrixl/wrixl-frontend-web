// lib/widgets/screen_specific_widgets/market_signals_widgets/market_signals_macro_intelligence_cards_widget.dart

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

/// Types of charts supported.
enum ChartType { line, bar, pie }

/// Model for a macro intelligence card.
class MacroCardData {
  final String title;
  final String snapshotMetric;
  final List<double> chartData;
  final ChartType chartType;
  final String tag;
  final Color tagColor;
  final VoidCallback onTap;
  final IconData icon;

  MacroCardData({
    required this.title,
    required this.snapshotMetric,
    required this.chartData,
    required this.chartType,
    required this.tag,
    required this.tagColor,
    required this.onTap,
    required this.icon,
  });
}

/// Widget displaying a row of macro intelligence cards with filtering.
class MarketSignalsMacroIntelligenceCardsWidget extends StatefulWidget {
  final List<MacroCardData> cards;

  const MarketSignalsMacroIntelligenceCardsWidget({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  State<MarketSignalsMacroIntelligenceCardsWidget> createState() =>
      _MarketSignalsMacroIntelligenceCardsWidgetState();
}

class _MarketSignalsMacroIntelligenceCardsWidgetState
    extends State<MarketSignalsMacroIntelligenceCardsWidget> {
  String _selectedFilter = 'All';
  final List<String> filters = ['All', 'AI Curated'];
  final Map<String, IconData> filterIcons = {
    'All': Icons.view_comfy,
    'AI Curated': Icons.auto_awesome,
  };

  void _showOptionsModal() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Macro Intelligence Options',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Additional controls or export/share options here.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    // Filter cards by tag
    final visible = _selectedFilter == 'All'
        ? widget.cards
        : widget.cards
            .where((c) => c.tag.toLowerCase().contains('ai'))
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Macro Intelligence',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: onSurface),
                onPressed: _showOptionsModal,
                tooltip: 'Options',
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Filters + summary
          Row(
            children: [
              ToggleFilterIconRowWidget(
                options: filters,
                optionIcons: filterIcons,
                activeOption: _selectedFilter,
                onSelected: (opt) => setState(() => _selectedFilter = opt),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  'AI-generated snapshot of global macro trends.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Cards
          LayoutBuilder(
            builder: (ctx, cons) => Wrap(
              spacing: 30,
              runSpacing: 16,
              children: visible.map((data) {
                return SizedBox(
                  width: min(300, cons.maxWidth / 2 - 20),
                  child: MacroCard(cardData: data),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual macro intelligence card.
class MacroCard extends StatelessWidget {
  final MacroCardData cardData;
  const MacroCard({Key? key, required this.cardData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;
    final error = theme.colorScheme.error;
    final neutral = theme.colorScheme.onSurface.withOpacity(0.6);
    final onSurface = theme.colorScheme.onSurface;

    final colors = [primary, secondary, error, neutral];

    Widget buildChart() {
      final data = cardData.chartData;
      switch (cardData.chartType) {
        case ChartType.line:
          return SizedBox(
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: colors[data.length % colors.length],
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          );
        case ChartType.bar:
          final maxY = data.reduce(max) * 1.2;
          return SizedBox(
            height: 100,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        width: 6,
                        color: colors[e.key % colors.length],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        case ChartType.pie:
          final total = data.fold(0.0, (sum, v) => sum + v);
          return SizedBox(
            height: 100,
            child: PieChart(
              PieChartData(
                sections: data.asMap().entries.map((e) {
                  final percent = (e.value / total * 100).toStringAsFixed(0);
                  return PieChartSectionData(
                    value: e.value,
                    title: '$percent%',
                    radius: 30,
                    color: colors[e.key % colors.length],
                    titleStyle: theme.textTheme.labelLarge,
                  );
                }).toList(),
                sectionsSpace: 3,
                centerSpaceRadius: 14,
                borderData: FlBorderData(show: false),
              ),
            ),
          );
      }
    }

    return InkWell(
      onTap: cardData.onTap,
      child: Card(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primary.withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(cardData.icon, color: primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cardData.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                cardData.snapshotMetric,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              buildChart(),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  cardData.tag,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: cardData.tagColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
