// lib\screens\dashboard\dashboard_overview.dart

import 'package:flutter/material.dart';
import '../../widgets/screen_specific_widgets/dashboard_overview_widgets/dashboard_overview_line_graph.dart';
import '../../widgets/screen_specific_widgets/dashboard_overview_widgets/portfolio_pulse.dart';
import '../../widgets/screen_specific_widgets/dashboard_overview_widgets/smart_money_drift.dart';
import '../../widgets/screen_specific_widgets/dashboard_overview_widgets/market_weather.dart';
import '../../widgets/screen_specific_widgets/dashboard_overview_widgets/signal_feed.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double baseCardHeight = 220.0;
    final double smallCardHeight = baseCardHeight * 1.1 * 1.4;
    final double wideCardHeight = smallCardHeight * 1.8;

    final theme = Theme.of(context);
    final color = theme.colorScheme.onBackground;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Overview",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildCard(context, smallCardHeight,
                      child: const PortfolioPulse()),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCard(context, smallCardHeight,
                      child: const SmartMoneyDrift()),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCard(context, smallCardHeight,
                      child: const MarketWeather()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCard(context, wideCardHeight,
                rounded: true, child: const PerformanceOverTimeChart()),
            const SizedBox(height: 16),
            _buildFullWidthCard(context, child: const SignalFeed()),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, double height,
      {bool rounded = false, Widget? child}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: height,
        decoration: _cardDecoration(theme, roundness: rounded ? 32.0 : 16.0),
        child: child ??
            Center(
              child: Text(
                '',
                style: theme.textTheme.bodyLarge,
              ),
            ),
      ),
    );
  }

  Widget _buildFullWidthCard(BuildContext context, {Widget? child}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 200),
        decoration: _cardDecoration(theme),
        child: child ??
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Bottom Card",
                style: theme.textTheme.bodyLarge,
              ),
            ),
      ),
    );
  }

  BoxDecoration _cardDecoration(ThemeData theme, {double roundness = 16.0}) {
    return BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(roundness),
      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
