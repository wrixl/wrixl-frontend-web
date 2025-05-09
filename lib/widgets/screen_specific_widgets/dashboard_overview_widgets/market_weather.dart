// lib\widgets\screen_specific_widgets\dashboard_overview_widgets\market_weather.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../utils/constants.dart'; // Provides AppConstants.

class MarketWeather extends StatefulWidget {
  const MarketWeather({Key? key}) : super(key: key);

  @override
  _MarketWeatherState createState() => _MarketWeatherState();
}

class _MarketWeatherState extends State<MarketWeather> {
  // Time frame: 0 = Today, 1 = This week, 2 = This month.
  int selectedTimeFrame = 0;
  // For donut interactive animation.
  int touchedIndex = -1;

  // Define colors for the donut sections.
  final Color brightRed = Colors.red.shade700;
  final Color brightGreen = Colors.green.shade700;
  final Color brightYellow = Colors.amber;
  final Color liteGreen = Colors.lightGreen;

  /// Toggle label based on selected time frame.
  String get timeFrameLabel {
    if (selectedTimeFrame == 0) return "Today";
    if (selectedTimeFrame == 1) return "This week";
    return "This month";
  }

  /// Forecast statement based on the selected time frame.
  String get forecastText {
    if (selectedTimeFrame == 0) return "Expect calm conditions today.";
    if (selectedTimeFrame == 1) return "Mixed weather ahead this week.";
    return "Stormy conditions likely this month.";
  }

  /// Cycle through the three time frames.
  void _toggleTimeFrame() {
    setState(() {
      selectedTimeFrame = (selectedTimeFrame + 1) % 3;
    });
  }

  /// Show a modal with additional details (the options button).
  void _showDetailsModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detailed Market Weather",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text("Detailed forecast and market insights go here."),
          ],
        ),
      ),
    );
  }

  /// Show a modal when a donut section is tapped to allow text entry.
  void _showDonutDetailsModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Donut Details",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text("Enter your note regarding market weather:"),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the 4 donut sections.
  /// Use a very thin ring by making the outer radius only a little bigger than the center space.
  List<PieChartSectionData> _buildSections() {
    // Define the center hole radius and the ring thickness.
    const double ringThickness = 15; // Thin ring.
    double outerRadiusNormal = ringThickness;
    // When a section is touched, enlarge that section slightly.
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double outerRadius =
          isTouched ? outerRadiusNormal + 10 : outerRadiusNormal;
      Color sectionColor;
      switch (i) {
        case 0:
          sectionColor = brightRed;
          break;
        case 1:
          sectionColor = brightYellow;
          break;
        case 2:
          sectionColor = brightGreen;
          break;
        case 3:
        default:
          sectionColor = liteGreen;
          break;
      }
      return PieChartSectionData(
        value: 25,
        color: sectionColor,
        title: '', // No text in the ring.
        radius: outerRadius,
      );
    });
  }

  IconData _getWeatherIcon() {
    switch (selectedTimeFrame) {
      case 0:
        return Icons.wb_sunny_rounded; // Today → Sunny
      case 1:
        return Icons.cloud_queue_rounded; // This Week → Cloudy
      case 2:
      default:
        return Icons.bolt_rounded; // This Month → Stormy
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Compact padding.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Title and Options Button.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Market Weather",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.accentColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showDetailsModal,
                  tooltip: "Options",
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Row for Time Frame Toggle and a Dummy Overall Rating.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _toggleTimeFrame,
                  child: Text(
                    timeFrameLabel,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Text(
                  "Stable", // Dummy rating, can be dynamic.
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Expanded donut chart area that scales between the toggle and the forecast text.
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTapUp: (details) {
                    _showDonutDetailsModal();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              enabled: true,
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            sectionsSpace: 12,
                            centerSpaceRadius: 75,
                            sections: _buildSections(),
                          ),
                        ),
                      ),

                      /// Centered weather icon (large)
                      Icon(
                        _getWeatherIcon(),
                        size: 72,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary, // Uses AppConstants.neonGreen
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Forecast text along the bottom.
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  forecastText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
