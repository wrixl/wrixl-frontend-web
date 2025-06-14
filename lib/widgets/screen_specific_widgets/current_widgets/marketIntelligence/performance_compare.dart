// lib\widgets\screen_specific_widgets\current_widgets\marketIntelligence\performance_compare.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants.dart';

class PerformanceOverTimeChart extends StatefulWidget {
  const PerformanceOverTimeChart({Key? key}) : super(key: key);

  @override
  State<PerformanceOverTimeChart> createState() =>
      _PerformanceOverTimeChartState();
}

class _PerformanceOverTimeChartState extends State<PerformanceOverTimeChart> {
  // Independent toggle booleans for each series.
  bool _myPortfolio = true;
  bool _smartMoney = true;
  bool _broadMarket = true;
  bool _sectors = false;
  bool _gold = false;
  bool _sp500 = false;
  bool _nasdaq = false;

  // For the sectors mode, a mapping for each available sector and its active state.
  Map<String, bool> _selectedSectors = {
    "DeFi": false,
    "L1s": false,
    "Meme Coins": false,
    "AI": false,
    "NFT": false,
    "BTC": false,
  };

  // Mapping of sector names to colors.
  final Map<String, Color> _sectorColors = {
    "DeFi": AppConstants.neonGreen,
    "L1s": AppConstants.neonYellow,
    "Meme Coins": AppConstants.neonMagenta,
    "AI": Colors.blue,
    "NFT": Colors.purple,
    "BTC": Colors.orange,
  };

  // --------------------------
  // Helper methods returning sample data.
  // --------------------------

  // "My Portfolio" sample data.
  LineChartBarData _portfolioLineData() {
    return LineChartBarData(
      isCurved: true,
      color: AppConstants.neonGreen,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
      ],
    );
  }

  // "Smart Money" sample data.
  LineChartBarData _smartMoneyLineData() {
    return LineChartBarData(
      isCurved: true,
      color: AppConstants.neonMagenta,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1),
        FlSpot(3, 2.8),
        FlSpot(7, 1.2),
        FlSpot(10, 2.8),
        FlSpot(12, 2.6),
        FlSpot(13, 3.9),
      ],
    );
  }

  // "Broad Market" sample data.
  LineChartBarData _broadMarketLineData() {
    return LineChartBarData(
      isCurved: true,
      color: AppConstants.accentColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1.2),
        FlSpot(3, 2),
        FlSpot(5, 1.8),
        FlSpot(7, 2.5),
        FlSpot(10, 2.2),
        FlSpot(12, 3),
        FlSpot(13, 2.8),
      ],
    );
  }

  // Sample data for a given sector.
  // The spots are generated by applying a unique offset per sector.
  LineChartBarData _sectorLineData(String sector) {
    final Map<String, double> offsets = {
      "DeFi": 0.0,
      "L1s": 0.2,
      "Meme Coins": -0.2,
      "AI": 0.3,
      "NFT": -0.3,
      "BTC": 0.1,
    };
    final double offset = offsets[sector] ?? 0.0;
    return LineChartBarData(
      isCurved: true,
      color: _sectorColors[sector] ?? Colors.grey,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: [
        FlSpot(1, offset + 1),
        FlSpot(3, offset + 1.5),
        FlSpot(5, offset + 1.4),
        FlSpot(7, offset + 3.4),
        FlSpot(10, offset + 2),
        FlSpot(12, offset + 2.2),
        FlSpot(13, offset + 1.8),
      ],
    );
  }

  // "Gold" sample data.
  LineChartBarData _goldLineData() {
    return LineChartBarData(
      isCurved: true,
      color: Colors.amber,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1.3),
        FlSpot(3, 1.7),
        FlSpot(5, 1.6),
        FlSpot(7, 2.8),
        FlSpot(10, 2.1),
        FlSpot(12, 2.5),
        FlSpot(13, 2.0),
      ],
    );
  }

  // "S&P 500" sample data.
  LineChartBarData _sp500LineData() {
    return LineChartBarData(
      isCurved: true,
      color: Colors.indigo,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1.5),
        FlSpot(3, 2.0),
        FlSpot(5, 1.9),
        FlSpot(7, 2.7),
        FlSpot(10, 2.3),
        FlSpot(12, 2.8),
        FlSpot(13, 2.4),
      ],
    );
  }

  // "NASDAQ" sample data.
  LineChartBarData _nasdaqLineData() {
    return LineChartBarData(
      isCurved: true,
      color: Colors.lightBlue,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: const [
        FlSpot(1, 1.8),
        FlSpot(3, 2.3),
        FlSpot(5, 2.1),
        FlSpot(7, 3.0),
        FlSpot(10, 2.6),
        FlSpot(12, 3.1),
        FlSpot(13, 2.9),
      ],
    );
  }

  // --------------------------
  // Assemble current chart data based on active toggles.
  // --------------------------
  LineChartData get _currentChartData {
    List<LineChartBarData> seriesData = [];
    List<String> seriesNames = [];

    if (_myPortfolio) {
      seriesData.add(_portfolioLineData());
      seriesNames.add("My Portfolio");
    }
    if (_smartMoney) {
      seriesData.add(_smartMoneyLineData());
      seriesNames.add("Smart Money");
    }
    if (_broadMarket) {
      seriesData.add(_broadMarketLineData());
      seriesNames.add("Broad Market");
    }
    if (_sectors) {
      _selectedSectors.forEach((sector, isActive) {
        if (isActive) {
          seriesData.add(_sectorLineData(sector));
          seriesNames.add(sector);
        }
      });
    }
    if (_gold) {
      seriesData.add(_goldLineData());
      seriesNames.add("Gold");
    }
    if (_sp500) {
      seriesData.add(_sp500LineData());
      seriesNames.add("S&P 500");
    }
    if (_nasdaq) {
      seriesData.add(_nasdaqLineData());
      seriesNames.add("NASDAQ");
    }

    // The tooltip uses the seriesNames list to identify each series.
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              String date = "Date: ${spot.x.toInt()}"; // Dummy date conversion.
              double trendDelta = spot.y * 0.1; // Dummy calculation.
              String seriesName = seriesNames[spot.barIndex];
              return LineTooltipItem(
                '$seriesName\n$date\nValue: ${spot.y.toStringAsFixed(1)}%\nDelta: ${trendDelta.toStringAsFixed(1)}%',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      gridData: const FlGridData(show: true),
      titlesData: _titlesData,
      borderData: _borderData,
      lineBarsData: seriesData,
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 4,
    );
  }

  // --------------------------
  // Axis and border styling.
  // --------------------------
  FlTitlesData get _titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppConstants.secondaryTextColor,
              );
              switch (value.toInt()) {
                case 2:
                  return Text('SEPT', style: style);
                case 7:
                  return Text('OCT', style: style);
                case 12:
                  return Text('DEC', style: style);
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppConstants.secondaryTextColor,
              );
              return Text('${value.toInt()}%', style: style);
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      );

  FlBorderData get _borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: AppConstants.accentColor.withOpacity(0.2),
            width: 4,
          ),
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      );

  // --------------------------
  // Toggle Buttons widget.
  // --------------------------
  Widget _buildToggleButtons() {
    List<bool> isSelected = [
      _myPortfolio,
      _smartMoney,
      _broadMarket,
      _sectors,
      _gold,
      _sp500,
      _nasdaq
    ];
    return ToggleButtons(
      borderRadius: BorderRadius.circular(8),
      isSelected: isSelected,
      onPressed: (index) {
        setState(() {
          switch (index) {
            case 0:
              _myPortfolio = !_myPortfolio;
              break;
            case 1:
              _smartMoney = !_smartMoney;
              break;
            case 2:
              _broadMarket = !_broadMarket;
              break;
            case 3:
              _sectors = !_sectors;
              break;
            case 4:
              _gold = !_gold;
              break;
            case 5:
              _sp500 = !_sp500;
              break;
            case 6:
              _nasdaq = !_nasdaq;
              break;
          }
        });
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("My Portfolio",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("Smart Money",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("Broad Market",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("Sectors", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("Gold", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("S&P 500", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text("NASDAQ", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // --------------------------
  // Build the FilterChips for sector selection.
  // --------------------------
  Widget _buildSectorChips() {
    return Wrap(
      spacing: 6,
      children: _selectedSectors.keys.map((sector) {
        bool isActive = _selectedSectors[sector]!;
        return FilterChip(
          label: Text(sector),
          selected: isActive,
          onSelected: (selected) {
            setState(() {
              _selectedSectors[sector] = selected;
            });
          },
          selectedColor: _sectorColors[sector]?.withOpacity(0.4),
        );
      }).toList(),
    );
  }

  // --------------------------
  // Build the final widget.
  // --------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App bar style header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Performance Comparison",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart_rounded),
                  tooltip: "Expand or explain",
                  onPressed: () {}, // You can add modal logic here
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Toggle buttons for series
            _buildToggleButtons(),
            if (_sectors) ...[
              const SizedBox(height: 8),
              _buildSectorChips(),
            ],
            const SizedBox(height: 16),

            // Chart
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LineChart(
                  _currentChartData,
                  duration: const Duration(milliseconds: 250),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              "📊 Visualize your portfolio’s relative growth over time. Tap a legend item to filter views.",
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: scheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
