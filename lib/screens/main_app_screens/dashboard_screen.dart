// lib\screens\dashboard\dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:wrixl_frontend/profile/user_profile.dart';
import 'package:wrixl_frontend/screens/main_app_screens/market_intelligence2.dart' show MarketIntelligenceScreen2;
import '../../utils/responsive.dart';
import '../../widgets/sidebarx_navigation.dart';
import 'package:wrixl_frontend/utils/constants.dart';
import 'strategies_screen.dart';
import 'market_intelligence.dart';
import 'activity_screen.dart';
import 'community_game_screen.dart';
import 'dashboard_screen2.dart';
import 'my_positions_screen.dart';

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
    const StrategiesScreen(), // 2: New Portfolio
    const MyPositionsScreen(), // 3: My Positions [💡 newly added]
    const CommunityGameScreen(), // 4: New Community & Gamification
    const ActivityScreen(), // 5: New Activity & Alerts
    const UserProfileScreen(), // 6: Profile
    const MarketIntelligenceScreen2(), // 6: Intelligence2
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
                    icon: Icon(Icons.dashboard_customize),
                    label: 'Dashboard'), // 0
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined),
                    label: 'Intelligence'), // 1
                BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart), label: 'Portfolio'), // 2
                BottomNavigationBarItem(
                    icon: Icon(Icons.layers), label: 'Strategies'), // 3
                BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events), label: 'Community'), // 4
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'Activity'), // 5
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'), // 6
                BottomNavigationBarItem(
                    icon: Icon(Icons.square), label: 'Intelligence2'), // 7
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
