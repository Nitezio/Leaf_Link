import 'package:flutter/material.dart';
import 'core/theme/app_typography.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTypography.theme,
      home: const WelcomeScreen(),
    );
  }
}
