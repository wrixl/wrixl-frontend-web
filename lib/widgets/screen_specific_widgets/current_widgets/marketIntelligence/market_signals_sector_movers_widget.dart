// lib/widgets/screen_specific_widgets/market_signals_widgets/market_signals_sector_movers_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

/// Data model for a sector mover with extra fields.
class SectorMover {
  final String sectorName;
  final IconData icon;
  final double devActivity;
  final double walletGrowth;
  final double txVolume;
  final double marketCapDelta;
  final List<double> sparklineData;
  final int tokensCount;
  final double marketCap;

  SectorMover({
    required this.sectorName,
    required this.icon,
    required this.devActivity,
    required this.walletGrowth,
    required this.txVolume,
    required this.marketCapDelta,
    required this.sparklineData,
    required this.tokensCount,
    required this.marketCap,
  });
}

class MarketSignalsSectorMoversWidget extends StatefulWidget {
  const MarketSignalsSectorMoversWidget({Key? key}) : super(key: key);

  @override
  State<MarketSignalsSectorMoversWidget> createState() =>
      _MarketSignalsSectorMoversWidgetState();
}

class _MarketSignalsSectorMoversWidgetState
    extends State<MarketSignalsSectorMoversWidget> {
  final List<SectorMover> movers = [
    SectorMover(
      sectorName: "DeFi",
      icon: Icons.account_balance_wallet,
      devActivity: 25.0,
      walletGrowth: 18.0,
      txVolume: -5.0,
      marketCapDelta: 12.0,
      sparklineData: [1.0, 1.1, 1.3, 1.2, 1.4, 1.5, 1.6],
      tokensCount: 15,
      marketCap: 120.0,
    ),
    SectorMover(
      sectorName: "AI",
      icon: Icons.memory,
      devActivity: 15.0,
      walletGrowth: 12.0,
      txVolume: 8.0,
      marketCapDelta: 20.0,
      sparklineData: [0.9, 1.0, 1.05, 1.2, 1.3, 1.4, 1.5],
      tokensCount: 10,
      marketCap: 85.0,
    ),
    SectorMover(
      sectorName: "Gaming",
      icon: Icons.videogame_asset,
      devActivity: -5.0,
      walletGrowth: 10.0,
      txVolume: 5.0,
      marketCapDelta: 3.0,
      sparklineData: [1.2, 1.15, 1.1, 1.05, 1.0, 0.95, 0.9],
      tokensCount: 8,
      marketCap: 50.0,
    ),
  ];

  String selectedFilter = 'Top Movers';
  final List<String> filters = ['Top Movers', 'My Exposure'];
  final Map<String, IconData> filterIcons = {
    'Top Movers': Icons.trending_up,
    'My Exposure': Icons.insights,
  };

  String selectedMetric = 'Dev Activity';
  final List<String> metrics = [
    'Dev Activity',
    'Wallet Growth',
    'TX Volume',
    'Market Cap Delta',
  ];
  final Map<String, IconData> metricIcons = {
    'Dev Activity': Icons.code,
    'Wallet Growth': Icons.account_balance_wallet,
    'TX Volume': Icons.swap_vert,
    'Market Cap Delta': Icons.show_chart,
  };

  double getMetricValue(SectorMover mover, String metric) {
    switch (metric) {
      case 'Wallet Growth':
        return mover.walletGrowth;
      case 'TX Volume':
        return mover.txVolume;
      case 'Market Cap Delta':
        return mover.marketCapDelta;
      default:
        return mover.devActivity;
    }
  }

  List<SectorMover> get filteredMovers {
    final all = List<SectorMover>.from(movers);
    if (selectedFilter == 'Top Movers') {
      all.sort((a, b) => getMetricValue(b, selectedMetric)
          .compareTo(getMetricValue(a, selectedMetric)));
      return all.take(3).toList();
    }
    return all;
  }

  void _showOptionsModal() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sector Movers Options",
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                "Additional options for Sector Movers can be placed here.",
                style: theme.textTheme.bodyMedium,
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
    final scheme = theme.colorScheme;
    final primary = scheme.primary;
    final surface = scheme.surface;
    final onSurface = scheme.onSurface;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AppBar-style title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sector Movers", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: Icon(Icons.more_vert, color: onSurface.withOpacity(0.7)),
                  onPressed: _showOptionsModal,
                  tooltip: "Options",
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Filter rows
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ToggleFilterIconRowWidget(
                  options: filters,
                  optionIcons: filterIcons,
                  activeOption: selectedFilter,
                  onSelected: (val) => setState(() => selectedFilter = val),
                ),
                ToggleFilterIconRowWidget(
                  options: metrics,
                  optionIcons: metricIcons,
                  activeOption: selectedMetric,
                  onSelected: (val) => setState(() => selectedMetric = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cards
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredMovers.map((mover) {
                    final value = getMetricValue(mover, selectedMetric);
                    final color = value >= 0
                        ? scheme.secondary
                        : scheme.error;
                    final trendIcon = Icon(
                      value > 0
                          ? Icons.arrow_upward
                          : value < 0
                              ? Icons.arrow_downward
                              : Icons.remove,
                      size: 16,
                      color: value > 0
                          ? color
                          : value < 0
                              ? color
                              : onSurface.withOpacity(0.6),
                    );

                    return Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: _SectorMoverCard(
                        mover: mover,
                        metricValue: value,
                        metricLabel: selectedMetric,
                        trendIcon: trendIcon,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(SectorMover mover) {
    final theme = Theme.of(context);
    final topTokens = List<String>.generate(5, (i) => "Token ${i + 1}");
    final bottomTokens = mover.tokensCount >= 10
        ? List<String>.generate(
            5, (i) => "Token ${mover.tokensCount - 5 + i + 1}")
        : <String>[];

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(mover.sectorName, style: theme.textTheme.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detailed stats:\n\n"
                  "Dev Activity: ${mover.devActivity}%\n"
                  "Wallet Growth: ${mover.walletGrowth}%\n"
                  "TX Volume: ${mover.txVolume}%\n"
                  "Market Cap Delta: ${mover.marketCapDelta}%\n\n"
                  "Market Cap: \$${mover.marketCap.toStringAsFixed(1)}M",
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text("Top 5 Tokens:", style: theme.textTheme.bodyMedium),
                Text(
                  topTokens.join(', '),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (bottomTokens.isNotEmpty) ...[
                  Text("Bottom 5 Tokens:", style: theme.textTheme.bodyMedium),
                  Text(
                    bottomTokens.join(', '),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: theme.textTheme.labelLarge),
            ),
          ],
        );
      },
    );
  }
}

/// Sector Mover Card displaying the metrics and sparkline.
class _SectorMoverCard extends StatelessWidget {
  final SectorMover mover;
  final double metricValue;
  final String metricLabel;
  final Icon trendIcon;

  const _SectorMoverCard({
    Key? key,
    required this.mover,
    required this.metricValue,
    required this.metricLabel,
    required this.trendIcon,
  }) : super(key: key);

  // Convert sparkline data into FlSpot list.
  List<FlSpot> getChartSpots() => mover.sparklineData
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), e.value))
      .toList();

  // Compute the average value for the sparkline.
  double get averageValue =>
      mover.sparklineData.reduce((a, b) => a + b) / mover.sparklineData.length;

  // Generate spots for the average line.
  List<FlSpot> getAverageSpots() => mover.sparklineData
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), averageValue))
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final positiveColor = theme.colorScheme.secondary;
    final negativeColor = theme.colorScheme.error;
    final neutralColor = onSurfaceColor.withOpacity(0.6);

    return InkWell(
      onTap: () {
        (context.findAncestorStateOfType<
                _MarketSignalsSectorMoversWidgetState>())
            ?._showDetailsDialog(mover);
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Icon and sector name.
            Row(
              children: [
                Icon(mover.icon, color: primaryColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mover.sectorName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Metric value row.
            Row(
              children: [
                Text(
                  "${metricValue.toStringAsFixed(1)}%",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: metricValue >= 0 ? positiveColor : negativeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                trendIcon,
              ],
            ),
            const SizedBox(height: 12),
            // Sparkline chart.
            SizedBox(
              height: 80,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getChartSpots(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withOpacity(0.7),
                        ],
                      ),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    LineChartBarData(
                      spots: getAverageSpots(),
                      isCurved: false,
                      color: neutralColor,
                      barWidth: 1,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Bottom row: Tokens count & market cap.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tokens: ${mover.tokensCount}",
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  "\$${mover.marketCap.toStringAsFixed(1)}M",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
