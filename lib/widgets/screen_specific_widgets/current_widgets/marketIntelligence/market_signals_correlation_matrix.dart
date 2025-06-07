// lib/widgets/screen_specific_widgets/market_signals_widgets/market_signals_correlation_matrix.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class CorrelationMatrixWidget extends StatefulWidget {
  final List<String>? labels;
  final List<List<double>>? matrix;
  final String title;

  const CorrelationMatrixWidget({
    Key? key,
    this.labels,
    this.matrix,
    this.title = "Correlation Matrix",
  }) : super(key: key);

  @override
  State<CorrelationMatrixWidget> createState() =>
      _CorrelationMatrixWidgetState();
}

class _CorrelationMatrixWidgetState extends State<CorrelationMatrixWidget> {
  String _selectedView = "Sectors";

  final List<String> toggleOptions = ["Sectors", "Tokens"];
  final Map<String, IconData> toggleIcons = {
    "Sectors": Icons.account_tree,
    "Tokens": Icons.token,
  };

  late final List<String> _labels;
  late final List<List<double>> _matrix;

  @override
  void initState() {
    super.initState();
    _labels = widget.labels ??
        [
          "DeFi",
          "Layer 1",
          "Meme Coins",
          "NFT",
          "AI",
          "BTC",
          "ETH",
          "Gold",
          "S&P 500",
          "NASDAQ"
        ];
    _matrix = widget.matrix ??
        [
          [1.00, 0.45, 0.30, 0.35, 0.25, 0.60, 0.55, -0.60, -0.95, 0.00],
          [0.45, 1.00, 0.50, 0.40, 0.80, 0.55, 0.60, -0.05, 0.00, 0.05],
          [0.30, 0.50, 1.00, 0.45, 0.35, 0.40, 0.45, -0.70, -0.05, 0.00],
          [0.35, 0.40, 0.45, 1.00, 0.55, 0.50, 0.45, -0.405, 0.00, 0.05],
          [0.25, 0.30, 0.35, 0.55, 1.00, 0.40, 0.35, -0.10, 0.05, 0.00],
          [0.60, 0.55, 0.40, 0.50, 0.40, 1.00, 0.85, -0.05, -0.10, -0.05],
          [0.55, 0.60, 0.45, 0.45, 0.35, 0.85, 1.00, 0.40, -0.75, 0.00],
          [-0.30, -0.05, -0.10, -0.45, -0.70, -0.05, 0.00, 1.00, 0.60, 0.25],
          [-0.50, 0.00, -0.05, 0.00, 0.05, -0.40, -0.05, 0.20, 1.00, 0.85],
          [0.10, 0.05, 0.03, 0.45, 0.00, -0.65, 0.00, 0.25, -0.85, 1.00],
        ];
  }

  void _showOptionsModal() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Correlation Matrix Options",
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Customize matrix metrics, highlight thresholds, or export.",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: scheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🌟 Updated App Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showOptionsModal,
                  tooltip: "Options",
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🌟 Updated Subtitle Row
            Row(
              children: [
                ToggleFilterIconRowWidget(
                  options: toggleOptions,
                  optionIcons: toggleIcons,
                  activeOption: _selectedView,
                  onSelected: (val) => setState(() => _selectedView = val),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    "Correlation hot zones reveal clustered risk and hidden signal across $_selectedView.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: scheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Table and rest unchanged...
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(120),
                border: TableBorder.all(
                  color: theme.dividerColor,
                  width: 0.5,
                ),
                children: _buildTableRows(context),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }

  List<TableRow> _buildTableRows(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.secondary,
    );

    final rows = <TableRow>[
      TableRow(
        decoration:
            BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.1)),
        children: [
          Container(),
          for (final label in _labels)
            Padding(
              padding: const EdgeInsets.all(6),
              child:
                  Text(label, textAlign: TextAlign.center, style: labelStyle),
            ),
        ],
      )
    ];

    for (int i = 0; i < _labels.length; i++) {
      final rowCells = <Widget>[
        Container(
          width: 100,
          padding: const EdgeInsets.all(6),
          color: theme.colorScheme.surface.withOpacity(0.1),
          child: Text(_labels[i], style: labelStyle),
        )
      ];

      for (int j = 0; j < _labels.length; j++) {
        final value = _matrix[i][j];
        final isDiagonal = i == j;

        rowCells.add(GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Correlation Detail"),
              content: Text(
                  "${_labels[i]} vs ${_labels[j]}\nCorrelation: ${value.toStringAsFixed(2)}"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"))
              ],
            ),
          ),
          child: Container(
            height: 18,
            alignment: Alignment.center,
            color: _valueToColor(context, value, isDiagonal: isDiagonal),
            child: Text(
              value.toStringAsFixed(2),
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDiagonal || value.abs() > 0.5
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ));
      }

      rows.add(TableRow(children: rowCells));
    }

    return rows;
  }

  Color _valueToColor(BuildContext context, double value,
      {bool isDiagonal = false}) {
    final theme = Theme.of(context);
    if (isDiagonal) return theme.colorScheme.surface;
    if (value >= 0.75) return Colors.green.shade900;
    if (value >= 0.25) return Colors.green.shade400;
    if (value > -0.25) return Colors.grey.shade400;
    if (value > -0.75) return Colors.red.shade400;
    return Colors.red.shade900;
  }
}
