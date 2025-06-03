// lib\widgets\screen_specific_widgets\current_widgets\strategies\mirrored_wallet_summary.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MirroredWalletSummary extends StatelessWidget {
  const MirroredWalletSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Example mock values — these should be provided via controller/model
    const int totalWallets = 5;
    const double roi7d = 8.7;
    const double smartMoneyOverlap = 68.0;
    const double driftDelta = 14.2;
    const bool showAlert = true;
    const int underperformingWallets = 1;
    const bool showRebalanceCTA = true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _statBlock("Total Wallets", "$totalWallets mirrored", context,
                icon: Icons.groups_rounded,
                tooltip: "Number of wallets you're actively mirroring."),

            const SizedBox(width: 24),

            _roiBlock(context, roi7d),

            const SizedBox(width: 24),

            _statBlock("Smart Overlap", "$smartMoneyOverlap%", context,
                icon: Icons.bolt_rounded,
                badge: _overlapLevel(smartMoneyOverlap),
                tooltip: "How closely your current strategy overlaps with smart money actors."),

            const SizedBox(width: 24),

            _statBlock("Strategy Drift", "$driftDelta%", context,
                icon: Icons.track_changes,
                badge: driftDelta > 20 ? "High" : driftDelta > 10 ? "Med" : "Low",
                tooltip: "How far your holdings have diverged from original mirrored allocations."),

            if (showAlert) ...[
              const SizedBox(width: 24),
              _alertBadge("$underperformingWallets wallet${underperformingWallets > 1 ? 's' : ''} underperforming")
            ],

            if (showRebalanceCTA) ...[
              const SizedBox(width: 32),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sync_alt, size: 18),
                label: const Text("Rebalance Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: theme.textTheme.labelLarge,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _statBlock(String label, String value, BuildContext context,
      {required IconData icon, String? badge, String? tooltip}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: scheme.primary, size: 20),
            const SizedBox(width: 6),
            Text(value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ]
          ],
        ),
        const SizedBox(height: 4),
        Text(label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.6),
            )),
      ],
    );

    return tooltip != null
        ? Tooltip(message: tooltip, child: content)
        : content;
  }

  Widget _roiBlock(BuildContext context, double roi) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isPositive = roi >= 0;
    final formatted = NumberFormat("+#0.0;-#0.0").format(roi);

    return Tooltip(
      message: "7-day ROI across your mirrored wallets vs market average.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                "$formatted%",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("7D ROI", style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurface.withOpacity(0.6),
          ))
        ],
      ),
    );
  }

  Widget _alertBadge(String message) {
    return Tooltip(
      message: "One or more mirrored wallets are significantly underperforming.",
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
          const SizedBox(width: 6),
          Text(message, style: TextStyle(color: Colors.orange.shade800))
        ],
      ),
    );
  }

  String _overlapLevel(double value) {
    if (value >= 75) return "High";
    if (value >= 40) return "Medium";
    return "Low";
  }
}
