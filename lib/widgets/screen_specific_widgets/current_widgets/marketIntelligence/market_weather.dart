// lib/widgets/screen_specific_widgets/dashboard_overview_widgets/market_weather.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MarketWeather extends StatefulWidget {
  const MarketWeather({Key? key}) : super(key: key);

  @override
  _MarketWeatherState createState() => _MarketWeatherState();
}

class _MarketWeatherState extends State<MarketWeather> {
  int selectedTimeFrame = 0;
  int touchedIndex = -1;

  // slice colors
  final brightRed = Colors.red.shade700;
  final brightYellow = Colors.amber;
  final brightGreen = Colors.green.shade700;
  final liteGreen = Colors.lightGreen;
  final deepPurple = Colors.purple.shade400;

  // the five segments
  final List<String> _labels = [
    "🌡️ Volatility Index",
    "💬 Sentiment Index",
    "💵 Stablecoin Flow",
    "🌍 Macro Stress",
    "🔀 Narrative Rotation",
  ];
  final List<String> _descriptions = [
    "Aggregated VIX proxies & DeFi spreads",
    "From Twitter, Telegram & Reddit comments",
    "Risk-off inflows vs risk-on outflows",
    "Economic calendar & yield-curve signals",
    "Capital & attention moving across sectors",
  ];

  String get timeFrameLabel {
    switch (selectedTimeFrame) {
      case 0:
        return "Today";
      case 1:
        return "This week";
      default:
        return "This month";
    }
  }

  String get forecastText {
    switch (selectedTimeFrame) {
      case 0:
        return "Expect calm conditions today.";
      case 1:
        return "Mixed weather ahead this week.";
      default:
        return "Stormy conditions likely this month.";
    }
  }

  void _toggleTimeFrame() {
    setState(() => selectedTimeFrame = (selectedTimeFrame + 1) % 3);
  }

  void _showDetailsModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detailed Market Weather",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text("Detailed forecast and market insights go here."),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    const ringThickness = 15.0;
    final colors = [
      brightRed,
      brightYellow,
      brightGreen,
      liteGreen,
      deepPurple,
    ];
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      return PieChartSectionData(
        color: colors[i],
        value: 20, // equal slices
        radius: isTouched ? ringThickness + 8 : ringThickness,
        title: '',
      );
    });
  }

  IconData _getWeatherIcon() {
    switch (selectedTimeFrame) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
        return Icons.cloud_queue_rounded;
      default:
        return Icons.bolt_rounded;
    }
  }

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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Market Weather", style: theme.textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showDetailsModal,
                  tooltip: "More Info",
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Time toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _toggleTimeFrame,
                  child: Text(timeFrameLabel,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                ),
                Text("Stable",
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent)),
              ],
            ),
            const SizedBox(height: 16),

            // Donut + overlay
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      centerSpaceRadius: 75,
                      sectionsSpace: 12,
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (event, resp) {
                          setState(() {
                            if (resp == null ||
                                resp.touchedSection == null ||
                                !event.isInterestedForInteractions) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = resp
                                  .touchedSection!.touchedSectionIndex;
                            }
                          });
                        },
                      ),
                      sections: _buildSections(),
                    ),
                  ),

                  // if no slice hovered, show weather icon; else show label+desc
                  if (touchedIndex < 0)
                    Icon(_getWeatherIcon(),
                        size: 72, color: scheme.secondary)
                  else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_labels[touchedIndex],
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(_descriptions[touchedIndex],
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurface)),
                      ],
                    ),
                ],
              ),
            ),

            // Forecast text (always stays put)
            const SizedBox(height: 16),
            Text(forecastText,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
