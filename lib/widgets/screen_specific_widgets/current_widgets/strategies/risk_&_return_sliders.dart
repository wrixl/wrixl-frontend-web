// lib\widgets\screen_specific_widgets\current_widgets\strategies\risk_&_return_sliders.dart

import 'package:flutter/material.dart';

class RiskReturnSliders extends StatefulWidget {
  final void Function(double sharpe, double cagr, double drawdown, double concentration)? onChanged;

  const RiskReturnSliders({super.key, this.onChanged});

  @override
  State<RiskReturnSliders> createState() => _RiskReturnSlidersState();
}

class _RiskReturnSlidersState extends State<RiskReturnSliders> {
  double _sharpe = 1.0;
  double _cagr = 15.0;
  double _drawdown = 20.0;
  double _concentration = 25.0;

  void _handleChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(_sharpe, _cagr, _drawdown, _concentration);
    }
  }

  Widget _buildSlider({
    required String title,
    required String labelStart,
    required String labelEnd,
    required double value,
    required double min,
    required double max,
    required String tooltip,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltip,
              child: const Icon(Icons.info_outline, size: 16, color: Colors.grey),
            )
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(labelStart, style: const TextStyle(color: Colors.grey)),
            Text(labelEnd, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Slider(
          value: value,
          onChanged: (val) {
            onChanged(val);
            _handleChange();
          },
          min: min,
          max: max,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
      elevation: 3,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Risk & Return Sliders", style: theme.textTheme.titleMedium),
                const Icon(Icons.tune, color: Colors.indigo),
              ],
            ),
            const SizedBox(height: 16),
            _buildSlider(
              title: "Risk Appetite (Sharpe)",
              labelStart: "Low (0.5)",
              labelEnd: "High (2.0)",
              value: _sharpe,
              min: 0.5,
              max: 2.0,
              tooltip: "Higher Sharpe Ratio = better risk-adjusted return.",
              onChanged: (val) => setState(() => _sharpe = val),
            ),
            _buildSlider(
              title: "Target Return (CAGR %)",
              labelStart: "5%",
              labelEnd: "40%",
              value: _cagr,
              min: 5,
              max: 40,
              tooltip: "Compound Annual Growth Rate you're targeting.",
              onChanged: (val) => setState(() => _cagr = val),
            ),
            _buildSlider(
              title: "Max Drawdown Tolerance (%)",
              labelStart: "5%",
              labelEnd: "60%",
              value: _drawdown,
              min: 5,
              max: 60,
              tooltip: "Largest acceptable loss from peak to trough.",
              onChanged: (val) => setState(() => _drawdown = val),
            ),
            _buildSlider(
              title: "Allocation Concentration (%)",
              labelStart: "Equal-Weight",
              labelEnd: "Concentrated",
              value: _concentration,
              min: 5,
              max: 50,
              tooltip: "Max allocation any single asset can have.",
              onChanged: (val) => setState(() => _concentration = val),
            ),
          ],
        ),
      ),
    );
  }
}
