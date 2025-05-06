// lib\widgets\sidebarx_navigation.dart

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import '../utils/constants.dart';

class SidebarXNavigation extends StatelessWidget {
  final SidebarXController controller;
  final bool isDrawer;

  const SidebarXNavigation({
    super.key,
    required this.controller,
    this.isDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExtended = controller.extended;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(80),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          // ── Logo at the top ────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                Icon(Icons.auto_awesome, color: AppConstants.accentColor),
                if (isExtended) ...[
                  const SizedBox(width: 8),
                  Text(
                    'Wrixl',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ]
              ],
            ),
          ),

          // ── Sidebar Items ──────────────────────────
          Expanded(
            child: SidebarX(
              controller: controller,
              theme: SidebarXTheme(
                width: 60,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                textStyle: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                ),
                selectedTextStyle: theme.textTheme.labelLarge?.copyWith(
                  color: AppConstants.accentColor,
                  fontWeight: FontWeight.bold,
                ),
                itemDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                selectedItemDecoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(100),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                iconTheme: IconThemeData(
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                  size: 24,
                ),
                selectedIconTheme: const IconThemeData(
                  color: AppConstants.accentColor,
                  size: 28,
                ),
              ),
              extendedTheme: const SidebarXTheme(
                width: 220,
                itemPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                selectedItemTextPadding: EdgeInsets.only(left: 16),
              ),
              items: const [
                SidebarXItem(icon: Icons.dashboard, label: 'Dashboard'),
                SidebarXItem(icon: Icons.attach_money, label: 'Smart \$'),
                SidebarXItem(icon: Icons.insights, label: 'Insights'),
                SidebarXItem(icon: Icons.signal_cellular_alt, label: 'Signals'),
                SidebarXItem(icon: Icons.pie_chart, label: 'Portfolios'),
              ],
            ),
          ),

          // ── Profile Button at Bottom ────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              onPressed: () => controller.selectIndex(5),
              tooltip: 'Profile',
              icon: const CircleAvatar(
                backgroundColor: AppConstants.accentColor,
                radius: 20,
                child: Icon(Icons.person, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
