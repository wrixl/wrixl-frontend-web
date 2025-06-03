// lib\widgets\screen_specific_widgets\current_widgets\stress_radar_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wrixl_frontend/widgets/common/new_reusable_modal.dart';

class StressRadarWidget extends StatefulWidget {
  const StressRadarWidget({super.key});

  @override
  State<StressRadarWidget> createState() => _StressRadarWidgetState();
}

class _StressRadarWidgetState extends State<StressRadarWidget> {
  final List<_RiskAxis> riskAxes = [
    _RiskAxis("Volatility", 0.85, Colors.red,
        "Your portfolio is highly volatile. Price swings are likely to trigger stopouts."),
    _RiskAxis("Leverage", 0.78, Colors.redAccent,
        "Leverage exposure is above safe levels. A drawdown could cause cascading loss."),
    _RiskAxis("Liquidity", 0.58, Colors.orange,
        "Several tokens show thin liquidity. Difficult exits if market dips."),
    _RiskAxis("Correlation", 0.66, Colors.orange,
        "Assets move in lockstep. Diversification is limited."),
    _RiskAxis("Concentration", 0.42, Colors.green,
        "Holdings are moderately concentrated in 2–3 assets."),
  ];

  void _showRiskModal() {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => NewWidgetModal(
        title: "Stress Profile: AI Risk Memo",
        size: WidgetModalSize.medium,
        onClose: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...riskAxes.map((axis) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: axis.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(axis.label,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: scheme.primary)),
                            Text(axis.detail,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: scheme.onSurface.withOpacity(0.8))),
                          ],
                        ),
                      ),
                      Text("${(axis.value * 100).toInt()}%",
                          style: TextStyle(
                              color: axis.color, fontWeight: FontWeight.bold))
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            Text("⚠️ Estimated Risk Summary",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              "High volatility and leverage detected. A 10% market drop could trigger up to 35% drawdown.",
              style: TextStyle(fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }

  List<RadarDataSet> _buildRadarLayers() {
    return [
      // Background Risk Zones
      RadarDataSet(
        fillColor: Colors.green.withOpacity(0.08),
        borderColor: Colors.transparent,
        entryRadius: 0,
        borderWidth: 0,
        dataEntries:
            List.generate(riskAxes.length, (_) => RadarEntry(value: 0.4)),
      ),
      RadarDataSet(
        fillColor: Colors.yellow.withOpacity(0.08),
        borderColor: Colors.transparent,
        entryRadius: 0,
        borderWidth: 0,
        dataEntries:
            List.generate(riskAxes.length, (_) => RadarEntry(value: 0.7)),
      ),
      RadarDataSet(
        fillColor: Colors.red.withOpacity(0.08),
        borderColor: Colors.transparent,
        entryRadius: 0,
        borderWidth: 0,
        dataEntries:
            List.generate(riskAxes.length, (_) => RadarEntry(value: 1.0)),
      ),
      // Actual Stress Data
      RadarDataSet(
        fillColor: Colors.redAccent.withOpacity(0.2),
        borderColor: Colors.redAccent,
        entryRadius: 3,
        borderWidth: 2.5,
        dataEntries: riskAxes.map((e) => RadarEntry(value: e.value)).toList(),
      ),
    ];
  }

  RadarChartData _buildRadarChartData() {
    return RadarChartData(
      radarTouchData: RadarTouchData(enabled: false),
      dataSets: _buildRadarLayers(),
      radarBackgroundColor: Colors.transparent,
      borderData: FlBorderData(show: false),
      radarBorderData: const BorderSide(color: Colors.transparent),
      titlePositionPercentageOffset: 0.14,
      titleTextStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      getTitle: (index, _) => RadarChartTitle(text: riskAxes[index].label),
      tickCount: 3,
      ticksTextStyle: const TextStyle(color: Colors.transparent),
      tickBorderData: BorderSide(color: Colors.grey.withOpacity(0.3)),
      gridBorderData:
          BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _showRiskModal,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: scheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stress Radar",
                          style: Theme.of(context).textTheme.titleMedium),
                      const Icon(Icons.warning_amber, color: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RadarChart(
                      _buildRadarChartData(),
                      swapAnimationDuration: const Duration(milliseconds: 400),
                      swapAnimationCurve: Curves.easeInOut,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "⚠️ Volatility and leverage dominate your risk profile.",
                    style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RiskAxis {
  final String label;
  final double value;
  final Color color;
  final String detail;

  _RiskAxis(this.label, this.value, this.color, this.detail);
}
