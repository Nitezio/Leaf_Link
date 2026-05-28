import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/firebase_service.dart';
import 'models/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables (local .env is gitignored)
  await dotenv.load(fileName: '.env');

  final geminiKey = dotenv.env['GEMINI_API_KEY'];
  if (geminiKey == null || geminiKey.isEmpty) {
    // Warn but continue — some flows may not require Gemini at runtime.
    debugPrint('Warning: GEMINI_API_KEY not set in .env');
  }

  final firebaseReady = await FirebaseService.init();
  if (!firebaseReady) {
    debugPrint('Warning: Firebase unavailable. App will continue in local mode.');
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
      darkTheme: AppTheme.darkTheme,
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
      return HomeScreen();
    }
    if (_showLogin) {
      return LoginScreen();
    }
    return WelcomeScreen(
      onGetStarted: () => setState(() {
        _showLogin = true;
      }),
    );
  }
}
