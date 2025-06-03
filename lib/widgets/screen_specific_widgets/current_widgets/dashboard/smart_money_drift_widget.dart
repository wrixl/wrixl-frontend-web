// lib\widgets\screen_specific_widgets\current_widgets\smart_money_drift_widget.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class SmartMoneyDriftWidget extends StatefulWidget {
  const SmartMoneyDriftWidget({super.key});

  @override
  State<SmartMoneyDriftWidget> createState() => _SmartMoneyDriftWidgetState();
}

class _SmartMoneyDriftWidgetState extends State<SmartMoneyDriftWidget> {
  final double alignmentScore = 72.0;
  final Offset driftOffset = const Offset(0.3, 0.5);
  final List<_DriftDeviation> deviations = [
    _DriftDeviation(
        asset: "Meme Coins", delta: 12, reason: "Low smart money exposure"),
    _DriftDeviation(
        asset: "Stablecoins",
        delta: -9,
        reason: "Over-concentration in USDC/USDT"),
    _DriftDeviation(
        asset: "LSD Tokens",
        delta: 7,
        reason: "Smart wallets prefer ETH staking plays"),
  ];

  void _showFullDriftModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: "Smart Money Drift",
        size: WidgetModalSize.medium,
        onClose: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Similarity Index: $alignmentScore%",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              alignmentScore > 70
                  ? "Your portfolio is well-aligned with high-performing smart wallets."
                  : alignmentScore > 40
                      ? "Your portfolio is drifting from smart money strategies. Time to reassess."
                      : "You're significantly off-course — major divergence from successful wallet patterns.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              "Top Divergences",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            ...deviations.map((d) => _buildDetailedDriftItem(context, d)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedDriftItem(
      BuildContext context, _DriftDeviation deviation) {
    final isOver = deviation.delta > 0;
    final color = isOver ? Colors.redAccent : Colors.green;
    final icon = isOver ? Icons.arrow_upward : Icons.arrow_downward;
    final barWidth = (deviation.delta.abs().clamp(0, 100) / 100.0) * 160;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                "${deviation.asset} — ${deviation.delta > 0 ? '+' : ''}${deviation.delta}%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 6,
            width: barWidth,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            deviation.reason,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showFullDriftModal(context),
      behavior: HitTestBehavior.deferToChild, // important
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: scheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Smart Money Drift",
                      style: Theme.of(context).textTheme.titleMedium),
                  GestureDetector(
                    onTap: () {
                      // whatever logic your button should do
                    },
                    child: Icon(Icons.compass_calibration_outlined,
                        color: scheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  height: 320,
                  width: 320,
                  child: CustomPaint(
                    painter: _DriftScopePainter(
                        score: alignmentScore, offset: driftOffset),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${alignmentScore.toInt()}%",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary)),
                          Text(
                              alignmentScore > 70
                                  ? "Aligned"
                                  : (alignmentScore > 40
                                      ? "Drifting"
                                      : "Off Course"),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: scheme.onSurface.withOpacity(0.6))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: deviations
                      .map((d) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SmartMoneyDriftStrip(deviation: d),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriftDeviation {
  final String asset;
  final int delta;
  final String reason;

  _DriftDeviation(
      {required this.asset, required this.delta, required this.reason});
}

class _DriftScopePainter extends CustomPainter {
  final double score;
  final Offset offset;

  _DriftScopePainter({required this.score, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;
    final ringPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * (i / 3), ringPaint);
    }

    final crossPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), crossPaint);
    canvas.drawLine(
        Offset(0, center.dy), Offset(size.width, center.dy), crossPaint);

    final labelStyle = TextStyle(fontSize: 10, color: Colors.grey.shade600);
    final textPainter = (String text, Offset position) {
      final tp = TextPainter(
          text: TextSpan(text: text, style: labelStyle),
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, position);
    };
    textPainter("Stable", Offset(4, 4));
    textPainter("Narrative", Offset(size.width - 52, 4));
    textPainter("High Risk", Offset(size.width - 60, size.height - 16));
    textPainter("Yield", Offset(4, size.height - 16));

    final driftPaint = Paint()
      ..color =
          score > 70 ? Colors.green : (score > 40 ? Colors.orange : Colors.red)
      ..style = PaintingStyle.fill;

    final driftX = center.dx + (offset.dx - 0.5) * radius * 2;
    final driftY = center.dy + (offset.dy - 0.5) * radius * 2;

    canvas.drawCircle(Offset(driftX, driftY), 5, driftPaint);
  }

  @override
  bool shouldRepaint(_DriftScopePainter old) =>
      old.score != score || old.offset != offset;
}

class SmartMoneyDriftStrip extends StatelessWidget {
  final _DriftDeviation deviation;

  const SmartMoneyDriftStrip({required this.deviation});

  @override
  Widget build(BuildContext context) {
    final isOver = deviation.delta > 0;
    final color = isOver ? Colors.redAccent : Colors.green;
    final icon = isOver ? Icons.arrow_upward : Icons.arrow_downward;
    final barWidth = (deviation.delta.abs().clamp(0, 100) / 100.0) * 150;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => NewWidgetModal(
              title: deviation.asset,
              size: WidgetModalSize.small,
              onClose: () => Navigator.pop(context),
              child: Text(deviation.reason),
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            SizedBox(
              width: 80,
              child: Text(
                deviation.asset,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "${deviation.delta > 0 ? '+' : ''}${deviation.delta}%",
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(width: 6),
            Container(
              height: 6,
              width: barWidth,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
