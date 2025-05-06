// lib/widgets/toggle_filter_icon_row_widget.dart

import 'package:flutter/material.dart';
import 'package:wrixl_frontend/utils/constants.dart';

/// A generic, stylized icon row toggle filter widget.
///
/// The parent widget provides the list of options, matching icons,
/// the currently active option, and a callback when the user selects an option.
class ToggleFilterIconRowWidget extends StatelessWidget {
  final List<String> options;
  final Map<String, IconData> optionIcons;
  final String activeOption;
  final ValueChanged<String> onSelected;

  const ToggleFilterIconRowWidget({
    Key? key,
    required this.options,
    required this.optionIcons,
    required this.activeOption,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: IconButton(
                onPressed: () => onSelected(option),
                icon: Icon(
                  optionIcons[option],
                  color: activeOption == option
                      ? AppConstants.accentColor
                      : AppConstants.secondaryTextColor.withOpacity(0.6),
                  size: 20,
                ),
                tooltip: option.toUpperCase(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
