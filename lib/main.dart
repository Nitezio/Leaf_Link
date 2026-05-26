import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // If Firebase initialization fails (missing platform files), continue
    // so the app remains usable in prototype mode.
    // Log the error in debug builds.
    // ignore: avoid_print
    print('Firebase.initializeApp() failed: $e');
  }

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
      darkTheme: AppTheme.theme,
      themeMode: context.select((AppState s) => s.isDarkMode ? ThemeMode.dark : ThemeMode.light),
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
  bool _showLogin = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (state.isLoggedIn) {
      return const HomeScreen();
    }
    if (_showLogin) {
      return const LoginScreen();
    }
    return WelcomeScreen(
      onGetStarted: () => setState(() {
        _showLogin = true;
      }),
    );
  }
}
