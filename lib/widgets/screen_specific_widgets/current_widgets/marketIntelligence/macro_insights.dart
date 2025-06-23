// lib/widgets/screen_specific_widgets/current_widgets/marketIntelligence/macro_insights.dart

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

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
  final IconData icon;

  MacroCardData({
    required this.title,
    required this.snapshotMetric,
    required this.chartData,
    required this.chartType,
    required this.tag,
    required this.tagColor,
    required this.icon,
  });
}

/// Widget displaying a row of macro intelligence cards with filtering.
class MarketSignalsMacroIntelligenceCardsWidget extends StatefulWidget {
  const MarketSignalsMacroIntelligenceCardsWidget({Key? key}) : super(key: key);

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

  List<MacroCardData> get _dummyCards {
    final scheme = Theme.of(context).colorScheme;
    return [
      MacroCardData(
        title: "Crypto vs Traditional",
        snapshotMetric: "BTC +4.1% vs S&P −0.3%",
        chartData: [0.9, 1.1, 1.0, 1.2, 1.1, 1.3, 1.4],
        chartType: ChartType.line,
        tag: "Risk-On",
        tagColor: scheme.primary,
        icon: Icons.show_chart,
      ),
      MacroCardData(
        title: "Volatility Index",
        snapshotMetric: "VIX: 25 (7d up)",
        chartData: [22, 23, 24, 25, 26, 25, 27],
        chartType: ChartType.bar,
        tag: "Volatile",
        tagColor: scheme.error,
        icon: Icons.trending_up,
      ),
      MacroCardData(
        title: "Stablecoin Flows",
        snapshotMetric: "Net minting +3M",
        chartData: [100, 103, 105, 102, 108, 110, 115],
        chartType: ChartType.pie,
        tag: "Liquidity",
        tagColor: scheme.secondary,
        icon: Icons.water_drop,
      ),
      MacroCardData(
        title: "Global Money Supply",
        snapshotMetric: "M2 +1.8% QoQ",
        chartData: [92, 93, 94, 96, 97, 98, 99],
        chartType: ChartType.line,
        tag: "Expansion",
        tagColor: scheme.primary,
        icon: Icons.public,
      ),
    ];
  }

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
    final scheme = Theme.of(context).colorScheme;
    final visibleCards = _selectedFilter == 'All'
        ? _dummyCards
        : _dummyCards.where((c) => c.tag.toLowerCase().contains('ai')).toList();
    const spacing = 24.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          color: scheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // — header row —
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Macro Intelligence',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: _showOptionsModal,
                      tooltip: 'Options',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // — filter row —
                Row(
                  children: [
                    ToggleFilterIconRowWidget(
                      options: filters,
                      optionIcons: filterIcons,
                      activeOption: _selectedFilter,
                      onSelected: (opt) =>
                          setState(() => _selectedFilter = opt),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        'AI-generated snapshot of global macro trends.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: scheme.onSurface.withOpacity(0.7),
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // — horizontal scroller fills remaining space —
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, inner) {
                      final count = visibleCards.length;
                      final totalSpacing = spacing * (count - 1);
                      final cardWidth = ((inner.maxWidth - totalSpacing) /
                              count)
                          .clamp(200.0, 300.0);

                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: spacing),
                        itemCount: count,
                        itemBuilder: (_, i) {
                          return SizedBox(
                            width: cardWidth,
                            child: MacroCard(cardData: visibleCards[i]),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The individual card widget — now taps open a detail modal.
class MacroCard extends StatelessWidget {
  final MacroCardData cardData;
  const MacroCard({Key? key, required this.cardData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = [
      scheme.primary,
      scheme.secondary,
      scheme.error,
      scheme.onSurface.withOpacity(0.6),
    ];

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
      onTap: () {
        showNewReusableModal(
          context,
          title: cardData.title,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(cardData.snapshotMetric,
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(height: 150, child: buildChart()),
                const SizedBox(height: 12),
                Text("Tag: ${cardData.tag}",
                    style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                const Text(
                  "Here you can add any further details, commentary, or actions for this macro card.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          size: WidgetModalSize.medium,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cardData.tagColor.withOpacity(0.4)),
        ),
        color: scheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title + icon
              Row(
                children: [
                  Icon(cardData.icon, color: cardData.tagColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(cardData.title,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.primary,
                            )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // snapshot metric
              Text(cardData.snapshotMetric,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // chart
              buildChart(),
              const SizedBox(height: 8),
              // tag chip
              Chip(
                label: Text(cardData.tag,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: scheme.onPrimary)),
                backgroundColor: cardData.tagColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
