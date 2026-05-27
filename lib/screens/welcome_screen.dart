import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  WelcomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final isCompactHeight = constraints.maxHeight < 700;
          final heroHeight = (constraints.maxHeight * 0.45).clamp(180.0, 420.0);

          final hero = _heroImage(
            context,
            height: isWide ? constraints.maxHeight : heroHeight,
          );
          final content = welcomeContent(
            context,
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
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 520),
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
                    padding: EdgeInsets.only(bottom: 12),
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

  Widget _heroImage(BuildContext context, {required double height}) {
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
              child: Icon(Icons.eco, size: 80, color: Colors.white),
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
                  Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                stops: [0.5, 0.8, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeContent(
    BuildContext context, {
    required VoidCallback onGetStarted,
    required bool centerAligned,
    required bool denseLayout,
  }) {
    final textAlign = centerAligned ? TextAlign.center : TextAlign.left;
    final crossAxis =
        centerAligned ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxis,
        children: [
          SizedBox(height: 8),
          Align(
            alignment: centerAligned ? Alignment.center : Alignment.centerLeft,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child:
                  Icon(Icons.eco_rounded, size: 44, color: Colors.white),
            ),
          ),
          SizedBox(height: 24),

          // Title
          RichText(
            textAlign: textAlign,
            text: TextSpan(
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: Theme.of(context).colorScheme.onSurface,
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
          SizedBox(height: 12),
          Text(
            'Smart care, AI insights, and a community\nof plant lovers',
            textAlign: textAlign,
            style: TextStyle(
              color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: denseLayout ? 20 : 28),

          // Feature bullets
          _feature(context, '🌿', 'Track every plant\'s journey'),
          SizedBox(height: 14),
          _feature(context, '💧', 'Weather-smart watering alerts'),
          SizedBox(height: 14),
          _feature(context, '🔬', 'AI disease detection & treatment'),

          SizedBox(height: denseLayout ? 16 : 24),

          // CTA
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onGetStarted,
              icon: Text(
                'Get Started',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              label: Icon(Icons.arrow_forward_rounded, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          SizedBox(height: 20),

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
                SizedBox(width: 6),
                _dot(context),
                SizedBox(width: 6),
                _dot(context),
              ],
            ),
          ),
          SizedBox(height: 32),
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

  Widget _feature(BuildContext context, String emoji, String text) {
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
              Center(child: Text(emoji, style: TextStyle(fontSize: 22))),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _dot(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
      ),
    );
  }
}

