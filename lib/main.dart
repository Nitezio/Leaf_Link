import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const PlantCareApp(),
    ),
  );
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _RootNavigator(),
    );
  }
}

/// Handles the Welcome → Login → Home navigation flow
class _RootNavigator extends StatefulWidget {
  const _RootNavigator();

  @override
  State<_RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<_RootNavigator> {
  bool _showWelcome = true;
  bool _showLogin = false;
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return const HomeScreen();
    }
    if (_showLogin) {
      return LoginScreen(
        onLogin: () => setState(() => _isLoggedIn = true),
      );
    }
    return WelcomeScreen(
      onGetStarted: () => setState(() {
        _showWelcome = false;
        _showLogin = true;
      }),
    );
  }
}
