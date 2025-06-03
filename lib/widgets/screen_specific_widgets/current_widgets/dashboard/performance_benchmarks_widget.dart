// lib\widgets\screen_specific_widgets\current_widgets\performance_benchmarks_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class PerformanceBenchmarksWidget extends StatefulWidget {
  const PerformanceBenchmarksWidget({super.key});

  @override
  State<PerformanceBenchmarksWidget> createState() =>
      _PerformanceBenchmarksWidgetState();
}

const labelColumnWidth = 120.0;
const barHeight = 10.0;
const columnsPerSide = 4;
const totalColumns = columnsPerSide * 2 + 1;

class _Benchmark {
  final String label;
  final double change;
  final bool isUser;

  const _Benchmark(this.label, this.change, {this.isUser = false});
}

class _PerformanceBenchmarksWidgetState
    extends State<PerformanceBenchmarksWidget>
    with SingleTickerProviderStateMixin {
  final List<String> _ranges = ['1D', '7D', '1M', '6M', '1Y'];
  int _rangeIndex = 0;
  late String _selectedRange;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _selectedRange = _ranges[_rangeIndex];
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cycleRange() {
    setState(() {
      _rangeIndex = (_rangeIndex + 1) % _ranges.length;
      _selectedRange = _ranges[_rangeIndex];
      _controller.forward(from: 0);
    });
  }

  void _openQuadModal() {
    final rawData = _mockData[_selectedRange]!;
    final you = rawData.firstWhere((b) => b.isUser);
    final sharpeRatios = {
      for (final b in rawData)
        b.label: b.isUser
            ? 1.0
            : (0.6 + Random(b.label.hashCode).nextDouble() * 0.8),
    };

    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: 'Performance vs Risk',
        size: WidgetModalSize.medium,
        onClose: () => Navigator.pop(context),
        child: Column(
          children: [
            const Text(
              'Performance vs Risk',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: CustomPaint(
                painter: _QuadChartPainter(
                  benchmarks: rawData,
                  you: you,
                  sharpeRatios: sharpeRatios,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '🧠 AI Insight: Focus on assets in the upper-right quadrant — strong returns with acceptable risk. Avoid bottom-left assets with both high risk and low returns.',
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawData = _mockData[_selectedRange]!;
    final you = rawData.firstWhere((b) => b.isUser);
    final normalized = rawData
        .map(
            (b) => _Benchmark(b.label, b.change - you.change, isUser: b.isUser))
        .toList()
      ..sort((a, b) => b.change.compareTo(a.change));
    final maxAbs = normalized.map((b) => b.change.abs()).reduce(max);
    final step = maxAbs / columnsPerSide;
    final percentLabels = List.generate(totalColumns, (i) {
      final relative = (i - columnsPerSide) * step;
      return "${relative >= 0 ? '+' : ''}${relative.toStringAsFixed(1)}%";
    });

    return GestureDetector(
      onTap: _openQuadModal,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Relative Performance (vs You)',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Tooltip(
                    message: 'Cycle range ($_selectedRange)',
                    child: IconButton(
                      icon: const Icon(Icons.schedule),
                      onPressed: _cycleRange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: List.generate(totalColumns, (i) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        percentLabels[i],
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GridLinePainter(),
                    ),
                  ),
                  Column(
                    children: normalized.map((b) {
                      final ratio =
                          maxAbs == 0 ? 0.0 : (b.change.abs() / maxAbs);
                      final isPositive = b.change > 0;
                      final blockSpan = (ratio * columnsPerSide).ceil();
                      final color = b.isUser
                          ? Colors.blue
                          : isPositive
                              ? Colors.green
                              : Colors.redAccent;
                      final rowCells = List<Widget>.generate(
                        totalColumns,
                        (_) => const Expanded(child: SizedBox()),
                      );
                      if (isPositive) {
                        for (int i = columnsPerSide + 1;
                            i <= columnsPerSide + blockSpan && i < totalColumns;
                            i++) {
                          rowCells[i] = Expanded(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (_, __) => FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _controller.value,
                                child: Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      } else {
                        for (int i = columnsPerSide - 1;
                            i >= columnsPerSide - blockSpan && i >= 0;
                            i--) {
                          rowCells[i] = Expanded(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (_, __) => FractionallySizedBox(
                                alignment: Alignment.centerRight,
                                widthFactor: _controller.value,
                                child: Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }
                      rowCells[columnsPerSide] = SizedBox(
                        width: labelColumnWidth,
                        child: Center(
                          child: Text(
                            b.label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: b.isUser
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: b.isUser ? Colors.blue : null,
                            ),
                          ),
                        ),
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(children: rowCells),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  final Map<String, List<_Benchmark>> _mockData = {
    '1D': [
      const _Benchmark('BTC', 0.4),
      const _Benchmark('ETH', 0.2),
      const _Benchmark('S&P500', -0.1),
      const _Benchmark('NASDAQ', 0.0),
      const _Benchmark('Gold', -0.2),
      const _Benchmark('NFTs', -0.5),
      const _Benchmark('L1 Coins', 0.3),
      const _Benchmark('Memes', 0.8),
      const _Benchmark('AI Tokens', 0.6),
      const _Benchmark('DeFi', 0.1),
      const _Benchmark('AVG Wrixler', 1.2),
      const _Benchmark('You', 0.6, isUser: true),
    ],
    '7D': [
      const _Benchmark('BTC', 1.2),
      const _Benchmark('ETH', 0.7),
      const _Benchmark('S&P500', -0.4),
      const _Benchmark('NASDAQ', -0.7),
      const _Benchmark('Gold', 0.2),
      const _Benchmark('NFTs', -3.6),
      const _Benchmark('L1 Coins', 0.9),
      const _Benchmark('Memes', 4.2),
      const _Benchmark('AI Tokens', 1.8),
      const _Benchmark('DeFi', 0.5),
      const _Benchmark('AVG Wrixler', 3.4),
      const _Benchmark('You', 2.5, isUser: true),
    ],
    '1M': [
      const _Benchmark('BTC', 6.1),
      const _Benchmark('ETH', 4.8),
      const _Benchmark('S&P500', 2.1),
      const _Benchmark('NASDAQ', 1.6),
      const _Benchmark('Gold', 0.9),
      const _Benchmark('NFTs', -1.2),
      const _Benchmark('L1 Coins', 5.0),
      const _Benchmark('Memes', 8.4),
      const _Benchmark('AI Tokens', 7.1),
      const _Benchmark('DeFi', 3.2),
      const _Benchmark('AVG Wrixler', 5.6),
      const _Benchmark('You', 4.0, isUser: true),
    ],
    '6M': [
      const _Benchmark('BTC', 28.2),
      const _Benchmark('ETH', 19.5),
      const _Benchmark('S&P500', 7.8),
      const _Benchmark('NASDAQ', 5.3),
      const _Benchmark('Gold', 2.6),
      const _Benchmark('NFTs', -4.9),
      const _Benchmark('L1 Coins', 17.0),
      const _Benchmark('Memes', 41.2),
      const _Benchmark('AI Tokens', 33.5),
      const _Benchmark('DeFi', 9.0),
      const _Benchmark('AVG Wrixler', 22.1),
      const _Benchmark('You', 19.0, isUser: true),
    ],
    '1Y': [
      const _Benchmark('BTC', 62.1),
      const _Benchmark('ETH', 48.3),
      const _Benchmark('S&P500', 15.4),
      const _Benchmark('NASDAQ', 12.2),
      const _Benchmark('Gold', 8.9),
      const _Benchmark('NFTs', -8.3),
      const _Benchmark('L1 Coins', 51.0),
      const _Benchmark('Memes', 94.8),
      const _Benchmark('AI Tokens', 88.1),
      const _Benchmark('DeFi', 26.3),
      const _Benchmark('AVG Wrixler', 66.7),
      const _Benchmark('You', 54.3, isUser: true),
    ],
  };
}

class _QuadChartPainter extends CustomPainter {
  final List<_Benchmark> benchmarks;
  final _Benchmark you;
  final Map<String, double> sharpeRatios;

  _QuadChartPainter({
    required this.benchmarks,
    required this.you,
    required this.sharpeRatios,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Stronger axis paint for black backgrounds
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5;

    // Draw axes
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);
    canvas.drawLine(
        Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);

    // Quadrant shading (brighter for dark theme)
    final paintQ = Paint()..style = PaintingStyle.fill;

    paintQ.color = Colors.greenAccent.withOpacity(0.08);
    canvas.drawRect(
        Rect.fromLTRB(center.dx, 0, size.width, center.dy), paintQ); // Q1

    paintQ.color = Colors.yellowAccent.withOpacity(0.06);
    canvas.drawRect(
        Rect.fromLTRB(center.dx, center.dy, size.width, size.height),
        paintQ); // Q4

    paintQ.color = Colors.orangeAccent.withOpacity(0.05);
    canvas.drawRect(
        Rect.fromLTRB(0, center.dy, center.dx, size.height), paintQ); // Q3

    paintQ.color = Colors.redAccent.withOpacity(0.06);
    canvas.drawRect(Rect.fromLTRB(0, 0, center.dx, center.dy), paintQ); // Q2

    final maxPerfDelta = benchmarks
        .map((b) => (b.change - you.change).abs())
        .fold<double>(0.1, max);
    final maxSharpeDelta = benchmarks
        .map((b) => (sharpeRatios[b.label]! - sharpeRatios[you.label]!).abs())
        .fold<double>(0.1, max);

    final tp = TextPainter(textDirection: TextDirection.ltr);
    const labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      shadows: [
        Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1)),
      ],
    );

    for (final b in benchmarks) {
      final dx = ((sharpeRatios[b.label]! - sharpeRatios[you.label]!) /
              maxSharpeDelta) *
          (size.width / 2 - 40);
      final dy =
          -((b.change - you.change) / maxPerfDelta) * (size.height / 2 - 40);
      final pt = center.translate(dx, dy);

      final dotPaint = Paint()
        ..color = b.isUser ? Colors.blueAccent : Colors.white
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(pt, b.isUser ? 6 : 5, dotPaint);
      canvas.drawCircle(
          pt, b.isUser ? 6 : 5, borderPaint); // border for contrast

      tp.text = TextSpan(
        text: b.label,
        style: labelStyle.copyWith(
          fontWeight: b.isUser ? FontWeight.bold : FontWeight.w500,
          color: b.isUser ? Colors.blueAccent : Colors.white,
        ),
      );
      tp.layout();
      tp.paint(canvas, pt.translate(6, -6));
    }

    // Draw "You" label at center
    tp.text = const TextSpan(
      text: 'You',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
        shadows: [
          Shadow(blurRadius: 5, color: Colors.white, offset: Offset(0, 0)),
          Shadow(blurRadius: 8, color: Colors.blue, offset: Offset(0, 0)),
        ],
      ),
    );
    tp.layout();
    tp.paint(canvas, center.translate(8, -8));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _GridLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;
    final colW = size.width / totalColumns;
    for (int i = 0; i <= totalColumns; i++) {
      final x = colW * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
