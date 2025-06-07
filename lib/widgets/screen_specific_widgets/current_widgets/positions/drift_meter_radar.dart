// lib\widgets\screen_specific_widgets\current_widgets\positions\drift_meter_radar.dart

import 'package:flutter/material.dart';
import 'dart:math';

class DriftMeterRadar extends StatelessWidget {
  final double alignmentScore;
  final String driftDirection;
  final List<DriftDriver> driftDrivers;

  const DriftMeterRadar({
    super.key,
    required this.alignmentScore,
    required this.driftDirection,
    required this.driftDrivers,
  });

  Color _getScoreColor(double score) {
    if (score >= 85) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.redAccent;
  }

  String _getScoreLabel(double score) {
    if (score >= 85) return 'Aligned';
    if (score >= 60) return 'Mild Drift';
    return 'Severe Drift';
  }

  IconData _getDriftIcon(String direction) {
    switch (direction) {
      case 'Stable':
        return Icons.savings;
      case 'Yield':
        return Icons.percent;
      case 'Narrative':
        return Icons.trending_up;
      case 'Risky':
        return Icons.warning_amber_rounded;
      default:
        return Icons.explore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final scoreColor = _getScoreColor(alignmentScore);
    final label = _getScoreLabel(alignmentScore);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📡 Drift Meter",
                    style: theme.textTheme.titleMedium),
                Icon(_getDriftIcon(driftDirection),
                    color: scoreColor, size: 22),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                height: 180,
                width: 180,
                child: CustomPaint(
                  painter: DriftRadarPainter(
                    driftAngle: _directionToAngle(driftDirection),
                    severity: (100 - alignmentScore) / 100,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Text(
                  '${alignmentScore.toStringAsFixed(1)}% Aligned',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Drift Drivers",
                style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.primary)),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: driftDrivers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final driver = driftDrivers[index];
                  return Container(
                    width: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(driver.iconUrl),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                driver.symbol,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          driver.drift > 0
                              ? '+${driver.drift.toStringAsFixed(1)}%'
                              : '${driver.drift.toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: driver.drift > 0
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          driver.label,
                          style: theme.textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _directionToAngle(String direction) {
    switch (direction) {
      case 'Stable':
        return -pi / 2;
      case 'Yield':
        return 0;
      case 'Narrative':
        return pi / 2;
      case 'Risky':
        return pi;
      default:
        return -pi / 2;
    }
  }
}

class DriftRadarPainter extends CustomPainter {
  final double driftAngle;
  final double severity;

  DriftRadarPainter({required this.driftAngle, required this.severity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double r = radius; r > 0; r -= radius / 4) {
      canvas.drawCircle(center, r, paint);
    }

    final arrowPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final arrowLength = radius * severity;
    final endX = center.dx + arrowLength * cos(driftAngle);
    final endY = center.dy + arrowLength * sin(driftAngle);

    canvas.drawLine(center, Offset(endX, endY), arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DriftDriver {
  final String symbol;
  final double drift;
  final String label;
  final String iconUrl;

  const DriftDriver({
    required this.symbol,
    required this.drift,
    required this.label,
    required this.iconUrl,
  });
}

final List<DriftDriver> dummyDriftDrivers = [
  DriftDriver(
    symbol: 'DOGE',
    drift: 4.5,
    label: 'Meme Overweight',
    iconUrl: 'https://cryptologos.cc/logos/dogecoin-doge-logo.png',
  ),
  DriftDriver(
    symbol: 'SOL',
    drift: 3.2,
    label: 'Alt L1 Overexposed',
    iconUrl: 'https://cryptologos.cc/logos/solana-sol-logo.png',
  ),
  DriftDriver(
    symbol: 'USDC',
    drift: -5.0,
    label: 'Stable Underweight',
    iconUrl: 'https://cryptologos.cc/logos/usd-coin-usdc-logo.png',
  ),
  DriftDriver(
    symbol: 'INJ',
    drift: 2.7,
    label: 'DeFi Surge',
    iconUrl: 'https://cryptologos.cc/logos/injective-protocol-inj-logo.png',
  ),
];
