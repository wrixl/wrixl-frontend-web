// lib\main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrixl_frontend/utils/layout_provider.dart';

import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'theme/theme.dart';
import 'utils/layout_constants.dart';
import 'theme/layout_theme_extension.dart';

/// Global navigator key (if you need it elsewhere).
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = await ThemeProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider()),
        ChangeNotifierProvider<PortfolioProvider>(
            create: (_) => PortfolioProvider()),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutHelper = LayoutHelper.fromDimensions(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return LayoutProvider(
          layout: layoutHelper,
          child: MaterialApp(
            title: 'Wrixl',
            debugShowCheckedModeBanner: false,
            theme: WrixlTheme.lightTheme.copyWith(
              extensions: <ThemeExtension<dynamic>>[
                LayoutThemeExtension(layout: layoutHelper),
              ],
            ),
            darkTheme: WrixlTheme.darkTheme.copyWith(
              extensions: <ThemeExtension<dynamic>>[
                LayoutThemeExtension(layout: layoutHelper),
              ],
            ),
            themeMode: themeProvider.mode,
            navigatorKey: navigatorKey,
            home: const DashboardScreen(),
          ),
        );
      },
    );
  }
}
