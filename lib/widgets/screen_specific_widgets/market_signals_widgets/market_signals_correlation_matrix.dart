// lib/widgets/screen_specific_widgets/market_signals_widgets/market_signals_correlation_matrix.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/widgets/toggle_filter_icon_row_widget.dart';

class CorrelationMatrixWidget extends StatefulWidget {
  final List<String> labels;
  final List<List<double>> matrix;
  final String title;

  const CorrelationMatrixWidget({
    Key? key,
    required this.labels,
    required this.matrix,
    this.title = "Correlation Matrix",
  }) : super(key: key);

  @override
  State<CorrelationMatrixWidget> createState() => _CorrelationMatrixWidgetState();
}

class _CorrelationMatrixWidgetState extends State<CorrelationMatrixWidget> {
  String _selectedView = "Sectors";

  final List<String> toggleOptions = ["Sectors", "Tokens"];
  final Map<String, IconData> toggleIcons = {
    "Sectors": Icons.account_tree,
    "Tokens": Icons.token,
  };

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
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    final primary = theme.colorScheme.primary;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title and options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: onSurface),
                    onPressed: _showOptionsModal,
                    tooltip: "Options",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              /// Toggle filter and AI Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ToggleFilterIconRowWidget(
                      options: toggleOptions,
                      optionIcons: toggleIcons,
                      activeOption: _selectedView,
                      onSelected: (val) {
                        setState(() {
                          _selectedView = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Correlation hot zones reveal concentrated risk or opportunity across $_selectedView.",
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              /// Matrix table
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
        decoration: BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.1)),
        children: [
          Container(),
          for (final label in widget.labels)
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: labelStyle,
              ),
            ),
        ],
      )
    ];

    for (int i = 0; i < widget.labels.length; i++) {
      final rowCells = <Widget>[Container(
        width: 100,
        padding: const EdgeInsets.all(6),
        color: theme.colorScheme.surface.withOpacity(0.1),
        child: Text(
          widget.labels[i],
          style: labelStyle,
        ),
      )];

      for (int j = 0; j < widget.labels.length; j++) {
        final value = widget.matrix[i][j];
        final isDiagonal = i == j;

        rowCells.add(GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Correlation Detail"),
              content: Text("${widget.labels[i]} vs ${widget.labels[j]}\nCorrelation: ${value.toStringAsFixed(2)}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                )
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
                color: isDiagonal || value.abs() > 0.5 ? Colors.white : Colors.black,
              ),
            ),
          ),
        ));
      }

      rows.add(TableRow(children: rowCells));
    }

    return rows;
  }

  Color _valueToColor(BuildContext context, double value, {bool isDiagonal = false}) {
    final theme = Theme.of(context);
    if (isDiagonal) return theme.colorScheme.surface;
    if (value >= 0.75) return Colors.green.shade900;
    if (value >= 0.25) return Colors.green.shade400;
    if (value > -0.25) return Colors.grey.shade400;
    if (value > -0.75) return Colors.red.shade400;
    return Colors.red.shade900;
  }
}