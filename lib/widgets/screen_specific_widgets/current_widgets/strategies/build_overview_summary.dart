// lib/widgets/screen_specific_widgets/current_widgets/strategies/build_overview_summary.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class BuildOverviewSummary extends StatelessWidget {
  BuildOverviewSummary({Key? key}) : super(key: key);

  final int totalStrategies = 24;
  final int wrxBurned = 1860;
  final double avgSharpe = 1.43;
  final int aiGuidedBuilds = 15;
  final String topTheme = "Modular AI & Infra";
  final int strategiesMinted = 9;
  final List<String> customTags = ['#AI', '#DeFi', '#Stables'];
  final DateTime lastCreated = DateTime(2025, 5, 29);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              color: scheme.surface,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Build Overview Summary",
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.analytics_outlined, color: Colors.deepPurpleAccent),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Metrics
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildMetricTile(
                          label: "Total Strategies Built",
                          value: "$totalStrategies",
                          icon: Icons.layers,
                          context: context,
                        ),
                        _buildMetricTile(
                          label: "WRX Burned (Total)",
                          value: "$wrxBurned WRX",
                          icon: Icons.local_fire_department,
                          color: Colors.orange,
                          context: context,
                        ),
                        _buildMetricTile(
                          label: "Avg Sharpe Ratio",
                          value: avgSharpe.toStringAsFixed(2),
                          icon: Icons.trending_up,
                          color: Colors.green,
                          context: context,
                        ),
                        _buildMetricTile(
                          label: "AI-Guided Builds",
                          value: "$aiGuidedBuilds / $totalStrategies",
                          icon: Icons.smart_toy_outlined,
                          context: context,
                        ),
                        _buildMetricTile(
                          label: "Top Theme",
                          value: "\"$topTheme\"",
                          icon: Icons.star,
                          color: Colors.purple,
                          context: context,
                        ),
                        _buildMetricTile(
                          label: "Success Rate",
                          value:
                              "${((strategiesMinted / totalStrategies) * 100).round()}% ($strategiesMinted/$totalStrategies Minted)",
                          icon: Icons.emoji_events,
                          color: Colors.amber,
                          context: context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 24),

                    // Tags
                    Text(
                      "Custom Tags Used",
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600, color: scheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: customTags.map((tag) {
                        return GestureDetector(
                          onTap: () {
                            showNewReusableModal(
                              context,
                              title: tag,
                              size: WidgetModalSize.small,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tag, style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Details about $tag usage in builds.",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Chip(label: Text(tag)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Last created
                    Text(
                      "📅 Last Strategy Created: ${DateFormat.yMMMMd().format(lastCreated)}",
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.history),
                          label: const Text("View Full History"),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text("Export as JSON"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required BuildContext context,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = constraints.maxWidth;
        var targetWidth = (maxWidth / 6) - 24;
        if (targetWidth < 140) targetWidth = 140;
        if (targetWidth > 200) targetWidth = 200;

        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: 120, maxWidth: targetWidth),
          child: GestureDetector(
            onTap: () {
              showNewReusableModal(
                context,
                title: label,
                size: WidgetModalSize.small,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(icon, color: color ?? scheme.primary),
                        const SizedBox(width: 8),
                        Text(value,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outline.withOpacity(0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color ?? scheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
