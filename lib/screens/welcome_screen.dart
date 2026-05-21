import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      body: Stack(
        children: [
          // Background gradient blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.weatherRain.withValues(alpha: 0.2),
                    Colors.cyan.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Hero Image
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1612366206518-535bea7db163?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              AppColors.card.withValues(alpha: 0.9),
                              AppColors.card,
                            ],
                            stops: const [0.0, 0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content Section
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [AppColors.secondary, AppColors.primary],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(LucideIcons.leaf, size: 36, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        // Title
                        Text(
                          'Welcome to',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.foreground),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ).createShader(bounds),
                          child: Text(
                            'PlantCare Pro',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your smart companion for nurturing\nhealthier, happier plants',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: 32),
                        // Features
                        _buildFeature(context, '🌱', 'Track and manage all your plants'),
                        const SizedBox(height: 12),
                        _buildFeature(context, '💧', 'Smart watering reminders'),
                        const SizedBox(height: 12),
                        _buildFeature(context, '🩺', 'AI-powered plant health detection'),
                        const Spacer(),
                        // Get Started Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              SizedBox(width: 8),
                              Icon(LucideIcons.arrowRight, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 32,
                              height: 6,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(3)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(BuildContext context, String emoji, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedForeground)),
        ),
      ],
    );
  }
}
