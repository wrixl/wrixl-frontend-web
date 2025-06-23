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
      barrierDismissible: false,
      builder: (_) => NewWidgetModal(
        title: "Detailed Portfolio Breakdown",
        size: WidgetModalSize.medium,
        onClose: () => Navigator.of(context).pop(),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            final alloc = allocations[selectedView]![selectedRange]!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cycle controls live in the modal now:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => setModalState(cycleRange),
                          child: Row(
                            children: [
                              const Icon(Icons.timeline),
                              const SizedBox(width: 4),
                              Text(selectedRange),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setModalState(cycleView),
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
                    const SizedBox(height: 16),
                    // Breakdown list:
                    ...alloc.entries.map((e) {
                      final value = getCurrentValue(e.key, e.value);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "${e.key}: ${e.value.toStringAsFixed(1)}% → "
                          "${showUsd ? "\$${value.toStringAsFixed(2)}" : "Ξ${(value / 4700).toStringAsFixed(2)}"}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }



    @override
    Widget build(BuildContext context) {
      final scheme = Theme.of(context).colorScheme;
      final alloc = allocations[selectedView]![selectedRange]!;
      final pieData = alloc.entries.toList();
      final pieColors = Colors.primaries.take(pieData.length).toList();

      // center value + trend
      final selectedKey = (touchedIndex >= 0 && touchedIndex < pieData.length)
          ? pieData[touchedIndex].key
          : null;
      final displayValue = selectedKey != null
          ? getCurrentValue(selectedKey, alloc[selectedKey]!)
          : 128342;
      final displayTrend = (selectedKey != null && trends.containsKey(selectedKey))
          ? trends[selectedKey]![selectedRange]!
          : [128000, 128500];
      final trendDelta =
          (displayTrend.last - displayTrend.first) / displayTrend.first;
      final trendColor = trendDelta >= 0 ? Colors.green : Colors.red;

      return LayoutBuilder(builder: (context, constraints) {
        final chartRadius = constraints.maxWidth * 0.4;
        final innerHole = chartRadius * 0.55;
        final sliceR = chartRadius * 0.32;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // ← shrink-wrap in a scrollable
            children: [
              // — header —
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

              // — chart area —
              Flexible(
                fit: FlexFit.loose, // ← no crash in unbounded height
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (e, resp) {
                                setState(() {
                                  if (!e.isInterestedForInteractions ||
                                      resp?.touchedSection == null) {
                                    touchedIndex = -1;
                                  } else {
                                    touchedIndex = resp!
                                        .touchedSection!.touchedSectionIndex;
                                  }
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: innerHole,
                            sectionsSpace: 1.5,
                            sections: List.generate(pieData.length, (i) {
                              final isTouched = i == touchedIndex;
                              final e = pieData[i];
                              return PieChartSectionData(
                                color: pieColors[i].withOpacity(0.9),
                                value: e.value,
                                title: '${e.key} ${e.value.toInt()}%',
                                titleStyle: TextStyle(
                                  fontSize: isTouched ? 14 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                radius: sliceR,
                              );
                            }),
                          ),
                        ),

                        // center label + sparkline
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _openDetailsModal(context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                            .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
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
                                (trendDelta >= 0 ? "+" : "") +
                                    (trendDelta * 100).toStringAsFixed(1) +
                                    "%",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: trendColor),
                              ),
                              Text(
                                "Past $selectedRange",
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        scheme.onSurface.withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // — footer —
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
        );
      });
    }
  }


