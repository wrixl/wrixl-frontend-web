// lib\widgets\screen_specific_widgets\current_widgets\missed_opportunities_widget.dart

// lib/widgets/screen_specific_widgets/current_widgets/missed_opportunities_widget.dart

import 'package:flutter/material.dart';
import 'dart:math';

class MissedOpportunitiesWidget extends StatefulWidget {
  const MissedOpportunitiesWidget({super.key});

  @override
  State<MissedOpportunitiesWidget> createState() =>
      _MissedOpportunitiesWidgetState();
}

class _MissedOpportunitiesWidgetState extends State<MissedOpportunitiesWidget> {
  final List<MissedOpportunity> missed = [
    MissedOpportunity(
      token: "SOL",
      regretScore: 42.3,
      removedDaysAgo: 6,
      simulatedGain: 512.3,
      exitReason: "Sold during dip",
      behaviorScore: 28,
    ),
    MissedOpportunity(
      token: "INJ",
      regretScore: 27.8,
      removedDaysAgo: 10,
      simulatedGain: 309.4,
      exitReason: "Exited at breakeven",
      behaviorScore: 45,
    ),
    MissedOpportunity(
      token: "ARB",
      regretScore: 18.1,
      removedDaysAgo: 13,
      simulatedGain: 205.0,
      exitReason: "Exited after 3-day drop",
      behaviorScore: 34,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Missed Opportunities",
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: missed.map((m) => _buildMissedCard(context, m)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedCard(BuildContext context, MissedOpportunity m) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _showDetailsModal(context, m),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: scheme.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CustomPaint(
                painter: RegretDialPainter(score: m.regretScore),
                size: const Size(44, 44),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${m.token} missed +${m.regretScore.toStringAsFixed(1)}%",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            )),
                    Text("${m.exitReason} · ${m.removedDaysAgo}d ago",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            )),
                  ],
                ),
              ),
              _behaviorTag(m.behaviorScore),
              const SizedBox(width: 6),
              Icon(Icons.play_circle_outline, color: scheme.primary, size: 28)
            ],
          ),
        ),
      ),
    );
  }

  Widget _behaviorTag(int score) {
    Color color;
    String label;
    if (score < 40) {
      color = Colors.redAccent;
      label = "Impulsive";
    } else if (score < 70) {
      color = Colors.orangeAccent;
      label = "Reactive";
    } else {
      color = Colors.green;
      label = "Disciplined";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }

  void _showDetailsModal(BuildContext context, MissedOpportunity m) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text("If you'd held ${m.token}...",
            style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("⏱ Exit Reason: ${m.exitReason}"),
            Text("📈 Price rose +${m.regretScore.toStringAsFixed(1)}%"),
            Text("💰 Missed Gain: \$${m.simulatedGain.toStringAsFixed(2)}"),
            const SizedBox(height: 16),
            _lessonTip(m.behaviorScore),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_graph),
              label: const Text("Simulate Outcome"),
              onPressed: () {},
            ),
            TextButton.icon(
              icon: const Icon(Icons.visibility),
              onPressed: () {},
              label: const Text("Re-add to Watchlist"),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"))
        ],
      ),
    );
  }

  Widget _lessonTip(int score) {
    if (score < 40) {
      return const Text(
        "⚠️ Pattern: Frequent exits after volatility. Consider holding 5–7 days minimum unless fundamentals change.",
        style: TextStyle(fontSize: 13),
      );
    } else if (score < 70) {
      return const Text(
        "📊 Tip: Review exit triggers—were they based on news or short-term price action?",
        style: TextStyle(fontSize: 13),
      );
    } else {
      return const Text(
        "✅ Behavior score high. Keep monitoring token to re-enter on signal confirmation.",
        style: TextStyle(fontSize: 13),
      );
    }
  }
}

class MissedOpportunity {
  final String token;
  final double regretScore;
  final int removedDaysAgo;
  final double simulatedGain;
  final String exitReason;
  final int behaviorScore;

  MissedOpportunity({
    required this.token,
    required this.regretScore,
    required this.removedDaysAgo,
    required this.simulatedGain,
    required this.exitReason,
    required this.behaviorScore,
  });
}

class RegretDialPainter extends CustomPainter {
  final double score;
  RegretDialPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final angle = (score.clamp(0, 100) / 100) * 2 * pi;
    final basePaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final arcPaint = Paint()
      ..shader = SweepGradient(
        colors: [Colors.redAccent, Colors.orange, Colors.greenAccent],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
          center: size.center(Offset.zero), radius: size.width / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, basePaint);
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      angle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
