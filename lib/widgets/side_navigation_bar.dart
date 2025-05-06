// lib\widgets\side_navigation_bar.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../theme/theme.dart';

class SideNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SideNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
      labelType: NavigationRailLabelType.selected,
      backgroundColor: AppConstants.primaryColor,
      selectedIconTheme: const IconThemeData(
        color: AppConstants.accentColor,
        size: 30,
      ),
      unselectedIconTheme: const IconThemeData(
        color: AppConstants.secondaryTextColor,
        size: 24,
      ),
      selectedLabelTextStyle: const TextStyle(
        fontFamily: 'Rajdhani',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppConstants.accentColor,
      ),
      unselectedLabelTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: AppConstants.secondaryTextColor,
      ),
      destinations: [
        NavigationRailDestination(
          icon: _buildNavIcon(Icons.dashboard, 0),
          label: const Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: _buildNavIcon(Icons.insights, 1),
          label: const Text('Insights'),
        ),
        NavigationRailDestination(
          icon: _buildNavIcon(Icons.signal_cellular_alt, 2),
          label: const Text('Signals'),
        ),
        NavigationRailDestination(
          icon: _buildNavIcon(Icons.pie_chart, 3),
          label: const Text('Portfolios'),
        ),
      ],
    );
  }

  Widget _buildNavIcon(IconData iconData, int index) {
    bool isSelected = widget.selectedIndex == index;
    return MouseRegion(
      // Optionally add onEnter/onExit to update a local hover state
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: isSelected ? WrixlTheme.getHoverGlow(AppConstants.accentColor) : null,
        child: Icon(iconData),
      ),
    );
  }
}
