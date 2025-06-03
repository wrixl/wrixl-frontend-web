// lib\main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/portfolio_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/main_app_screens/dashboard_screen.dart';
import 'theme/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    debugPrint('🐛 Caught Flutter error: ${details.exception}');
  };

  final themeProvider = await ThemeProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
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

    return MaterialApp(
      title: 'Wrixl',
      debugShowCheckedModeBanner: false,
      theme: WrixlTheme.lightTheme,
      darkTheme: WrixlTheme.darkTheme,
      themeMode: themeProvider.mode,
      navigatorKey: navigatorKey,
      home: const DashboardScreen(),
    );
  }
}
