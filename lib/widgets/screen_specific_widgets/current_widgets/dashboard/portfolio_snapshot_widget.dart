// lib\widgets\screen_specific_widgets\current_widgets\portfolio_snapshot_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class PortfolioSnapshotWidget extends StatefulWidget {
  const PortfolioSnapshotWidget({super.key});

  @override
  State<PortfolioSnapshotWidget> createState() =>
      _PortfolioSnapshotWidgetState();
}

class _PortfolioSnapshotWidgetState extends State<PortfolioSnapshotWidget> {
  final List<String> ranges = ['1d', '7d', '1m', '1y'];
  final List<String> views = ['tokens', 'sectors', 'risk'];
  int rangeIndex = 1;
  int viewIndex = 0;
  int touchedIndex = -1;
  bool showUsd = true;

  String get selectedRange => ranges[rangeIndex];
  String get selectedView => views[viewIndex];

  void cycleRange() =>
      setState(() => rangeIndex = (rangeIndex + 1) % ranges.length);
  void cycleView() =>
      setState(() => viewIndex = (viewIndex + 1) % views.length);

  double getCurrentValue(String key, double percent) => percent / 100 * 128342;

  final Map<String, Map<String, Map<String, double>>> allocations = {
    'tokens': {
      '1d': {'BTC': 42, 'ETH': 24, 'DeFi': 18, 'NFTs': 11, 'Others': 5},
      '7d': {'BTC': 40, 'ETH': 25, 'DeFi': 20, 'NFTs': 10, 'Others': 5},
      '1m': {'BTC': 38, 'ETH': 27, 'DeFi': 22, 'NFTs': 8, 'Others': 5},
      '1y': {'BTC': 35, 'ETH': 30, 'DeFi': 25, 'NFTs': 5, 'Others': 5},
    },
    'sectors': {
      '1d': {
        'Layer1': 40,
        'Layer2': 20,
        'DEX': 15,
        'NFTs': 15,
        'Stablecoins': 10
      },
      '7d': {
        'Layer1': 38,
        'Layer2': 22,
        'DEX': 18,
        'NFTs': 12,
        'Stablecoins': 10
      },
      '1m': {
        'Layer1': 35,
        'Layer2': 25,
        'DEX': 20,
        'NFTs': 10,
        'Stablecoins': 10
      },
      '1y': {
        'Layer1': 33,
        'Layer2': 27,
        'DEX': 22,
        'NFTs': 8,
        'Stablecoins': 10
      },
    },
    'risk': {
      '1d': {'High Risk': 30, 'Med Risk': 40, 'Low Risk': 30},
      '7d': {'High Risk': 28, 'Med Risk': 42, 'Low Risk': 30},
      '1m': {'High Risk': 25, 'Med Risk': 45, 'Low Risk': 30},
      '1y': {'High Risk': 20, 'Med Risk': 50, 'Low Risk': 30},
    }
  };

  final Map<String, Map<String, List<double>>> trends = {
    'BTC': {
      '1d': [50200, 50400, 51600, 50800, 59000],
      '7d': [37000, 47500, 42000, 49000, 41500, 51000],
      '1m': [43000, 43500, 44000, 44500, 45000],
      '1y': [30000, 31000, 32000, 33000, 34000],
    },
    'ETH': {
      '1d': [2980, 3000, 3025, 3040, 2050],
      '7d': [2900, 2950, 2975, 3000, 3020, 3050],
      '1m': [2700, 2750, 2800, 2850, 2900],
      '1y': [1900, 1800, 1900, 2000, 2100],
    },
    'DeFi': {
      '1d': [980, 1000, 1020, 1040, 1050],
      '7d': [920, 960, 990, 1000, 910, 1050],
      '1m': [850, 875, 600, 825, 950],
      '1y': [590, 525, 450, 575, 600],
    },
    'NFTs': {
      '1d': [395, 400, 445, 410, 420],
      '7d': [380, 390, 400, 180, 410, 420],
      '1m': [330, 335, 340, 345, 350],
      '1y': [250, 260, 70, 280, 290],
    },
    'Others': {
      '1d': [198, 202, 205, 170, 210],
      '7d': [180, 190, 300, 200, 202, 210],
      '1m': [150, 155, 260, 165, 170],
      '1y': [100, 310, 120, 230, 140],
    },
  };

  void _openDetailsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: "Detailed Portfolio Breakdown",
        size: WidgetModalSize.medium,
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("View: $selectedView"),
            const SizedBox(height: 8),
            Text("Duration: $selectedRange"),
            const SizedBox(height: 16),
            ...allocations[selectedView]![selectedRange]!.entries.map((e) {
              final value = getCurrentValue(e.key, e.value);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "${e.key}: ${e.value.toStringAsFixed(1)}%  →  "
                  "${showUsd ? "\$${value.toStringAsFixed(2)}" : "Ξ${(value / 4700).toStringAsFixed(2)}"}",
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final allocation = allocations[selectedView]![selectedRange]!;
    final pieData = allocation.entries.toList();
    final List<Color> pieColors =
        Colors.primaries.take(pieData.length).toList();

    final selectedKey = touchedIndex >= 0 && touchedIndex < pieData.length
        ? pieData[touchedIndex].key
        : null;
    final double displayValue = selectedKey != null
        ? getCurrentValue(selectedKey, allocation[selectedKey]!)
        : 128342;
    final List<double> displayTrend =
        selectedKey != null && trends.containsKey(selectedKey)
            ? trends[selectedKey]![selectedRange] ?? [128000, 128500]
            : [128000, 128500];
    final double trendDelta =
        ((displayTrend.last - displayTrend.first) / displayTrend.first);
    final Color trendColor = trendDelta >= 0 ? Colors.green : Colors.red;

    final maxHeight = MediaQuery.of(context).size.height;
    final chartRadius = maxHeight * 0.28;
    final innerHole = chartRadius * 0.55;
    final outerRadius = chartRadius * 0.32;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggling header (leave this untouched)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Portfolio Snapshot",
                  style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  GestureDetector(
                    onTap: cycleRange,
                    child: Row(
                      children: [
                        const Icon(Icons.timeline),
                        const SizedBox(width: 4),
                        Text(selectedRange),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: cycleView,
                    child: Row(
                      children: [
                        const Icon(Icons.view_module),
                        const SizedBox(width: 4),
                        Text(selectedView),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Stack with pie + center donut touch area
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response?.touchedSection == null) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex =
                                response!.touchedSection!.touchedSectionIndex;
                          }
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: innerHole,
                    sectionsSpace: 1.5,
                    sections: List.generate(pieData.length, (i) {
                      final isTouched = i == touchedIndex;
                      final entry = pieData[i];
                      return PieChartSectionData(
                        color: pieColors[i].withOpacity(0.9),
                        value: entry.value,
                        title: '${entry.key} ${entry.value.toInt()}%',
                        titleStyle: TextStyle(
                          fontSize: isTouched ? 14 : 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        radius: outerRadius,
                      );
                    }),
                  ),
                ),

                // 🟢 This is now the modal trigger only
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openDetailsModal(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        showUsd
                            ? "\$${displayValue.toStringAsFixed(0)}"
                            : "Ξ${(displayValue / 4700).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(show: false),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: displayTrend
                                    .asMap()
                                    .entries
                                    .map((e) =>
                                        FlSpot(e.key.toDouble(), e.value))
                                    .toList(),
                                isCurved: true,
                                color: trendColor,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        trendDelta >= 0
                            ? "+${(trendDelta * 100).toStringAsFixed(1)}%"
                            : "${(trendDelta * 100).toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: trendColor,
                        ),
                      ),
                      Text(
                        "Past $selectedRange",
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          // Top movers
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Top Movers",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("🚀 PEPE +12.4%", style: TextStyle(color: Colors.green)),
                  Text("🔻ARB -7.1%", style: TextStyle(color: Colors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
