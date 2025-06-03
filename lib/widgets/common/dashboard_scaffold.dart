// lib\widgets\common\dashboard_scaffold.dart

import 'package:flutter/material.dart';

class DashboardScaffold extends StatelessWidget {
  final String title;
  final List<String> presets;
  final String selectedPreset;
  final bool isEditing;
  final ValueChanged<String> onPresetChanged;
  final VoidCallback onToggleEditing;
  final VoidCallback? onReset;
  final Widget child;

  /// allows custom widgets to appear before layout toggle
  final List<Widget>? leadingActions;

  const DashboardScaffold({
    required this.title,
    required this.presets,
    required this.selectedPreset,
    required this.isEditing,
    required this.onPresetChanged,
    required this.onToggleEditing,
    required this.child,
    this.onReset,
    this.leadingActions, // 🔥 NEW
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          // Any custom widgets before layout toggle
          if (leadingActions != null) ...leadingActions!,

          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPreset,
                dropdownColor: colorScheme.surface,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                iconEnabledColor: colorScheme.onSurface,
                onChanged: (val) {
                  if (val != null) onPresetChanged(val);
                },
                items: presets.map((p) {
                  return DropdownMenuItem<String>(
                    value: p,
                    child: Text(p),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(isEditing ? Icons.lock_open : Icons.lock),
            tooltip: isEditing ? "Lock Layout" : "Unlock Layout",
            onPressed: onToggleEditing,
            color: colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: child,
    );
  }
}
