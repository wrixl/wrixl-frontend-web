// lib/widgets/dashboard_overview_sector_dominance_card.dart

// lib/widgets/dashboard_overview_sector_dominance_card.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants.dart'; // Provides AppConstants.

class DynamicSectorDominanceCard extends StatefulWidget {
  const DynamicSectorDominanceCard({Key? key}) : super(key: key);

  @override
  State<DynamicSectorDominanceCard> createState() => _DynamicSectorDominanceCardState();
}

class _DynamicSectorDominanceCardState extends State<DynamicSectorDominanceCard> {
  int touchedIndex = -1;
  int selectedViewIndex = 0;

  /// View options that the user can toggle between.
  final List<String> viewOptions = [
    "Portfolio",
    "Dominance",
    "Themes",
  ];

  /// Returns the current pie data based on the selected view.
  List<_PieData> getCurrentPieData() {
    if (selectedViewIndex == 0) {
      // Portfolio Composition: stablecoins, L1s, DeFi, NFTs.
      return [
        _PieData("Stablecoins", 40, AppConstants.accentColor, "assets/images/stablecoins.png"),
        _PieData("L1s", 30, AppConstants.neonYellow, "assets/images/l1s.png"),
        _PieData("DeFi", 20, AppConstants.neonMagenta, "assets/images/defi.png"),
        _PieData("NFTs", 10, AppConstants.neonGreen, "assets/images/nfts.png"),
      ];
    } else if (selectedViewIndex == 1) {
      // Global Sector Dominance: DeFi, L1s, Meme Coins, AI.
      return [
        _PieData("DeFi", 35, AppConstants.accentColor, "assets/images/defi.png"),
        _PieData("L1s", 25, AppConstants.neonYellow, "assets/images/l1s.png"),
        _PieData("Meme Coins", 20, AppConstants.neonMagenta, "assets/images/meme_coins.png"),
        _PieData("AI", 20, AppConstants.neonGreen, "assets/images/ai.png"),
      ];
    } else {
      // Thematic Overlays: Trending by dev activity, sentiment, gas usage.
      return [
        _PieData("Dev Activity", 30, AppConstants.accentColor, "assets/images/dev_activity.png"),
        _PieData("Sentiment", 30, AppConstants.neonYellow, "assets/images/sentiment.png"),
        _PieData("Gas Usage", 25, AppConstants.neonMagenta, "assets/images/gas_usage.png"),
        _PieData("Other Trends", 15, AppConstants.neonGreen, "assets/images/other_trends.png"),
      ];
    }
  }

  /// Returns pie chart sections based on the current pie data.
  List<PieChartSectionData> getPieChartSections(BuildContext context) {
    final pieData = getCurrentPieData();
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    return List.generate(pieData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      TextStyle sectionTextStyle = Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: AppConstants.textColor,
                shadows: shadows,
              ) ??
          TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: AppConstants.textColor,
              shadows: shadows);

      return PieChartSectionData(
        color: pieData[i].color,
        value: pieData[i].value.toDouble(),
        title: '${pieData[i].value}%',
        radius: radius,
        titleStyle: sectionTextStyle,
        badgeWidget: _Badge(
          pieData[i].badgeAsset,
          size: widgetSize,
          borderColor: Colors.black,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentData = getCurrentPieData();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Tall Card Title Styling
            const SizedBox(height: 16),
            Text(
              viewOptions[selectedViewIndex],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.accentColor,
                    letterSpacing: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Wrap toggle buttons in a SingleChildScrollView to prevent overflow.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                isSelected: List.generate(
                    viewOptions.length, (index) => index == selectedViewIndex),
                onPressed: (index) {
                  setState(() {
                    selectedViewIndex = index;
                    touchedIndex = -1; // reset highlighted section
                  });
                },
                children: viewOptions
                    .map((option) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Text(
                            option,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Pie chart display area.
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: getPieChartSections(context),
                        ),
                      ),
                      // Overlay label when a slice is touched.
                      if (touchedIndex != -1 && touchedIndex < currentData.length)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${currentData[touchedIndex].label}: ${currentData[touchedIndex].value}%",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to store pie slice data.
class _PieData {
  final String label;
  final int value;
  final Color color;
  final String badgeAsset;

  _PieData(this.label, this.value, this.color, this.badgeAsset);
}

/// The badge widget now uses a white background for better asset visibility.
class _Badge extends StatelessWidget {
  const _Badge(
    this.asset, {
    required this.size,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  final String asset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        // Use a white background so assets stand out.
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
