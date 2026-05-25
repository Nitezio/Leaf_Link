import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final isCompactHeight = constraints.maxHeight < 700;
          final heroHeight = (constraints.maxHeight * 0.45).clamp(180.0, 420.0);

          final hero =
              _heroImage(height: isWide ? constraints.maxHeight : heroHeight);
          final content = welcomeContent(
            onGetStarted: onGetStarted,
            centerAligned: !isWide,
            denseLayout: isCompactHeight,
          );

          Widget layout;
          if (isWide) {
            layout = Row(
              children: [
                Expanded(child: hero),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: content,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            layout = SingleChildScrollView(
              child: Column(
                children: [
                  hero,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: content,
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Background blobs
              Positioned(
                top: -100,
                left: -100,
                child: _blob(300, AppColors.secondary.withValues(alpha: 0.2)),
              ),
              Positioned(
                bottom: -50,
                right: -80,
                child: _blob(280, AppColors.primary.withValues(alpha: 0.1)),
              ),
              SafeArea(bottom: false, child: layout),
            ],
          );
        },
      ),
    );
  }

  Widget _heroImage({required double height}) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1612366206518-535bea7db163?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.chart4,
              child: const Icon(Icons.eco, size: 80, color: Colors.white),
            ),
          ),
          // Gradient fade into background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.6),
                  AppColors.background,
                ],
                stops: const [0.5, 0.8, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeContent({
    required VoidCallback onGetStarted,
    required bool centerAligned,
    required bool denseLayout,
  }) {
    final textAlign = centerAligned ? TextAlign.center : TextAlign.left;
    final crossAxis =
        centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxis,
        children: [
          const SizedBox(height: 8),
          Align(
            alignment: centerAligned ? Alignment.center : Alignment.centerLeft,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.eco_rounded, size: 44, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          RichText(
            textAlign: textAlign,
            text: const TextSpan(
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: AppColors.foreground,
              ),
              children: [
                TextSpan(text: 'Your Plants,\n'),
                TextSpan(
                  text: 'Thriving Together',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Smart care, AI insights, and a community\nof plant lovers',
            textAlign: textAlign,
            style: const TextStyle(
              color: AppColors.mutedForeground,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: denseLayout ? 20 : 28),

          // Feature bullets
          _feature('🌿', 'Track every plant\'s journey'),
          const SizedBox(height: 14),
          _feature('💧', 'Weather-smart watering alerts'),
          const SizedBox(height: 14),
          _feature('🔬', 'AI disease detection & treatment'),

          SizedBox(height: denseLayout ? 16 : 24),

          // CTA
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onGetStarted,
              icon: const Text(
                'Get Started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              label: const Icon(Icons.arrow_forward_rounded, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Page indicators
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                _dot(),
                const SizedBox(width: 6),
                _dot(),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _feature(String emoji, String text) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child:
              Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.muted,
        shape: BoxShape.circle,
      ),
    );
  }
}

