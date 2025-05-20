// lib\screens\dashboard\dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:wrixl_frontend/profile/user_profile.dart';
import '../../utils/responsive.dart';
import '../../widgets/sidebarx_navigation.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'portfolios_screen2.dart';
import 'market_intelligence.dart';
import 'activity_screen.dart';
import 'community_game_screen.dart';
import 'package:wrixl_frontend/screens/dashboard/legacy_widgets.dart';
import 'dashboard_screen2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SidebarXController _controller = SidebarXController(selectedIndex: 0);

  final List<Widget> _screens = [
    const DashboardScreen2(), // 0: New Dashboard
    const MarketIntelligenceScreen(), // 1: New Market Intelligence
    const PortfoliosScreen2(), // 2: New Portfolio
    const CommunityGameScreen(), // 3: New Community & Gamification
    const ActivityScreen(), // 4: New Activity & Alerts
    const LegacyWidgetsScreen(), // 5: New Legacy Widgets
    const UserProfileScreen(), // 6: Profile
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            Navigator.of(_scaffoldKey.currentContext!).pop();
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isMobile
          ? Drawer(
              child:
                  SidebarXNavigation(controller: _controller, isDrawer: true),
            )
          : null,
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _controller.selectedIndex,
              backgroundColor: AppConstants.primaryColor,
              selectedItemColor: AppConstants.accentColor,
              unselectedItemColor: AppConstants.secondaryTextColor,
              onTap: (index) => _controller.selectIndex(index),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard_customize), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined),
                    label: 'Intelligence'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart), label: 'Portfolio'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events), label: 'Community'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'Activity'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.widgets_outlined), label: 'Legacy'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) SidebarXNavigation(controller: _controller),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_controller.selectedIndex],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppConstants.accentColor,
        onPressed: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Feedback',
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const _FeedbackModal();
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              final curvedValue =
                  Curves.easeInOut.transform(animation.value) - 1.0;
              return Transform(
                transform:
                    Matrix4.translationValues(0.0, curvedValue * -50, 0.0),
                child: Opacity(
                  opacity: animation.value,
                  child: child,
                ),
              );
            },
          );
        },
        child: const Icon(Icons.feedback, color: Colors.black),
      ),
    );
  }
}

class _FeedbackModal extends StatelessWidget {
  const _FeedbackModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Feedback',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'What insights helped you today?',
                  hintStyle: theme.textTheme.bodyMedium,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
